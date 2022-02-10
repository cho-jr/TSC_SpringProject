<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script type="text/javascript">
var checked = 0;
function changePwd() {
	if(checked!=1) {
		alert("입력값을 다시 확인해주세요");
		return false;
	} else {
		changePwdForm.submit();
	}
}

function checkRegex() {
	// 입력하세요
	// 정규식 확인
	var pwd = document.getElementById("pwd").value;
	var regexpwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/; //특수문자 / 문자 / 숫자 포함 형태의 8~15자리 이내의 암호 정규식
	if (!regexpwd.test(pwd)) {
		document.getElementById("pwdCheckMessage").innerHTML = "<div class='text-danger'>8-15자리 영문, 숫자, 특수문자(!@#$%^&+=)만 사용 가능합니다. 😅</div>";
		return false;
	} else {
		document.getElementById("pwdCheckMessage").innerHTML = "<div class='text-success'>안전하게 지킬게요! 😎</div>";
	}
	
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
		checked = 1;
	}
}
document.onkeyup=checkRegex;
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
						<h4 class="modal-title">비밀번호 변경</h4>
					</div>
					<div class="modal-body">
						<div class="" id="loginBox">
					        <form name="changePwdForm" method="post">
								<div class="form-group">
									<input type="password" class="form-control" placeholder="* 비밀번호" name="pwd" id="pwd" required>
									<p id="pwdCheckMessage" class="mt-2"></p>
								</div>
								<!-- 비번 체크 -->
								<div class="form-group">
									<input type="password" class="form-control" placeholder="* 비밀번호 확인" id="pwdChk" required />
									<p id="pwCheckMessage" class="mt-2"></p>
								</div>
					            <%-- <input type="hidden" name="email" id="email" value="${email}"/> --%>
					            
					            <input type="button" onclick="changePwd()" value="비밀번호 변경" class="btn btn-danger btn-block btn-lg mt-3" />
					            <hr/>
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