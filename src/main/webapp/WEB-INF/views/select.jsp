<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>고객번호 선택</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/select.css' />">
</head>
<body>
<div class="container">
    <h2>아래 등록 고객번호를 선택해주세요</h2>

    <div class="top-bar">
        <c:if test="${not empty customers}">
            <span class="customer-count">
                등록 고객번호 <strong><c:out value="${fn:length(customers)}" /></strong>
            </span>
        </c:if>

        <form class="search-form" method="get" action="searchCustomer.do">
            <input type="text" name="keyword" placeholder="고객번호, 성명, 주소, 별명 검색" />
            <button type="submit">🔍</button>
        </form>

        <div class="action-buttons">
            <button onclick="location.href='main.do'">메인화면</button>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>

    <div class="customer-list">
        <c:choose>
            <c:when test="${empty customers}">
                <div class="no-customers">
                    <p>현재 등록된 고객이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="customer" items="${customers}">
                    <div class="customer-card">
                        <div class="customer-info">
                            <div><strong>고객번호</strong><br>${customer.userno}</div>
                            <div><strong>성명</strong><br>${customer.name}</div>
                            <div><strong>아이디</strong><br>${customer.id}</div>
                            <div><strong>전화번호</strong><br>${customer.phone}</div>
                            <div><strong>주소</strong><br>${customer.address}</div>
                        </div>

                        <div class="button-group">
                            <form method="get" action="proof.do" class="output-form">
                                <input type="hidden" name="userno" value="${customer.userno}" />
                                <button type="submit" class="action-button">증명서 출력</button>
                            </form>

                            <%-- 조회 취소 버튼 (폼 제출) --%>
                        <form method="get" action="selectCustomer.do" class="delete-form">
                            <button type="submit" class="action-button">조회 취소</button>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>

