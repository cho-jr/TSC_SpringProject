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
	// 닉네임 중복확인
	// 새 창 띄우지 말고 Ajax 처리!
	function newNickChk() {
		var regexNick = /^[가-힣0-9]{2,10}$/g; // 2~10자리 한글, 숫자
		var nick = document.getElementById("nick").value;
		
		if(nick=="") {
			alert("닉네임을 입력하세요.");
			document.getElementById("nick").focus();
			return false;
		} else if (!regexNick.test(nick)) {
			alert("닉네임 형식이 올바르지 않습니다.");
			document.getElementById("nick").focus();
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
				} else {
					alert("사용불가능한 닉네임 입니다. ");
					document.getElementById("nick").value="";
					document.getElementById("nick").focus();
				}
			}
		});
	}
	// 닉네임 입력창 수정시
	checkedNickName = false;
	function changeNickName() {
		checkedNickName = false;
		$("#nickChkBtn").addClass('btn-outline-danger');
		$("#nickChkBtn").removeClass('btn-danger');
	}
	
	// 닉네임 정규화 확인
	function fCheck() {
		var regexNick = /^[가-힣0-9]{2,10}$/g; // 2~10자리 한글, 숫자
		let nick = document.getElementById("nick").value;
		if (!regexNick.test(nick)) {
			document.getElementById("nickCheckMessage").innerHTML = "<div class='text-danger'>2~10자리 한글, 숫자만 입력해주세요. 😅</div>";
			return false;
		} else {
			document.getElementById("nickCheckMessage").innerHTML = "<div class='text-success'>멋진 닉네임이네요, "+nick+"님! 중복 체크 해주세요~ 😎</div>";
		}
	}
	document.onkeyup = fCheck;
	
	// 닉네임 변경 처리
	function fSubmit() {
		if(!checkedNickName) {
			alert("중복 확인 버튼을 클릭해주세요. ");
			return false;
		}
		var nick = document.getElementById("nick").value;
		// ajax DB 변경 후 자식창 닫기 부모창 새로고침
		$.ajax({ 
			type: "post", 
			url: "${ctp}/member/mypage/memberInfo/changeNick", 
			data: {nick:nick}, 
			success: function() {
				alert("닉네임이 변경되었습니다. ");
				window.close();
				opener.parent.location.reload();
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
			            <h4 class="modal-title">닉네임 변경</h4>
			        </div>
			        <!-- Modal body -->
			        <div class="modal-body">
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