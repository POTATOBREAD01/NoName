<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:out value="${errorPhone}" escapeXml="false" />
<sec:csrfInput/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>회원가입</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/signup.css' />">
	<!-- CSRF 토큰을 JS에서 읽기 위한 메타태그 추가 -->
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <!-- 카카오 주소 API 스크립트 추가 (주소 검색을 위한 API) -->
    <script type="text/javascript" src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
    <!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script>
    $(function() {
	    const contextPath = '${pageContext.request.contextPath}';
	
	 	// 모든 항목 유효성 검사 변수 (초기에는 false로 두고, 유효성 검사를 통과하면 true로)
	    let isUsernoAvailable = false;
	    let isUseridAvailable = false;
	    let isUserpwAvailable = false;
	    let isUsernameAvailable = false;
	    let isUseraddrAvailable = false;
	    let isUserphoneAvailable = false;
	    let isEmailVerified = false;
	    
	    // debounce 함수 (jQuery 버전)
	    function debounce(func, wait) {
	        let timeout;
	        return function() {
	            clearTimeout(timeout);
	            timeout = setTimeout(() => func.apply(this, arguments), wait);
	        };
	    }
	    
	    // 주소 유효성 검사 함수
	    function validateAddress() {
	        const addr = $('#useraddr').val().trim();
	        const msg = $('#useraddrError');
	        const cities = ['서울', '부산', '대구', '인천', '광주', '대전', '울산', '세종', '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남', '제주'];
	        
	        const matchedCities = cities.filter(city => addr.includes(city));

	        if (matchedCities.length === 1) {
	            msg.text('유효한 주소입니다.').css('color', 'green');
	            isUseraddrAvailable = true;
	        } else if (matchedCities.length === 0) {
	            msg.text('주소에 도시 이름이 하나 포함되어야 합니다.').css('color', 'red');
	            isUseraddrAvailable = false;
	        } else {
	            msg.text('주소에 도시 이름이 두 개 이상 포함되어 있습니다.').css('color', 'red');
	            isUseraddrAvailable = false;
	        }
	    }
	    
	    // 주소 검색 이벤트
	    $('#searchAddrBtn').on('click', function() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                const addr = data.roadAddress;
	                const extraAddr = data.bname ? data.bname : '';
	                $('#useraddr').val(addr + " " + extraAddr);
	                validateAddress(); // 주소 유효성 검사
	            }
	        }).open();
	    });
	
	    // 고객번호 유효성 및 중복 검사
	    $('#userno').on('input', debounce(function() {
	        const userno = $(this).val().trim();
	        const msg = $('#usernoCheckMsg');
	        const regex = /^\d{4,10}$/;
	
	        if (!regex.test(userno)) {
	            msg.text('고객번호는 4~10자리 숫자여야 합니다.').css('color', 'red');
	            return;
	        }
	
	        $.getJSON(contextPath + '/customer/checkUserno', { userno: userno })
	            .done(function(data) {
	                if (data.valid) {
	                    msg.text('사용 가능한 고객번호입니다.').css('color', 'green');
	                    isUsernoAvailable = true;
	                } else {
	                    msg.text(data.message || '이미 등록된 고객번호입니다.').css('color', 'red');
	   					isUsernoAvailable = false;
	                }
	            })
	            .fail(function() {
	                msg.text('서버 오류가 발생했습니다.').css('color', 'red');
	            });
	    }, 400));
	
	    // 아이디 유효성 및 중복 검사
	    $('#userid').on('input', debounce(function() {
	        const userid = $(this).val().trim();
	        const msg = $('#idError');
	        const regex = /^[a-zA-Z0-9]{4,16}$/;
	
	        if (!regex.test(userid)) {
	            msg.text('아이디는 4~16자의 영문자 또는 숫자만\n허용됩니다.').css('color', 'red');
	            return;
	        }
	
	        $.getJSON(contextPath + '/customer/checkId', { id: userid })
	            .done(function(data) {
	                if (data.valid) {
	                    msg.text('사용 가능한 아이디입니다.').css('color', 'green');
	                    isUseridAvailable = true;
	                } else {
	                    msg.text(data.message || '이미 사용 중인 아이디입니다.').css('color', 'red');
	                    isUseridAvailable = false;
	                }
	            })
	            .fail(function() {
	                msg.text('서버 오류가 발생했습니다.').css('color', 'red');
	            });
	    }, 400));
	
	    // 비밀번호 유효성 검사 (클라이언트 기본 검사)
	    $('#userpw').on('input', function() {
	        const pw = $(this).val();
	        const msg = $('#passwordError');
	        const regex = /^(?=.*[a-zA-Z])(?=.*\d).{8,}$/;
	
	        if (!pw) {
	            msg.text('');
	            return;
	        }
	
	        if (regex.test(pw)) {
	            msg.text('사용할 수 있는 비밀번호입니다.').css('color', 'green');
	            isUserpwAvailable = true;
	        } else {
	            msg.text('비밀번호는 최소 8자 이상이며, 영문자와\n숫자를 포함해야 합니다.').css('color', 'red');
	            isUserpwAvailable = false;
	        }
	        $('#repassword').trigger('input'); // 재확인 검사 갱신
	    });
	
	    // 비밀번호 재확인 검사
	    $('#repassword').on('input', function() {
	        const pw = $('#userpw').val();
	        const repw = $(this).val();
	        const msg = $('#repasswordError');
	
	        if (!repw) {
	            msg.text('');
	            return;
	        }
	
	        if (pw === repw) {
	            msg.text('비밀번호가 일치합니다.').css('color', 'green');
	        } else {
	            msg.text('비밀번호가 일치하지 않습니다.').css('color', 'red');
	        }
	    });
	
	    // 전화번호 유효성 검사
	    $('#userphone').on('input', debounce(function() {
	        const phone = $(this).val().trim();
	        const msg = $('#phoneError');
	        const regex = /^\d{10,11}$/;
	
	        if (!phone) {
	            msg.text('');
	            isUserphoneAvailable = true;
	            return;
	        }
	
	        if (regex.test(phone)) {
	            msg.text('');
	            isUserphoneAvailable = true;
	        } else {
	            msg.text('전화번호는 숫자만 입력하며, 10자리\n또는 11자리여야 합니다.').css('color', 'red');
	            isUserphoneAvailable = false;
	        }
	    }, 400));
	
	    // 이메일 중복 및 유효성 검사
	    let isEmailAvailable = false;
	
	    $('#useremail').on('input', debounce(function() {
	        const email = $(this).val().trim();
	        const msg = $('#emailCheckMsg');
	        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	
	        isEmailAvailable = false;
	
	        if (!emailRegex.test(email)) {
	            msg.text('올바른 이메일 형식을 입력해주세요.').css('color', 'red');
	            return;
	        }
	
	        $.getJSON(contextPath + '/customer/checkEmail', { email: email })
	            .done(function(data) {
	                if (data.valid) {
	                    msg.text('사용 가능한 이메일입니다.').css('color', 'green');
	                    isEmailAvailable = true;
	                } else {
	                    msg.text(data.message || '이미 사용 중인 이메일입니다.').css('color', 'red');
	                }
	            })
	            .fail(function() {
	                msg.text('서버 오류가 발생했습니다.').css('color', 'red');
	            });
	    }, 500));
	
	    // 이메일 인증번호 발송
	    $('#sendAuthCodeBtn').click(function() {
	        if (!isEmailAvailable) {
	            alert('이메일 중복 확인을 먼저 해주세요.');
	            return;
	        }
	
	        const email = $('#useremail').val().trim();
	        if (!email) {
	            alert('이메일을 입력하세요.');
	            return;
	        }
	
	        $.getJSON(contextPath + '/customer/sendAuthCode', { email: email })
	            .done(function(data) {
	                if (data.success) {
	                    alert('인증번호가 이메일로 발송되었습니다.');
	                    $('#authCodeInput').prop('disabled', false);
	                    $('#verifyBtn').prop('disabled', false);
	                    $('#verifyBtn').removeClass("disable")
	                    $('#verifyBtn').addClass("enable")
	                } else {
	                    alert(data.message || '인증번호 발송에 실패했습니다.');
	                }
	            })
	            .fail(function() {
	                alert('서버 오류가 발생했습니다.');
	            });
	    });
	
	    // 이메일 인증번호 확인
	    $('#verifyBtn').click(function() {
	        const code = $('#authCodeInput').val().trim();
	        if (!code) {
	            alert('인증번호를 입력하세요.');
	            return;
	        }
	
	        const csrfToken = $('meta[name="_csrf"]').attr('content');
	        const csrfHeader = $('meta[name="_csrf_header"]').attr('content');
	
	        $.ajax({
	            url: contextPath + '/customer/verifyAuthCode',
	            method: 'POST',
	            data: { inputCode: code },
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader(csrfHeader, csrfToken);
	            },
	            success: function(data) {
	                if (data.valid) {
	                    alert('이메일 인증이 완료되었습니다.');
	                    $('#useremail').prop('readonly', true);
	                    $('#authCodeInput').prop('disabled', true);
	                    $('#verifyBtn').prop('disabled', true);
	                    $('#verifyBtn').removeClass("enable")
	                    $('#verifyBtn').addClass("enable_ok")
	                    isEmailVerified = true;
	                    $('button[type="submit"]').prop('disabled', false);
	                } else {
	                    alert(data.message || '인증번호가 일치하지 않습니다.');
	                    $('button[type="submit"]').prop('disabled', true);
	                }
	            },
	            error: function() {
	                alert('서버 오류가 발생했습니다.');
	                $('button[type="submit"]').prop('disabled', true);
	            }
	        });
	    });
		
	    // 이름 유효성 검사
	    $('#username').on('input', function() {
	        const name = $(this).val().trim();
	        const msg = $('#usernameError'); // 에러 메시지 출력용 span이 있다고 가정
	        const nameRegex = /^[a-zA-Z가-힣]{2,20}$/;

	        if (!name) {
	            msg.text('');
	            isUsernameAvailable = false;
	            return;
	        }

	        if (nameRegex.test(name)) {
	            msg.text('사용 가능한 이름입니다.').css('color', 'green');
	            isUsernameAvailable = true;
	        } else {
	            msg.text('이름은 2~20자의 한글 또는\n영문만 허용됩니다.').css('color', 'red');
	            isUsernameAvailable = false;
	        }
	    });
	    
	    // 주소 유효성 검사
	    $('#useraddr').on('input', validateAddress)
	    
	    // 폼 제출 시 간단한 최종 검증 (필요하면 서버 재검증)
	    $('#signupForm').submit(function(e) {
	        let errorMessages = [];

	    
	        if (!isUseridAvailable) {
	            errorMessages.push('아이디를 확인해주세요.');
	        }
	        if (!isUserpwAvailable) {
	            errorMessages.push('비밀번호를 확인해주세요.');
	        }
	        if (!isUsernameAvailable) {
	            errorMessages.push('이름을 확인해주세요.');
	        }
	        if (!isUseraddrAvailable) {
	            errorMessages.push('주소를 확인해주세요.');
	        }
	        if (!isUserphoneAvailable) {
	            errorMessages.push('전화번호를 확인해주세요.');
	        }
	        
	        if (!isEmailVerified) {
	            errorMessages.push('이메일 인증을 완료해주세요.');
	        }

	        if (errorMessages.length > 0) {
	            e.preventDefault(); // 제출 막기

	            // 항목별로 한 줄씩 alert 출력
	            alert(errorMessages.join('\n'));
	        }
		});
	});
    </script>
