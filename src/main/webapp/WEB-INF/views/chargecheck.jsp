<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDate" %>

<%
    LocalDate now = LocalDate.now();
    int currentMonth = now.getMonthValue();
    int currentYear = now.getYear();
    request.setAttribute("currentMonth", currentMonth);
    request.setAttribute("currentYear", currentYear);
%>

<c:set var="user" value="${list[0]}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전기 사용량 및 청구금액 조회</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<link rel="stylesheet" href="<c:url value='/resources/css/chargecheck.css' />">

<script>
$(document).ready(function () {
	const address = "${user.useraddr}";
    const usageMap = {
        1: ${user.month1}, 2: ${user.month2}, 3: ${user.month3},
        4: ${user.month4}, 5: ${user.month5}, 6: ${user.month6},
        7: ${user.month7}, 8: ${user.month8}, 9: ${user.month9},
        10: ${user.month10}, 11: ${user.month11}, 12: ${user.month12}
    };

    async function getPublicData(month, address) {
    	try {
            const response = await fetch("/api/publicPowerUsage?month=" + month + "&address=" + encodeURIComponent(address));
            const json = await response.json();
            const data = json.data;

            let totalHouseCnt = 0;
            let weightedUsageSum = 0;
            let weightedBillSum = 0;

            for (const item of data) {
                const cnt = item.houseCnt;
                const usage = item.powerUsage;
                const bill = item.bill;

                totalHouseCnt += cnt;
                weightedUsageSum += usage * cnt;
                weightedBillSum += bill * cnt;
            }

            return {
                powerUsage: Math.round(weightedUsageSum / totalHouseCnt),
                bill: Math.round(weightedBillSum / totalHouseCnt),
                regionName: json.regionName
            };
        } catch (e) {
            console.error("공공데이터 요청 실패:", e);
            return { powerUsage: 0, bill: 0, regionName: "세종" };
        }
	}

    async function fetchCharges(use) {
        try {
            const res = await fetch(`/api/calculateCharges?usage=` + use);
            const data = await res.json();
            return data;
        } catch (e) {
            console.error("Failed to fetch charges:", e);
            return null;
        }
    }

    async function updateCharges(month) {
    	const use = usageMap[month];
        if (!use || isNaN(use)) {
            console.warn("Invalid usage for month", month);
            return;
        }

        const prevMonth = month === 1 ? 12 : month - 1;
        const prevUse = usageMap[prevMonth];
        const startDate = prevMonth + "/18";
        const endDate = month + "/17";
        const publicData = await getPublicData(month, address);
        const regionName = publicData.regionName;

        $("#usagePeriod").text(startDate + " ~ " + endDate);
        $(".this_month").text(use.toLocaleString());
        $(".prev_month").text(prevUse.toLocaleString());
        if (month !== 1) {
            $("#prev_usage_row").show();
        } else {
            $("#prev_usage_row").hide();
        }

        const charges = await fetchCharges(use);
        if (!charges) return;

        $("#basic").text(charges.basic.toLocaleString());
        $("#useCharge").text(charges.useCharge.toLocaleString());
        $("#sumCharge").text(charges.sumCharge.toLocaleString());
        $("#CE_charge").text(charges.ceCharge.toLocaleString());
        $("#FC_adjustment").text(charges.fcAdjustment.toLocaleString());
        $("#fund").text(charges.fund.toLocaleString());
        $("#addedTax").text(charges.addedTax.toLocaleString());
        $("#totalCharge").text(charges.totalCharge.toLocaleString());

        const ctx = document.getElementById('powerChart').getContext('2d');
        if (window.powerChart instanceof Chart) {
            window.powerChart.destroy();
        }
        window.powerChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['전력 사용량 (kWh)', '청구 금액 (100원 단위)'],
                datasets: [
                    {
                        label: month + '월 개인',
                        data: [use, charges.totalCharge / 100],
                        backgroundColor: ['#009cda', '#009cda']
                    },
                    {
                        label: month + '월 ' + regionName + ' 평균',
                        data: [publicData.powerUsage, publicData.bill / 100],
                        backgroundColor: ['salmon', 'salmon']
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.dataset.label + ': ' + context.raw.toLocaleString();
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: value => value.toLocaleString()
                        }
                    }
                }
            }
        });
    }

    const currentMonth = new Date().getMonth() + 1;
    $("#mon").val(currentMonth);
    updateCharges(currentMonth);

    $("#mon").on("change", function () {
        const month = parseInt($(this).val());
        updateCharges(month);
    });

    $(".hide_button").on("click", function () {
        const $button = $(this);
        const $table = $button.closest("table");
        const isFolded = $table.data("folded");
        if (isFolded) {
            $table.find("tr").not(":first").find("td").slideDown(100);
            $button.text("∧");
            $table.data("folded", false);
        } else {
            $table.find("tr").not(":first").find("td").slideUp(100);
            $button.text("∨");
            $table.data("folded", true);
        }
    });
});
</script>

