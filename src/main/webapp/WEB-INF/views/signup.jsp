<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>회원가입</title>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function debounce(func, delay) {
            let timeoutId;
            return function(...args) {
                clearTimeout(timeoutId);
                timeoutId = setTimeout(() => func.apply(this, args), delay);
            }
        }

        // 중복확인 버튼 클릭 시 실행되는 함수
        function checkIdDuplicate() {
            const id = document.getElementById('userid').value.trim();
            const idError = document.getElementById('idError');

            if (!id) {
                idError.style.color = "red";
                idError.innerText = "아이디를 입력하세요.";
                return;
            }

            fetch(contextPath + '/customer/checkId?id=' + encodeURIComponent(id))
                .then(res => res.json())
                .then(data => {
                    if (data.valid) {
                        idError.style.color = "green";
                        idError.innerText = "사용 가능한 아이디입니다.";
                    } else {
                        idError.style.color = "red";
                        idError.innerText = data.message;
                    }
                })
                .catch(() => {
                    idError.style.color = "red";
                    idError.innerText = "서버 오류가 발생했습니다.";
                });
        }

        // 아이디 입력 필드에 입력 중일 때 중복확인 메시지 초기화
        function clearIdError() {
            document.getElementById('idError').innerText = "";
        }

        const checkPassword = debounce(function() {
            const password = document.getElementById('userpw').value;
            if (!password) {
                document.getElementById('passwordError').innerText = "";
                return;
            }
            fetch(contextPath + '/customer/checkPassword?password=' + encodeURIComponent(password))
                .then(res => res.json())
                .then(data => {
                    document.getElementById('passwordError').innerText = data.valid ? "" : data.message;
                });

            checkRepassword();
        }, 300);

        const checkRepassword = debounce(function() {
            const password = document.getElementById('userpw').value;
            const repassword = document.getElementById('repassword').value;
            if (!repassword) {
                document.getElementById('repasswordError').innerText = "";
                return;
            }
            fetch(contextPath + '/customer/checkRepassword?password=' + encodeURIComponent(password) + '&repassword=' + encodeURIComponent(repassword))
                .then(res => res.json())
                .then(data => {
                    document.getElementById('repasswordError').innerText = data.valid ? "" : data.message;
                });
        }, 300);

        const checkPhone = debounce(function() {
            const phone = document.getElementById('userphone').value.trim();
            if (!phone) {
                document.getElementById('phoneError').innerText = "";
                return;
            }
            fetch(contextPath + '/customer/checkPhone?phone=' + encodeURIComponent(phone))
                .then(res => res.json())
                .then(data => {
                    document.getElementById('phoneError').innerText = data.valid ? "" : data.message;
                });
        }, 300);

        window.onload = function() {
            // 중복확인 버튼 클릭 이벤트 연결
            document.getElementById('checkIdBtn').addEventListener('click', checkIdDuplicate);

            // 아이디 입력시 중복확인 메시지 초기화
            document.getElementById('id').addEventListener('input', clearIdError);
        }
    </script>
</head>
<body>
<h2>회원가입</h2>
<form action="${contextPath}/customer/signup" method="post" id="signupForm">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <label for="username">이름:</label>
    <input type="text" id="username" name="username" value="${memberVO.username}" required />
    <br/>

    <label for="id">아이디:</label>
    <input type="text" id="userid" name="userid" value="${memberVO.userid}" required />
    <button type="button" id="checkIdBtn">중복확인</button>
    <span id="idError" style="color:red;"></span>
    <br>

    <label for="userpw">비밀번호:</label>
    <input type="password" id="userpw" name="userpw" oninput="checkPassword()" required />
    <span id="passwordError" style="color:red;">
        <c:out value="${errorPassword}" />
    </span>
    <br/>

    <label for="repassword">비밀번호재확인:</label>
    <input type="password" id="repassword" name="repassword" oninput="checkRepassword()" required />
    <span id="repasswordError" style="color:red;">
        <c:out value="${errorRepassword}" />
    </span>
    <br/>

    <label for="userphone">전화번호:</label>
    <input type="text" id="userphone" name="userphone" value="${memberVO.userphone}" oninput="checkPhone()" required />
    <span id="phoneError" style="color:red;">
        <c:out value="${errorPhone}" />
    </span>
    <br/>

    <label for="useraddr">주소:</label>
    <input type="text" id="useraddr" name="useraddr" value="${memberVO.useraddr}" required />
    <br/>

    <button type="submit">회원가입</button>
</form>
</body>
</html>

