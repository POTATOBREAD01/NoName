<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 선택</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/select.css' />">
    <script type="text/javascript" src="/resources/js/select.js"></script>
</head>
<body>
<div class="container">
    <h2>아래 등록된 회원을 선택해주세요</h2>

    <div class="top-bar">
        <c:if test="${not empty members}">
            <span class="member-count">
                등록 회원 <strong><c:out value="${fn:length(members)}" /></strong>
            </span>
        </c:if>

        <!-- 검색 폼 -->
        <form class="search-form" method="get" action="<c:url value='/searchCustomer.do' />" onsubmit="return validateSearch()">
            <input type="text" name="userno" id="userno" placeholder="고객 번호 검색"
                   value="${param.userno != null ? param.userno : ''}" />
            <button type="submit">🔍</button>
        </form>

        <!-- 상단 버튼 영역 -->
        <div class="action-buttons">
            <!-- 전체 조회 취소 -->
            <form method="post" action="<c:url value='/customer/clearSearch' />" style="display:inline;" onsubmit="return validateClearSearch()">
                <sec:csrfInput />
                <button type="submit">전체 조회 취소</button>
            </form>
            <button onclick="location.href='<c:url value='/main.do'/>'">메인화면 이동</button>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>

    <div class="member-list">
        <c:choose>
            <c:when test="${empty members}">
                <div class="no-members">
                    <p>현재 등록된 회원이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="member" items="${members}">
                    <div class="member-card">
                        <div class="member-info">
                            <div><strong>고객번호</strong><br>${member.userno}</div>
                            <div><strong>성명</strong><br>${member.username}</div>
                            <div><strong>전화번호</strong><br>${member.userphone}</div>
                            <div><strong>주소</strong><br>${member.useraddr}</div>
                        </div>

                        <div class="button-group">
                            <!-- 증명서 출력 -->
                            <form method="get" action="<c:url value='/proof.do' />" class="output-form" style="display:inline;">
                                <input type="hidden" name="userid" value="${member.userid}" />
                                <button type="submit" class="action-button">증명서 출력</button>
                            </form>

                            <!-- 개별 조회 취소 -->
                            <form method="post" action="<c:url value='/customer/removeCustomer' />" style="display:inline;">
                                <sec:csrfInput />
                                <input type="hidden" name="userid" value="${member.userid}" />
                                <button type="submit" class="action-button cancel-button">조회 취소</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>