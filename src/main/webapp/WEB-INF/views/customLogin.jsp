<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://
www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/customLogin.css' />">
</head>
<body>

	<h1>Custom Login Page</h1>
	<h2><c:out value="${error}"/></h2>
	<h2><c:out value="${logout}"/></h2>
	<br>
	<div id="logindiv">
	<form method='post' action='/login'>
		<div class="innerdiv">
			<div>
				<input type='text' name='username' value='' placeholder="아이디" class="inputbox">
			</div>
			<div>
				<input type='password' name='password' value='' placeholder="비밀번호" class="inputbox">
			</div>
		</div>
		<div class="innerdiv">
			<div>
				<input type='submit' class="submitbox" value="로그인">
			</div>
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	</form>
	</div>
	<!-- 메인 이동 -->
	<div class="center-button">
    	<form action="/main.do" method="get">
	        <button type="submit">메인화면 이동</button>
    	</form>
	</div>
</body>
</html>