<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>
<%
    LocalDate now = LocalDate.now();
    int currentMonth = now.getMonthValue();
    int currentYear = now.getYear();
    request.setAttribute("currentMonth", currentMonth);
    request.setAttribute("currentYear", currentYear);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전기요금 납부증명서</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/proof.css' />">
    <script type="text/javascript" src="/resources/js/proof.js"></script>
</head>
<body>
    <h1>전기요금 납부증명서</h1>

    <section class="section">
        <table class="info-table">
            <tr>
                <th>고객번호</th>
                <td>${member.userno}</td>
                <th>증명서 사용목적</th>
                <td>
                    <div class="radio-options">
                        <label>
                            <input type="radio" name="purpose" value="세무서 제출용" checked onclick="updatePurposeText(this)"> 세무서 제출용
                        </label>
                        <label>
                            <input type="radio" name="purpose" value="개인 지참용" onclick="updatePurposeText(this)"> 개인 지참용
                        </label>
                    </div>
                    <span id="selectedPurposeText" class="print-only">개인 지참용</span>
                </td>
            </tr>
        </table>
    </section>

    <section class="section">
        <h2>납부자 정보</h2>
        <table class="info-table">
            <tr><th>회원 아이디</th><td colspan="3">${member.userid}</td></tr>
            <tr><th>성명</th><td>${member.username}</td><th>전화번호</th><td>${member.userphone}</td></tr>
            <tr><th>주소</th><td colspan="3">${member.useraddr}</td></tr>
            <tr><th>총전기요금 납부금액</th><td colspan="3">${totalAmount} 원</td></tr>
        </table>
    </section>

    <section class="section">
        <h2>전기요금 납부내역</h2>
        <table class="bill-table">
            <thead>
                <tr>
                    <th>납월별</th>
                    <th>사용량(kWh)</th>
                    <th>금액(원)</th>
                    <th>수납일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="usage" items="${member.monthlyUsage}" varStatus="status">
                    <c:set var="month" value="${status.index + 1}" />
                    <c:if test="${month <= currentMonth}">
                        <c:set var="monthStr" value="${month lt 10 ? '0' + month : month}" />
                        <tr>
                            <td>${currentYear}.${monthStr}</td>
                            <td>${usage}</td>
                            <td>${realCharges[status.index]}</td>
                            <td>${currentYear}.${monthStr}.25</td>
                        </tr>
                    </c:if>
                </c:forEach>
            </tbody>
        </table>

        <div class="button-area">
            <button class="print" onclick="window.print();">인쇄</button>
            <button class="print-list" onclick="location.href='<c:url value="/main.do" />'">메인페이지 이동</button>
        </div>
    </section>
</body>
</html>
