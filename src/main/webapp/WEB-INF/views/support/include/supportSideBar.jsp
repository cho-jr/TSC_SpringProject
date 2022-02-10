<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	.navbar {padding:0;}
	#sidebar {background-color: #fff; width:100%;}
	#sidebar ul li {width: 100%;padding:2px 20px;font-size: 1.3em;}
	#sidebar ul li:hover {background:#fb4357; color:white;}
</style>
	<div class="col-3">
		<div class="navbar bg-white" id="sidebar">
		    <ul class="navbar-nav" style="border-left: 4px solid #ccc;">
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/support/home">고객센터홈</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/support/FAQ/FAQList">FAQ</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/support/notice/noticeList">공지사항</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/support/qna">1:1문의</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/support/suggestion">건의사항</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/support/ticketCancleInfo">예매취소/환불안내</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/support/memberLevel/info">회원정보안내</a>
			    </li>
		    </ul>
		</div>
	</div>