<script>
window.onload = function () {
    <c:if test="${loginRequired}">
        alert("로그인 후 이용해주세요.");
        history.back();
    </c:if>
}
</script>
</head>
<body>

<!-- 고객 정보 -->
<div>
<table>
	<tr><th class="l_table">고객정보</th><th class="r_table"></th></tr>
	<tr>
		<td colspan="2">
			<div class="customer_value">
				<div id="name" class="innerdiv">
					<div class="l_table">성명</div>
					<div class="value">${user.username}</div>
				</div>
				<div id="address" class="innerdiv">
					<div class="l_table">주소</div>
					<div class="value">${user.useraddr}</div>
				</div>
				<div class="innerdiv">
					<div class="l_table">고객번호</div>
					<div class="value">${user.userno}</div>
				</div>
			</div>
		</td>
	</tr>
</table>

<!-- 사용량 -->
<br>
<table>
	<tr><th class="l_table">이번 달 검침/전기 사용량 <label>(단위:kWh)</label></th><th class="r_table hide_button">∧</th></tr>
	<tr><td class="l_table">전기 사용 기간</td><td class="r_table" id="usagePeriod"></td></tr>
	<tr><td class="l_table">검침일</td><td class="r_table">매월 17일</td></tr>
	<tr><td class="l_table">이달 사용량</td><td class="r_table this_month"></td></tr>
	<tr id="prev_usage_row"><td class="l_table">전월 사용량</td><td class="r_table prev_month"></td></tr>
</table>

<!-- 월 선택 -->
<br>
<table>
	<tr><td class="select1">청구 월 선택</td></tr>
	<tr>
		<td class="select2">
			<select name="month" id="mon">
				<option value="" disabled>-선택-</option>
				<c:forEach begin="1" end="${currentMonth}" var="i">
					<option value="${i}">${currentYear}년 ${i}월</option>
				</c:forEach>
			</select>
		</td>
	</tr>
</table>

<!-- 예상 청구금액 -->
<br>
<table>
	<tr><th class="l_table">이번 달 예상 청구금액 <label>(단위:원)</label></th><th class="r_table hide_button">∧</th></tr>
	<tr><td class="l_table">전기요금계</td><td class="r_table" id="sumCharge"></td></tr>
	<tr><td class="l_table">&nbsp;&nbsp;&nbsp;&nbsp;기본요금</td><td class="r_table" id="basic"></td></tr>
	<tr><td class="l_table">&nbsp;&nbsp;&nbsp;&nbsp;전력량 요금</td><td class="r_table" id="useCharge"></td></tr>
	<tr><td class="l_table">&nbsp;&nbsp;&nbsp;&nbsp;기후환경요금</td><td class="r_table" id="CE_charge"></td></tr>
	<tr><td class="l_table">&nbsp;&nbsp;&nbsp;&nbsp;연료비조정요금</td><td class="r_table" id="FC_adjustment"></td></tr>
	<tr><td class="l_table">부가 가치세</td><td class="r_table" id="addedTax"></td></tr>
	<tr><td class="l_table">전력기금</td><td class="r_table" id="fund"></td></tr>
	<tr class="sum"><td class="last_l_table">청구금액</td><td class="last_r_table" id="totalCharge"></td></tr>
	<tr><td colspan="2" class="l_table annotation">※예상 청구금액은 실제 요금과 다를 수 있습니다.</td></tr>
</table>
</div>

<!-- 그래프 -->
<br>
<div id="graph">
	<canvas id="powerChart" width="400" height="300"></canvas>
</div>

<!-- 메인 이동 -->
<div class="center-button">
    <form action="/main.do" method="get">
        <button type="submit">메인화면 이동</button>
    </form>
</div>

</body>
</html>
