<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>회원가입</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/signup.css' />">

    <!-- 카카오 주소 API 스크립트 추가 (주소 검색을 위한 API) -->
    <script type="text/javascript" src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        // 아이디 중복 체크
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

        // 비밀번호 유효성 검사
        const checkPassword = debounce(function() {
            const password = document.getElementById('userpw').value;
            const passwordError = document.getElementById('passwordError');

            if (!password) {
                passwordError.innerText = "";
                return;
            }
            fetch(contextPath + '/customer/checkPassword?password=' + encodeURIComponent(password))
                .then(res => res.json())
                .then(data => {
                    if (data.valid) {
                        passwordError.style.color = "green";
                        passwordError.innerText = "사용할 수 있는 비밀번호입니다.";
                    } else {
                        passwordError.style.color = "red";
                        passwordError.innerText = data.message;
                    }
                });

            checkRepassword();
        }, 300);

        // 비밀번호 재확인 유효성 검사
        const checkRepassword = debounce(function() {
            const password = document.getElementById('userpw').value;
            const repassword = document.getElementById('repassword').value;
            const repasswordError = document.getElementById('repasswordError');

            if (!repassword) {
                repasswordError.innerText = "";
                return;
            }

            fetch(contextPath + '/customer/checkRepassword?password=' + encodeURIComponent(password) + '&repassword=' + encodeURIComponent(repassword))
                .then(res => res.json())
                .then(data => {
                    if (data.valid) {
                        repasswordError.style.color = "green";
                        repasswordError.innerText = "비밀번호가 일치합니다.";
                    } else {
                        repasswordError.style.color = "red";
                        repasswordError.innerText = data.message;
                    }
                });
        }, 300);

        // 전화번호 유효성 검사
        const checkPhone = debounce(function() {
            const phone = document.getElementById('userphone').value.trim();
            const phoneError = document.getElementById('phoneError');

            if (!phone) {
                phoneError.innerText = "";
                return;
            }
            fetch(contextPath + '/customer/checkPhone?phone=' + encodeURIComponent(phone))
                .then(res => res.json())
                .then(data => {
                    phoneError.innerText = data.valid ? "" : data.message;
                });
        }, 300);

        // 주소 검색 함수
        function searchAddress() {
            new daum.Postcode({
                oncomplete: function(data) {
                    const postcode = data.zonecode;
                    const addr = data.roadAddress;
                    const extraAddr = data.bname ? data.bname : '';
                    document.getElementById('useraddr').value = addr + " " + extraAddr;
                }
            }).open();
        }

        // 디바운스 함수 (일정 시간 지연 후 실행)
        function debounce(func, delay) {
            let timeoutId;
            return function(...args) {
                clearTimeout(timeoutId);
                timeoutId = setTimeout(() => func.apply(this, args), delay);
            }
        }
    </script>
</head>
<body>
    <div class="signup-container">
        <form action="${pageContext.request.contextPath}/customer/signup" method="post">
            <h2>회원가입</h2>
            <div class="form-group">
                <label for="userid">아이디</label>
                <input type="text" id="userid" name="userid" class="form-control" oninput="checkIdDuplicate()">
                <span id="idError" class="error-message"></span>
            </div>

            <div class="form-group">
                <label for="userpw">비밀번호</label>
                <input type="password" id="userpw" name="userpw" class="form-control" oninput="checkPassword()">
                <span id="passwordError" class="error-message"></span>
            </div>

            <div class="form-group">
                <label for="repassword">비밀번호 확인</label>
                <input type="password" id="repassword" name="repassword" class="form-control" oninput="checkRepassword()">
                <span id="repasswordError" class="error-message"></span>
            </div>

            <div class="form-group">
                <label for="userphone">전화번호</label>
                <input type="text" id="userphone" name="userphone" class="form-control" oninput="checkPhone()">
                <span id="phoneError" class="error-message"></span>
            </div>

            <div class="form-group">
                <label for="useraddr">주소</label>
                <input type="text" id="useraddr" name="useraddr" class="form-control">
                <button type="button" class="btn btn-primary" onclick="searchAddress()">주소 검색</button>
            </div>

            <button type="submit" class="btn btn-success">회원가입</button>
        </form>
    </div>
</body>
</html>
