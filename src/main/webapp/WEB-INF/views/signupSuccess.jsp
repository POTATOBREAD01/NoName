<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 성공</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/signupSuccess.css' />">

</head>
<body>
	<div class="success_div">
    <h2>회원가입이 완료되었습니다!</h2>
    <div class="center-button">
    	<form action="/customLogin" method="get">
	        <button type="submit">로그인 페이지로 이동</button>
    	</form>
	</div>
    </div>
</body>
</html>
