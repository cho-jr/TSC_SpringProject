<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	.navbar {padding:0;}
	#sidebar {background-color: #fff; width:100%;}
	#sidebar ul li {width: 100%;padding:2px 20px;font-size: 1.3em;}
	#sidebar ul li:hover {background:#fb4357; color:white;}
	.prepare{opacity:0.7;}
</style>
<script>
	function prepare(){
		alert("서비스 준비중입니다. ");
	}
</script>
	<div class="col-3">
		<div class="navbar bg-white" id="sidebar">
		    <ul class="navbar-nav" style="border-left: 4px solid #ccc;">
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/member/mypage/myTickets/myTickets">예매관리</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/member/mypage/myReview/myReview">리뷰관리</a>
			    </li>
				<c:if test="${sLevel>=1}">
				    <li class="nav-item">
				        <a class="nav-link" href="${ctp}/member/mypage/myPerform/performList">내 작품 관리</a>
				    </li>
			    </c:if>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/member/mypage/qna/qnaList">1:1문의</a>
			    </li>
			    <li class="nav-item">
			        <a class="nav-link" href="${ctp}/member/mypage">회원정보수정</a>
			    </li>
			    <li class="nav-item prepare">
			        <a class="nav-link" href="javascript:prepare()">보유 쿠폰 조회</a>
			    </li>
			    <li class="nav-item prepare">
			        <a class="nav-link" href="javascript:prepare()">쿠폰 등록</a>
			    </li>
			    <li class="nav-item prepare">
			        <a class="nav-link" href="javascript:prepare()">증빙서류</a>
			    </li>
			    <li class="nav-item prepare">
			        <a class="nav-link" href="javascript:prepare()">입금증</a>
			    </li>
			    <li class="nav-item prepare">
			        <a class="nav-link" href="javascript:prepare()">현금영수증</a>
			    </li>
			    <li class="nav-item prepare">
			        <a class="nav-link" href="javascript:prepare()">신용카드 매출전표</a>
			    </li>
			    <li class="nav-item prepare">
			        <a class="nav-link" href="javascript:prepare()">환불 계좌 관리</a>
			    </li>
		    </ul>
		</div>
	</div>