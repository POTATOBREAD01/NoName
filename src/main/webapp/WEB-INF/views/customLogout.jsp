<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://
www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그아웃 페이지</title>
<link rel="stylesheet" href="<c:url value='/resources/css/customLogout.css' />">
</head>
<body>
	<h1>로그아웃</h1>
	<div class="logoutdiv center-button">
	<form action="/main.do" method="get" class="button">
	        <button type="submit" class='main-btn'>메인화면 이동</button>
    </form>
    &nbsp;&nbsp;
	<form action="/customLogout" method='post'>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<button type='submit' class='logout-btn'>로그아웃 확인</button>
	</form>
	</div>
</body>
</html>