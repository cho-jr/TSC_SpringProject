<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="<%=request.getContextPath()%>" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adLeft.jsp</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp"%>
<script>
	function logoutCheck() {
		parent.location.href = "${ctp}/member/logout";
	}
</script>
<style>
body {
	background-color: #fefefe;
}
a{text-decoration: none;color:inherit;}
a:hover{text-decoration: none;color:inherit;}
ul, li {
	padding:0px;
	list-style: none;
	text-align: center;
}
ul>li>div {
	background-color: #ddd;
	padding:10px;
	text-align: center;
}
ul ul li {padding:5px;}
ul ul li:hover {background-color: rgb(240, 200, 200);}
</style>
</head>
<body>
	<p><br></p>
	<div>
		<h4 align="center"><a href="${ctp}/admin/adContent" target="adContent">관리자메뉴</a></h4>
		<hr />

		<p><a href="${ctp}/" target="_top" style="margin-left: 15px;padding:5px 10px 4px;border:1px solid #d88;border-radius: 10px;">홈으로&nbsp;&nbsp;<i class="fas fa-sign-out-alt" style="margin-top:3px;font-size:1.3em;color:#555;"></i></a></p>
		<p><a href="javascript:logoutCheck()" style="margin-left: 15px;padding:5px 10px 4px;border:1px solid #d88;border-radius: 10px;">로그아웃&nbsp;&nbsp;<i class="fas fa-user-slash" style="margin-top:3px;font-size:1.2em;color:#555;"></i></a></p>
		<ul>
			<li>
				<div><i class="fas fa-home" style="color:#00c;"></i></div>
				<ul>
					<li><a href="${ctp}/admin/setMain/setMainAd" target="adContent">메인광고설정</a></li>
					<li><a href="${ctp}/admin/setMain/setThemePerform" target="adContent">테마별작품설정</a></li>
				</ul>
			</li>
			<li>
				<div><i class="fas fa-gift" style="color:#c00;"></i></div>
				<ul>
					<li><a href="${ctp}/admin/setPerform/adminPerformList" target="adContent">작품목록</a></li>
					<li><a href="${ctp}/admin/setPerform/newPerform" target="adContent">작품등록</a></li>
				</ul>
			</li>
			<li>
				<div><i class="fas fa-landmark" style="color:#930;"></i></div>
				<ul>
					<li><a href="${ctp}/admin/setTheater/theaterList" target="adContent">극장목록</a></li>
					<li><a href="${ctp}/admin/setTheater/newTheater" target="adContent">극장등록</a></li>
				</ul>
			</li>
			<li>
				<div><i class="fas fa-ticket-alt" style="color:#0c0;"></i></div>
				<ul>
					<li><a href="${ctp}/admin/tickets/ticketsList" target="adContent">예매내역(건별)</a></li>
				</ul>
			</li>
			<li>
				<div><i class="far fa-user" style="color:#707;"></i></div>
				<ul>
					<li><a href="${ctp}/admin/member/memberList" target="adContent">회원목록</a></li>
					<li><a href="${ctp}/admin/member/official" target="adContent">관계자신청</a></li>
					<li><a href="${ctp}/admin/member/officialList" target="adContent">관계자목록</a></li>
				</ul>
			</li>
			<li>
				<div><i class="far fa-comment" style="color:#774;"></i></div>
				<ul>
					<li><a href="${ctp}/admin/plaza/freeBoard" target="adContent">자유게시판</a></li>
					<li><a href="${ctp}/admin/plaza/replies" target="adContent">댓글조회</a></li>
				</ul>
			</li>
			<li>
				<div><i class="fas fa-star" style="color:#fe0;"></i></div>
				<ul>
					<li><a href="${ctp}/admin/review/reviewList" target="adContent">리뷰목록</a></li>
					<li><a href="${ctp}/admin/review/reportedReview" target="adContent">신고리뷰관리</a></li>
				</ul>
			</li>
			<li>
				<div><i class="fas fa-headset"></i></div>
				<ul>
					<li><a href="${ctp}/admin/support/qna/qnaList" target="adContent">1:1문의</a></li>
					<li><a href="${ctp}/admin/support/notice/noticeList" target="adContent">공지사항</a></li>
					<li><a href="${ctp}/admin/support/FAQ/FAQList" target="adContent">FAQ</a></li>
					<li><a href="${ctp}/admin/support/suggestion/suggestionList" target="adContent">건의사항</a></li>
				</ul>
			</li>
		</ul>

	</div>
	<br />
</body>
</html>