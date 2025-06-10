<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>메인화면</title>
<link rel="stylesheet" href="<c:url value='/resources/css/main.css' />">
</head>
<body>
<h1>메인메뉴</h1>
<div class="menu-container">

	<sec:authorize access="isAnonymous()">
        <a href="/customLogin" class="menu-item">
        	<div class="menu-icon">L.I/S</div>
        	<div><strong>로그인/회원가입</strong></div>
    	</a>
    </sec:authorize>
    <sec:authorize access="isAuthenticated()">
        <a href="/customLogout" class="menu-item">
        	<div class="menu-icon">L.O</div>
        	<div><strong>로그아웃</strong></div>
    	</a>
    </sec:authorize>
    
    <a href="/electric_fee.do" class="menu-item">
        <div class="menu-icon">E</div>
        <div><strong>전기요금표</strong></div>
    </a>
    <sec:authorize access="isAnonymous()">
    	<a href="/selectCustomer.do" class="menu-item">
        	<div class="menu-icon">C</div>
	        <div><strong>고객번호로 조회</strong><br/></div>
    	</a>
    </sec:authorize>
    <sec:authorize access="isAuthenticated()">
    	<a href="/proof.do" class="menu-item">
        	<div class="menu-icon">P</div>
        	<div><strong>요금납부</strong><br/>증명서 출력</div>
    	</a>
    	<a href="/chargecheck" class="menu-item">
        	<div class="menu-icon">Q</div>
        	<div><strong>상세요금조회</strong></div>
    	</a>
    </sec:authorize>
    
    
</div>
<!-- 로그인 여부에 따라 다른 메시지 출력 -->
<div style="margin-bottom: 20px">
    <sec:authorize access="isAnonymous()">
        <p style="color: gray; font-size: 14px;">※ 상세 요금 조회는 로그인 시 이용 가능합니다.</p>
    </sec:authorize>
    
    <sec:authorize access="isAuthenticated()">
        <%-- <p style="font-weight: bold; font-size: 16px;">
            사용자 ID : <sec:authentication property="principal.username"/><br/>
            사용자 이름 : <sec:authentication property="principal.member.username"/><br/>
            사용자 주소 : <sec:authentication property="principal.member.useraddr"/><br/>
            사용자 전화번호 : <sec:authentication property="principal.member.userphone"/><br/>
            사용자 권한 리스트 : <sec:authentication property="principal.member.authList"/>
        </p> --%>
        <p style="font-weight: bold; font-size: 16px;">
            반갑습니다. <sec:authentication property="principal.member.username"/>님.<br/>
            고객번호는 '상세요금조회'에서 확인하실 수 있습니다.
        </p>
    </sec:authorize>
</div>
</body>
</html>

