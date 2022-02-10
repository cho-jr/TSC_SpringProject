<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/include/addressAPI.jsp"/>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script src="${ctp}/js/joinForm.js"></script>
<script type="text/javascript">
	//이메일 중복확인
	//새 창 띄우지 말고 Ajax 처리!
	function newEmailChk() {
		var regexEmail = /^[a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		var email = joinForm.email.value;
		
		if(email=="") {
			alert("이메일을 입력하세요.");
			joinForm.email.focus();
			return false;
		} else if (!regexEmail.test(email)) {
			alert("이메일 형식이 올바르지 않습니다.");
			joinForm.email.focus();
			return false;
		}

		var query = { email: email };
		$.ajax({
			type : "post",
			url : "${ctp}/member/checkEmail",
			data : query,
			success : function(data) {
				if(data == "1") {
					alert("사용가능한 이메일 입니다. ");
					checkedEmail = true;
					$("#emailChkBtn").removeClass('btn-outline-danger');
					$("#emailChkBtn").addClass('btn-danger');
					joinForm.nick.focus();
				} else {
					alert("사용불가능한 이메일 입니다. ");
					joinForm.email.value="";
					joinForm.email.focus();
				}
			}, 
			error : function() {
				alert("전송 오류");
			}
		});
	}
	
	// 이메일 입력창 수정시
	function changeEmail() {
		checkedEmail = false;
		$("#emailChkBtn").addClass('btn-outline-danger');
		$("#emailChkBtn").removeClass('btn-danger');
	}
	
	// 닉네임 중복확인
	function newNickChk() {
		var regexNick = /^[가-힣0-9]{2,10}$/g; // 2~10자리 한글, 숫자
		var nick = joinForm.nick.value;	
		
		if(nick=="") {
			alert("닉네임을 입력하세요.");
			joinForm.nick.focus();
			return false;
		} else if (!regexNick.test(nick)) {
			alert("닉네임 형식이 올바르지 않습니다.");
			joinForm.nick.focus();
			return false;
		}
		
		var url = "${ctp}/member/checkNickName";
		$.ajax({
			type: "post",
			url: url,
			data: { nick: nick },
			success: function(data) {
				if (data == "1") {
					alert("사용가능한 닉네임 입니다. ");
					checkedNickName = true;
					$("#nickChkBtn").removeClass('btn-outline-danger');
					$("#nickChkBtn").addClass('btn-danger');
					joinForm.pwd.focus();
				} else {
					alert("사용불가능한 닉네임 입니다. ");
					joinForm.nick.value="";
					joinForm.nick.focus();
				}
			}
		});
	}
	
	// 닉네임 입력창 수정시
	function changeNickName() {
		checkedNickName = false;
		$("#nickChkBtn").addClass('btn-outline-danger');
		$("#nickChkBtn").removeClass('btn-danger');
	}
</script>
</head>
<body>
	<header><%@ include file="/WEB-INF/views/include/header.jsp"%></header>
	<nav><%@ include file="/WEB-INF/views/include/nav.jsp"%></nav>
	<section>
		<div class="container">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">회원가입</h4>
					</div>
					<div class="modal-body">
						<div>
					        <form name="joinForm" method="post" class="needs-validation" novalidate >
						        <div class="mt-4">* 표시 항목은 필수 입력해야 합니다. </div>
						        <!-- 이름 -->
								<div class="form-group">
									<div class="input-group mt-1">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fas fa-user" aria-hidden="true"></i></span>
										</div>
										<input type="text" class="form-control" placeholder="* 이름" name="name" id="name" required>
									</div>
									<div><p id="nameCheckMessage" class="mt-2"></p></div>
								</div>
								<!-- 이메일 -->
								<div class="form-group">
									<div class="input-group mt-4">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fas fa-envelope" aria-hidden="true"></i></span>
										</div>
										<input type="text" class="form-control" placeholder="* 이메일" name="email" id="email" required onchange="changeEmail()" />
										<div class="input-group-append">
											<button id="emailChkBtn" class="btn btn-outline-danger" type="button" onclick="newEmailChk();">중복 확인</button>
										</div>
									</div>
									<div><p id="emailCheckMessage" class="mt-2"></p></div>
								</div>
								<!-- 닉네임 -->
								<div class="form-group">
									<div class="input-group mt-4">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fas fa-user" aria-hidden="true"></i></span>
										</div>
										<input type="text" class="form-control" placeholder="* 닉네임" name="nick" id="nick" required onchange="changeNickName()" />
										<div class="input-group-append">
											<button id="nickChkBtn" class="btn btn-outline-danger" type="button" onclick="newNickChk();">중복 확인</button>
										</div>
									</div>
									<div><p id="nickCheckMessage" class="mt-2"></p></div>
								</div>
								<!-- 비번 -->
								<div class="form-group">
									<div class="input-group mt-4">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fa fa-lock" aria-hidden="true"></i></span>
										</div>
										<input type="password" class="form-control" placeholder="* 비밀번호" name="pwd" id="pwd" required>
									</div>
									<div>
										<p id="pwdCheckMessage" class="mt-2"></p>
									</div>
								</div>
								<!-- 비번 체크 -->
								<div class="form-group">
									<div class="input-group mt-4">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fa fa-lock" aria-hidden="true"></i></span>
										</div>
										<input type="password" class="form-control" placeholder="* 비밀번호 확인" id="pwdChk" required />
									</div>
									<div>
										<p id="pwCheckMessage" class="mt-2"></p>
									</div>
								</div>
								<!-- 연락처 -->
								<div class="form-group">
									<div class="input-group mt-4">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="fa fa-phone" aria-hidden="true"></i></span>
										</div>
										<input type="tel" class="form-control" placeholder="연락처(숫자만 입력하세요)" id="phone" name="phone" required />
									</div>
									<div>
										<p id="phoneCheckMessage" class="mt-2"></p>
									</div>
								</div>
								<!-- 생년월일 -->
								<div class="form-group justify-content-center mb-4">
									<div class="input-group">
										<div class="input-group-prepend">
											<span class="input-group-text">생년월일</span>
										</div>
										<input type="date" name="birth" id="birth" value="1990-01-01" class="form-control" />
									</div>
								</div>
								<!-- 주소 추가 -->
								<div class="form-group">
									<div class="input-group mb-1">
										<div class="input-group-prepend">
											<span class="input-group-text">주소</span>
										</div>
										<input type="text" name="addrCode" id="sample4_postcode" placeholder="우편번호" class="form-control" required > 
										<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-danger"><br>
									</div>
									<div class="input-group">
										<input type="text" name="addr1" id="sample4_roadAddress" class="form-control" placeholder="도로명주소" required > 
										<span id="guide" style="color: #999; display: none"></span> 
										<input type="text" name="addr2" id="sample4_detailAddress" class="form-control" placeholder="상세주소" required > 
										<input type="text" name="addr3" id="sample4_extraAddress" class="form-control" placeholder="참고항목" required >
									</div>
								</div>
								<!-- 약관 동의 체크박스 -->
								<div class="form-group form-check custom-control custom-switch"
									onclick="fCheck()">
									<label class="form-check-label"> 
										<input class="custom-control-input" type="checkbox" name="agree" id="agree" required> 
										<label class="custom-control-label" for="agree">* 약관에 동의합니다.</label>
										 * 약관에 동의합니다.
									</label>
									<div class="valid-feedback">Valid.</div>
									<div class="invalid-feedback">Check this checkbox to continue.</div>
									<br /> 
									<span class="btn-link" data-toggle="collapse" data-target="#term">(약관 보기)</span>
									<div id="term" class="collapse border">
										우리 회사 약관 <br /> 
										1조 1항. 어쩌구 Lorem ipsum dolor sit amet,
										consectetur adipisicing elit,<br /> 
										1조 2항. 저쩌구 sed do eiusmod
										tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
										minim veniam, quis nostrud exercitation ullamco laboris nisi
										ut aliquip ex ea commodo consequat.
									</div>
								</div>
								<button type="button" class="btn btn-danger" onclick="fSubmit()" style="float:right;">가입</button>
						    </form>
					    </div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>