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
	<a href="/customLogin" class="menu-item">
        <div class="menu-icon">L</div>
        <div><strong>로그인</strong></div>
    </a>
    <a href="/electric_fee.do" class="menu-item">
        <div class="menu-icon">E</div>
        <div><strong>전기요금표</strong></div>
    </a>
    <a href="/selectCustomer.do" class="menu-item">
        <div class="menu-icon">C</div>
        <div><strong>고객번호/조회</strong><br/></div>
    </a>
    <a href="/chargecheck" class="menu-item">
        <div class="menu-icon">Q</div>
        <div><strong>요금조회</strong></div>
    </a>
    <a href="/proof.do" class="menu-item">
        <div class="menu-icon">P</div>
        <div><strong>요금납부</strong><br/>증명서 출력</div>
    </a>
</div>
<a href="/customer/signup">회원가입</a>
<!-- 로그인 여부에 따라 다른 메시지 출력 -->
<div style="margin-bottom: 20px">
    <sec:authorize access="isAnonymous()">
        <p style="color: gray; font-size: 14px;">※ 로그인 시 간단한 데이터 출력해드립니다.</p>
    </sec:authorize>
    
    <sec:authorize access="isAuthenticated()">
        <p style="font-weight: bold; font-size: 16px;">
            사용자 ID : <sec:authentication property="principal.username"/><br/>
            사용자 이름 : <sec:authentication property="principal.member.username"/><br/>
            사용자 주소 : <sec:authentication property="principal.member.useraddr"/><br/>
            사용자 전화번호 : <sec:authentication property="principal.member.userphone"/><br/>
            사용자 권한 리스트 : <sec:authentication property="principal.member.authList"/>
        </p>
        <a href="/customLogout">로그아웃</a>
    </sec:authorize>
</div>
</body>
</html>