</head>
<body>

    <div class="signup-container">
    <h1>회원가입</h1><br>
        <form action="${pageContext.request.contextPath}/customer/signup" method="post" id="signupForm">
        
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        	<!-- 고객번호 -->
        	<div class="form-group">
        		<span class="text">&lt;고객번호&gt;</span><br>
				<input type="" readonly id="userno" name="userno" class='form-control' placeholder="고객번호" oninput="checkUsernoDuplicate()" />
        	</div>
        	<span id="usernoCheckMsg" style="white-space: pre-line;"></span>
        	<!-- 아이디 -->
            <div class="form-group">
                <input type="text" id="userid" name="userid" class="form-control" oninput="checkIdDuplicate()" placeholder="아이디"><br>
            </div>
            <span id="idError" class="error-message" style="white-space: pre-line;"></span>
           
            <!-- 이름 -->
			<div class="form-group">
            <input type="text" id="username" name="username" class="form-control" placeholder="이름" required>
            </div>
            <span id="usernameError" class="error" style="white-space: pre-line;"></span>

			<!-- 비밀번호 -->
            <div class="form-group">
            	<div class="input-wrapper">
    			<input type="password" id="userpw" name="userpw" class="form-control" oninput="checkPassword()" placeholder="비밀번호">
    			<span class="eye" id="togglePw">
        			<i class="fa-solid fa-eye"></i>
    			</span>
    			</div>
    			<span id="passwordError" class="error-message" style="white-space: pre-line;"></span>
			</div>

			<!-- 비밀번호 확인 -->
			<div class="form-group">
				<div class="input-wrapper">
    			<input type="password" id="repassword" name="repassword" class="form-control" oninput="checkRepassword()" placeholder="비밀번호 확인">
    			<span class="eye" id="toggleRePw">
        			<i class="fa-solid fa-eye"></i>
    			</span>
    			</div>
    			<span id="repasswordError" class="error-message" style="white-space: pre-line;"></span>
			</div>
			<!-- 전화번호 -->
            <div class="form-group">
                <input type="text" id="userphone" name="userphone" class="form-control" oninput="checkPhone()" placeholder="전화번호"><br>
                <span id="phoneError" class="error-message" style="white-space: pre-line;"></span>
            </div>
			<!-- 주소 -->
            <div class="form-group">
            	<input type="text" id="useraddr" name="useraddr" class="form-control" placeholder="주소" required>
        	</div>
        	<div>
	            <button type="button" class="btn btn-primary" id="searchAddrBtn">주소 검색</button>
        	</div>
            <!-- 이메일 입력 및 중복 확인 -->
            <div class="form-group">
			<input type="email" id="useremail" name="useremail" class="form-control"
			       placeholder="이메일" oninput="checkEmailDuplicate()" required>
		    <br>
		    <span id="emailCheckMsg" class="error-message" style="white-space: pre-line;"></span>
			</div>
			<!-- 이메일 인증 -->
        	<div class="form-group">
            	<button type="button" class="btn btn-secondary" id="sendAuthCodeBtn">인증번호 발송</button>
            	<br>
            	<span id="emailSendMsg" class="info-message" style="white-space: pre-line;"></span>
        	</div>

        	<div class="form-group">
	            <input type="text" id="authCodeInput" class="form-control" placeholder="인증번호 입력" disabled><br>
            	<button type="button" class="btn btn-secondary disable" id="verifyBtn" onclick="verifyAuthCode()" disabled>인증번호 확인</button>
            	<br>
            	<span id="emailAuthMsg" class="error-message" style="white-space: pre-line;"></span>
        	</div>
        	
			<div>
            <button type="submit" class="btn btn-success">회원가입</button>
            </div>
        </form>
    </div>
    <!-- 메인 이동 -->
	<div class="center-button">
    	<form action="/main.do" method="get">
	        <button type="submit">메인화면 이동</button>
    	</form>
	</div>
<script>
function togglePasswordVisibility(toggleId, inputId) {
    const toggle = document.getElementById(toggleId);
    const input = document.getElementById(inputId);
    const icon = toggle.querySelector('i');

    toggle.addEventListener('click', () => {
        const isPassword = input.type === 'password';
        input.type = isPassword ? 'text' : 'password';
        icon.classList.toggle('fa-eye');
        icon.classList.toggle('fa-eye-slash');
    });
}

// 초기화
document.addEventListener('DOMContentLoaded', () => {
    togglePasswordVisibility('togglePw', 'userpw');
    togglePasswordVisibility('toggleRePw', 'repassword');
});


document.addEventListener("DOMContentLoaded", function () {
    fetch("${pageContext.request.contextPath}/customer/generateUserno")
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                document.getElementById("userno").value = data.userno;
               
            } else {
                
            }
        })
        .catch(err => {
            
        });
});


</script>
</body>
</html>
