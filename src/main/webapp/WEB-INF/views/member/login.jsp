<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp"%>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
</head>
<body>
	<header><%@ include file="/WEB-INF/views/include/header.jsp"%></header>
	<nav><%@ include file="/WEB-INF/views/include/nav.jsp"%></nav>
	<section>
		<div class="container">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">로그인</h4>
					</div>
					<div class="modal-body">
						<div class="" id="loginBox">
					        <form name="loginForm" method="post">
					            <input type="text" class="form-control form-control-lg p-3 mt-4" placeholder="이메일" name="email" value="${email}" id="email" required />
					            <input type="password" class="form-control form-control-lg p-3 mt-3" placeholder="비밀번호" name="pwd" id="pwd" required />
					            <div class="custom-control custom-checkbox mt-2">
								    <input type="checkbox" class="custom-control-input" id="saveId" name="saveId" ${checked} value="true">
								    <label class="custom-control-label" for="saveId">아이디 저장 </label>
								</div>
					            <input type="submit" value="로그인" class="btn btn-danger btn-block btn-lg mt-3" />
						            <input type="button" value="비밀번호를 잊으셨나요?" class="btn btn-link btn-block" 
						            	onclick="location.href='${ctp}/member/findPwd'" />
					            <hr/>
					            <div class="row">
					            <div class="col-lg-4 col-md-4 col-sm-4"></div>
					            <input type="button" value="회원가입" onclick="location.href='${ctp}/member/join'"
					            	class="col-lg-4 col-md-4 col-sm-4 btn btn-outline-danger btn-lg mt-3 mb-4 pl-4 pr-4" />
					            <div class="col-lg-4 col-md-4 col-sm-4"></div>
					            </div>
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