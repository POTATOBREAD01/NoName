<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>전기요금 구조</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/electric_fee.css' />">
</head>
<body>
<div class="container">
    <h2>전기요금 구조</h2>

    <div class="fee-structure">
        <div>기본요금</div>
        <div>+</div>
        <div>전력량요금</div>
        <div>+</div>
        <div class="highlight">기후환경요금</div>
        <div>+</div>
        <div class="highlight">연료비조정요금</div>
    </div>

    <div class="section">
        <div class="section-title">기후환경요금</div>
        <ul class="bullet">
            <li>깨끗하고 안전한 에너지 제공에 소요되는 비용 (RPS, ETS, 석탄발전 감축비용)</li>
            <li>부과방식 : <strong>기후환경요금 단가 × 사용전력량</strong></li>
        </ul>
    </div>

    <div class="section">
        <div class="section-title">연료비조정요금</div>
        <ul class="bullet">
            <li>연료비 변동분(석탄, 천연가스, 유류)을 반영하는 요금</li>
            <li>부과방식 : <strong>연료비조정단가 × 사용전력량</strong></li>
            <li>* 상한하한 : ±5원/kWh</li>
        </ul>
    </div>

    <div class="section note">
        <p><span>※ 청구금액 = 전기요금 + 부가가치세 + 전력산업기반기금</span></p>
        <ul class="bullet">
            <li>부가가치세(원미만 사사오입) : 전기요금 × 10%</li>
            <li>전력산업기반기금(10원미만 절사) : 전기요금 × 3.2%</li>
        </ul>
    </div>
</div>
<div class="center-button">
    <form action="/main.do" method="get">
        <button type="submit">메인화면 이동</button>
    </form>
</div>
</body>
</html>
