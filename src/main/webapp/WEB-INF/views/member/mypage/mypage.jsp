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
<style type="text/css">
	table tr td {font-size: 1.1em;}
</style>
<script>
	function newWin(file) {
		var url = "${ctp}/member/mypage/memberInfo/"+file ;
		window.open(url, "nWin", "width=500px,height=400px");
	}
	
	var phoneUpdating = false;
	function changePhone(){
		var phone = '${memberVo.phone}';
		phoneUpdating = true;
		var addHtml = '<div class="form-group"><div class="input-group mt-4">'+
						'<div class="input-group-prepend"><span class="input-group-text"><i class="fa fa-phone" aria-hidden="true"></i></span></div>'+
						'<input type="tel" class="form-control" placeholder="연락처(숫자만 입력하세요)" id="phone" value="'+phone+'" name="phone" required />'+
					'</div><div><p id="phoneCheckMessage" class="mt-2"></p></div></div>'+
						'<button onclick="phoneSave()" class="btn btn-secondary btn-sm">저장</button>';
		$("#userphone").html(addHtml);
		$("#phoneBtn").html("");
	}
	document.onkeyup = fCheck;
	
	function fCheck() {
		if(!phoneUpdating) return false;
		var regexPhone = /^[0-9]{9,12}$/g; //  숫자
		let phone = document.getElementById("phone").value;
		if (!regexPhone.test(phone)) {
			document.getElementById("phoneCheckMessage").innerHTML = "<div class='text-danger'>전화번호 숫자만 입력해주세요. 😅</div>";
			return false;
		} else {
			document.getElementById("phoneCheckMessage").innerHTML = "<div class='text-success'>감사합니다! 😎</div>";
			return true;
		}
	}
	
	function phoneSave() {
		if(fCheck) {
			let phone = document.getElementById("phone").value;
			$.ajax({
				type : "post",
				url : "${ctp}/member/mypage/memberInfo/changePhone", 
				data : {phone:phone}, 
				success : function() {
					alert("변경사항을 저장했습니다. ");
					$("#userphone").html(phone);
					$("#phoneBtn").html('<button class="btn btn-outline-danger btn-sm" onclick="changePhone()">변경하기</button>');
					phoneUpdating = false;
				}
			});
		}
	}
	
	function saveAddress() {
		var addrCode = addressForm.addrCode.value; 
		var addr1 = addressForm.addr1.value; 
		var addr2 = addressForm.addr2.value; 
		var addr3 = addressForm.addr3.value;
		
		if(addrCode==""||addr1==""||addr2==""){
			alert("주소를 입력하세요. ");
			return false;
		}
		
		var ans = confirm("주소를 변경하시겠습니까?");
		if(!ans) return false;
		
		var query = {
				addrCode : addrCode,
				addr1 : addr1, 
				addr2 : addr2, 
				addr3 : addr3
		}
		$.ajax({
			type: "post", 
			url: "${ctp}/member/mypage/memberInfo/changeAddress", 
			data : query, 
			success : function(data) {
				location.href = "${ctp}/member/mypage";
				alert("주소가 변경되었습니다. ");
			}
		});
	}
	function GoodBye() {
		var ans = confirm("회원 탈퇴하시면 예매권, 할인쿠폰 등 혜택이 소멸되며, \n재가입 시에도 정보가 복구되지 않습니다. \n정말 탈퇴하시겠습니까?");
		if(!ans) return false;
		
		location.href='${ctp}/member/mypage/GOODBYE';
	}
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<h2>마이페이지</h2>
			<jsp:include page="/WEB-INF/views/include/mypageHeader.jsp"/>
			<div class="row" style="width:990px;margin:0;">
				<jsp:include page="/WEB-INF/views/include/mypageSideBar.jsp"/>
				<div class="col-9 bg-light">
					<table class="table">
						<tr><th colspan="2" class="text-center">회원 정보</th></tr>
						<tr><td>이메일</td><td>${memberVo.email}</td></tr>
						<tr><td>이름</td><td>${memberVo.name}</td></tr>
						<tr><td>닉네임</td><td>${memberVo.nick}&nbsp;<button class="btn btn-outline-danger btn-sm" onclick="newWin('changeNick')">변경하기</button></td></tr>
						<tr><td>비밀번호</td><td><button class="btn btn-outline-danger btn-sm" onclick="newWin('changePwd')">변경하기</button></td></tr> <!-- 클릭시 팝업! -->
						<tr><td>연락처</td><td><span id="userphone">${memberVo.phone}</span>&nbsp;<span id="phoneBtn"><button class="btn btn-outline-danger btn-sm" onclick="changePhone()">변경하기</button></span></td></tr>
						<tr>
							<td>주소</td>
							<td>
								${memberVo.addr1} ${memberVo.addr2} ${memberVo.addr3}&nbsp;
								<button class="btn btn-outline-danger btn-sm" onclick="saveAddress()">변경하기</button><br/><br/>
								<form name="addressForm">
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
											<input type="text" name="addr3" id="sample4_extraAddress" class="form-control" placeholder="참고항목">
										</div>
									</div>
								</form>
							</td>
						</tr>
						<tr><td colspan="2"><button class="btn btn-sm text-secondary" type="button" onclick="GoodBye()">탈퇴하기</button></td></tr>
					</table>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>