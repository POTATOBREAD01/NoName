<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>에러 발생</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            text-align: center;
            padding: 100px;
        }
        .error-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
            display: inline-block;
        }
        h1 {
            color: #d9534f;
        }
        p {
            font-size: 1.2em;
            margin: 10px 0;
        }
        a, button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 1em;
            font-weight: bold;
            color: #337ab7;
            background-color: transparent;
            border: 2px solid #337ab7;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        a:hover, button:hover {
            background-color: #337ab7;
            color: white;
        }
    </style>
</head>
<body>
<div class="error-container">
    <h1>오류가 발생했습니다</h1>
    <p>잘못된 요청이거나 필요한 정보가 누락되었습니다.</p>
    <p>다시 시도하거나 메인 페이지로 돌아가세요.</p>

    <!-- 메인 페이지로 이동 -->
    <a href="<c:url value='/main.do' />">메인 페이지로 이동</a>
</div>
</body>
</html>

