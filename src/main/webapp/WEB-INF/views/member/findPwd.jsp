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
	$(function () { 
		$('#lost_mask').css({'width':'0','height':'0'});
	});

	var certCode = "";
	// 이름, 이메일 확인 후 메일 전송, 인증번호 돌려받음
	function sendMail() {
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		
		var name = findPwdForm.name.value;
		var email = findPwdForm.email.value;
		var query = {
			name : name, 
			email : email
		};
		
		$.ajax({
			type: "post", 
			url: "${ctp}/member/checkAndSendMail", 
			data: query, 
			success: function(data) {
				if(data.length==6) {
					certCode = data;
					alert("인증번호가 메일로 발송되었습니다. 인증번호를 입력해주세요.");
					var html = "<input type='text' class='form-control form-control-lg p-3 mt-4' placeholder='인증번호를 입력하세요' name='certCode' id='certCode' required />"
							+"<input type='button' onclick='checkcertCode()' value='확인' class='btn btn-outline-danger btn-block btn-lg mt-3' />";
					$("#demo").html(html);
					$('#lost_mask').css({'width':'0','height':'0'});
				} else {
					alert("일치하는 회원 정보가 없습니다. ");
					$('#lost_mask').css({'width':'0','height':'0'});
				}
			}
		});
		
	}
	
	// 사용자 입력 인증번호와 발송 인증번호 같은지 확인
	function checkcertCode(){
		var email = findPwdForm.email.value;
		var inputCode = document.getElementById("certCode").value;
		if(inputCode == certCode) {
			alert("인증번호가 일치합니다.");
			location.href = "${ctp}/member/changePwd?email="+email;	// 비번 변경 창으로 이동
		} else {
			alert("인증번호가 일치하지 않습니다. .");		
			$("#demo").html("");
		}
	} 
</script>
</head>
<body>
	<div id="lost_mask" style="position:fixed;z-index:9000;display:none;left:0;top:0; z-index:9000;background-color:#5558;text-align:center;color:white;">
		<div style="display: flex; align-items: center;margin: auto; height:100%;">
			<div class="spinner-border" style="margin: auto;"></div>
		</div>
	</div> 
	<header><%@ include file="/WEB-INF/views/include/header.jsp"%></header>
	<nav><%@ include file="/WEB-INF/views/include/nav.jsp"%></nav>
	<section>
		<div class="container">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">비밀번호 찾기</h4>
					</div>
					<div class="modal-body">
						<div class="" id="loginBox">
					        <form name="findPwdForm" method="post">
					        	<p>이름/이메일을 입력해주세요</p>
					            <input type="text" class="form-control form-control-lg p-3 mt-4" placeholder="이름" name="name" id="name" required />
					            <input type="email" class="form-control form-control-lg p-3 mt-4" placeholder="이메일" name="email" id="email" required />
					            
					            <input type="button" onclick="sendMail()" value="비밀번호 찾기" class="btn btn-danger btn-block btn-lg mt-3" id="loadingEmail" />
					            <hr/>
					        </form>
					        <p id="demo"></p>
					        
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>