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
	.info {font-size: 1.1em;}
</style>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<jsp:include page="/WEB-INF/views/support/include/supportHeader.jsp"/>
			<div class="row">
				<jsp:include page="/WEB-INF/views/support/include/supportSideBar.jsp"/>
				<div id="detail" class="col-9">
					<h4>회원 정보 안내</h4>
					<div>
						TSC 회원에게만 드리는 다양한 혜택을 누려보세요. <br/>
						회원 가입 및 이용에 어려움이 있으시면 고객센터 1588-1234로 유선 연락 바랍니다. 
					</div>
					<br/>
					<hr style="background-color: #eee;"/><br/>
					<ul class="nav nav-tabs mb-4" style="justify-content:flex-start;font-size:1.5em;width:712px;">
					    <li class="nav-item">
					    	<a class="nav-link active" data-toggle="tab" href="#login" id="logintab">로그인</a>
					    </li>
					    <li class="nav-item">
					    	<a class="nav-link" data-toggle="tab" href="#updateinfo" id="updateinfotab">회원정보수정/등급변경</a>
					    </li>
					    <li class="nav-item">
					    	<a class="nav-link" data-toggle="tab" href="#goodBye" id="goodByetab">회원 탈퇴</a>
					    </li>
					</ul>
					<div class="tab-content">
					    <div class="tab-pane container active" id="login">
							<div class="info">
								<span style="font-size:1.1em;"><b>[회원가입]</b></span><br/>
								TSC에 처음 방문하셨나요?<br/>
								화면 우측 상단의 회원가입에서 간편하게 가입하시면 다양한 공연 티켓을 예매하실 수 있습니다.<br/>
							</div><br/>
							<hr style="background-color: #eee;"/><br/>
							
							<div class="info">
								<span style="font-size:1.1em;"><b>[로그인]</b></span><br/>
								TSC 아이디를 보유하고 계시나요?<br/>
								화면 우측 상단의 <a href="${ctp}/member/login" style="text-decoration:underline;color:#c46;"><b>[로그인]</b></a> 에서 이메일, 비밀번호를 입력하여 로그인하시면<br/>
								티켓 예매, 자유게시판, 1:1상담 등의 서비스를 이용할 수 있습니다.<br/>
							</div><br/>
							<hr style="background-color: #eee;"/><br/>
							<div class="info">
								<span style="font-size:1.1em;"><b>[비밀번호 찾기]</b></span><br/>
								<a href="${ctp}/member/findPwd" style="text-decoration:underline;color:#c46;">비밀번호 찾기</a><br/>
								회원가입시 등록한 이메일, 이름을 입력하시고 발송된 메일에 포함된 인증번호를 <br/>
								입력하여 인증하시면 비밀번호를 변경할 수 있습니다. 
							</div><br/>
					    </div>
					    
					    <div class="tab-pane container fade" id="updateinfo">
							<div class="info">
								<span style="font-size:1.1em;"><b>[회원정보 수정]</b></span><br/>
								<a href="${ctp}/member/mypage" style="text-decoration:underline;color:#c46;">회원정보 수정</a><br/>
								마이페이지에서 변경하기 버튼을 누르면 닉네임, 비밀번호, 연락처, 주소를 각각 변경할 수 있습니다. <br/>
								닉네임은 한글과 숫자 조합으로 2~10자리, <br/>
								비밀번호는 영문자, 숫자, 특수문자(!@#$%^&+=) 조합으로 8~15자리를 입력해주세요.
							</div><br/>
						    <hr style="background-color: #eee;"/><br/>
							<div class="info">
								<span style="font-size:1.1em;"><b>[등급변경]</b></span><br/>
								<a href="${ctp}/support/memberLevel/levelUpForm" style="text-decoration:underline;color:#c46;">등급변경</a><br/>
								관계자는 TSC 홈페이지를 통한 공연 등록 신청, 내 담당 작품 통계 조회 등의 기능을 사용할 수 있습니다. <br/>
								위 링크에서 주어진 양식을 작성 후 제출하시면 심사 후 관계자로 등급 변경됩니다. <br/>
								 
							</div><br/>
					    </div>
					    
					    <div class="tab-pane container fade" id="goodBye">
							<div class="info">
								<span style="font-size:1.1em;"><b>[회원탈퇴]</b></span><br/>
								<a href="${ctp}/member/mypage" style="text-decoration:underline;color:#c46;">회원탈퇴</a><br/>
								그동안 TSC 서비스를 이용해 주셔서 감사합니다.
								회원 탈퇴하시면 예매권, 할인쿠폰 등 혜택이 소멸되며, 재가입 시에도 정보가 복구되지 않습니다.
							</div><br/>
					    </div>
					</div>
										
					<br/>
					
					
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>