<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<link href="${ctp}/css/header.css" rel="stylesheet" type="text/css" />
<div class="header_content">
	<div>
		<a href="${ctp}/">TSC</a>
		<span>
			scene, in the present. <br />
			scene is presents.
		</span>
	</div>
	<ul class="member">
		<c:if test="${empty sLevel || sLevel==99}">
		<li><a href="${ctp}/member/login"><img src="${ctp}/icons/loginPassword.png" /><span>로그인</span></a></li>
		<li><a href="${ctp}/member/join"><img src="${ctp}/icons/loginJoin.png" /><span>회원가입</span></a></li>
		</c:if>
		<c:if test="${!empty sLevel && sLevel!=99}">
		<li><a href="${ctp}/member/logout"><img src="${ctp}/icons/loginPassword.png" /><span>로그아웃</span></a></li>
		</c:if>
		
		<li><a href="${ctp}/member/mypage"><img src="${ctp}/icons/loginMember.png" /><span>MyPage</span></a></li>
		<li><a href="${ctp}/support/home"><img src="${ctp}/icons/loginCustomer.png" /><span>고객센터</span></a></li>
		<c:if test="${sLevel==2}">
			 <a href="${ctp}/admin/adminMain" class="btn btn-outline-secondary btn-sm ml-4">관리자메뉴</a>
		</c:if>
	</ul>
</div>