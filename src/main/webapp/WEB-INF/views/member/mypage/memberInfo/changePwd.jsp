<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script>
	// 비번 정규화 확인
	function fCheck() {
		//특수문자 / 문자 / 숫자 포함 형태의 8~15자리 이내의 암호 정규식
		var regexpwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/; 
		let pwd = document.getElementById("pwd").value;
		if (!regexpwd.test(pwd)) {
			document.getElementById("pwdCheckMessage").innerHTML = "<div class='text-danger'>8-15자리 영문, 숫자, 특수문자(!@#$%^&+=)만 사용 가능합니다. 😅</div>";
			return false;
		} else {
			document.getElementById("pwdCheckMessage").innerHTML = "<div class='text-success'>안전하게 지킬게요! 😎</div>";
		}

		// 비번확인
		if (document.getElementById("pwd").value == "") {
			document.getElementById("pwCheckMessage").innerHTML = "";
			return false;
		}
		if (!regexpwd.test(pwd)) {
			document.getElementById("pwCheckMessage").innerHTML = "<div class='text-danger'>비밀번호 먼저 수정해주세요 😏 </div>";
			return false;
		}
		else if (document.getElementById("pwd").value != document.getElementById("pwdChk").value) {
			document.getElementById("pwCheckMessage").innerHTML = "<div class='text-danger'>비밀번호가 일치하지 않습니다. 😅</div>";
			return false;
		}
		else {
			document.getElementById("pwCheckMessage").innerHTML = "<div class='text-success'>비밀번호가 일치합니다. 😎</div>";
			return true;
		}
	}
	document.onkeyup = fCheck;
	
	// 닉네임 변경 처리
	function fSubmit() {
		if(!fCheck()) {
			alert("비밀번호/비밀번호 확인란을 다시 확인해주세요.");
			return false;
		}
		var pwd = document.getElementById("pwd").value
		var oldpwd = document.getElementById("oldpwd").value
		// ajax DB 변경 후 자식창 닫기 부모창 새로고침
		$.ajax({ 
			type: "post", 
			url: "${ctp}/member/mypage/memberInfo/changePwd", 
			data: {oldpwd:oldpwd, pwd:pwd}, 
			success: function(data) {
				if(data=="1"){
					alert("비밀번호가 변경되었습니다. ");
					window.close();
					opener.parent.location.reload();
				} else {
					alert("기존 비밀번호가 일치하지 않습니다. ");
					document.getElementById("oldpwd").focus();
				}
			}, 
			error: function() {
				alert("전송오류");
			}
		});
	}
</script>
</head>
<body style="overflow-x: hidden;">
	<section>
		<div style="width:500px;margin:0 auto;">
			<br/>
			<div class="modal-dialog">
			    <div class="modal-content">
			        <!-- Modal Header -->
			        <div class="modal-header">
			            <h4 class="modal-title">비밀번호 변경</h4>
			        </div>
			        <!-- Modal body -->
			        <div class="modal-body">
			        	<!-- 비번 -->
						<div class="form-group">
							<div class="input-group mt-4">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-lock" aria-hidden="true"></i></span>
								</div>
								<input type="password" class="form-control" placeholder="* 기존 비밀번호" name="oldpwd" id="oldpwd" required>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group mt-4">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-lock" aria-hidden="true"></i></span>
								</div>
								<input type="password" class="form-control" placeholder="* 신규 비밀번호" name="pwd" id="pwd" required>
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
			        </div>
			        <!-- Modal footer -->
			        <div class="modal-footer">
			           	<button type="button" class="btn btn-danger" onclick="fSubmit()">사용하기</button>
			        </div>
			    </div>
			</div>
		</div>
	</section>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>