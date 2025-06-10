<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://
www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인 페이지</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" href="<c:url value='/resources/css/customLogin.css' />">
</head>
<body>

	
	<div id="logindiv">
	<h1>로그인</h1>
	<h3><c:out value="${error}"/></h3>
	<h3><c:out value="${logout}"/></h3>
	<br>
	<form method='post' action='/login'>
		<div class="innerdiv">
			<div>
				<input type='text' name='username' placeholder="아이디" class="inputbox">
			</div>
			<div class="input-wrapper">
    			<input type='password' name='password' id="password" placeholder="비밀번호" class="inputbox">
    			<span class="eye" id="togglePassword">
        			<i class="fa-solid fa-eye"></i>
    				</span>
			</div>
		</div>
		<div class="innerdiv">
			<div>
				<input type='submit' class="submitbox" value="로그인">
			</div>
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	</form>
	<form action="/customer/signup" class="button">
		<div class="innerdiv">
			<div>
				<input type='submit' class="submitbox2" value="회원가입">
			</div>
		</div>
	</form>
	</div>
	<!-- 메인 이동 -->
	<div class="center-button">
    	<form action="/main.do" method="get" class="button">
	        <button type="submit">메인화면 이동</button>
    	</form>
		<!-- &nbsp;&nbsp;
    	<form action="/customer/signup" class="button">
    		<button type="submit">회원가입</button>
    	</form> -->
	</div>
</body>
<script type="text/javascript" src="/resources/js/customLogin.js"></script>
</html>