<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TSC</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp"%>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<style>
	.card-img-overlay {visibility: hidden;}
	.card:hover .card-img-overlay {visibility: visible;background-color: rgba(0, 0, 0, 0.4);z-index: 99;}
	.plusBtn {
		color:#999; float:right;margin-right: 10px; 
		font-size: 0.5em;border:1.5px solid #bbb; 
		border-radius: 10px;padding:3px 13px;
	}
	.plusBtn:hover {
		box-shadow: 0px 0px 5px #fb354788;
	}
</style>
<script type="text/javascript">
	// 쿠기 값 설정
	function setCookie(cookie_name, value, days) {
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + days);
		// 설정 일수만큼 현재시간에 만료값으로 지정
		
		var cookie_value = escape(value) + ((days == null) ? '' : '; expires=' + exdate.toUTCString());
		document.cookie = cookie_name + '=' + cookie_value;
	}
	
	// 쿠키 값 가져오기
	function getCookie(cookie_name) {
		var x, y;
		var val = document.cookie.split(';');
		
		for (var i = 0; i < val.length; i++) {
			x = val[i].substr(0, val[i].indexOf('='));
			y = val[i].substr(val[i].indexOf('=') + 1);
			x = x.replace(/^\s+|\s+$/g, ''); // 앞과 뒤의 공백 제거하기
			if (x == cookie_name) {
				return unescape(y); // unescape로 디코딩 후 값 리턴
			}
		}
	}
	
	$(document).ready(function() {
		if(getCookie('noshow')!='true'){
			$("#myModal").modal();
		}
	});
	
	
	function noShowToday() {
		setCookie('noshow', true , 1);
		$("#closeBtn").trigger("click");
	}
</script>
</head>
<body>
	<header><%@ include file="/WEB-INF/views/include/header.jsp"%></header>
	<nav><%@ include file="/WEB-INF/views/include/nav.jsp"%></nav>
	
	<%@ include file="/WEB-INF/views/include/main/main_ad.jsp"%>
	
	<div style="width: 1000px; margin:0 auto;">
		<br/><br/>

		<!-- 추천작 등등-->
		<%@ include file="/WEB-INF/views/include/main/main_recommand.jsp"%>
		<br/><br/>
		<img src="${ctp}/images/advertise/${slimVO1.FSName}">
		<c:if test="${not empty comingsoonVos}">
			<br/><br/>
			<%@ include file="/WEB-INF/views/include/main/main_comingsoon.jsp"%>
		</c:if>
		<br/><br/><br/>
		
		<!-- 테마별 작품 -->
		<c:forEach var="vos" items="${themesVos}" varStatus="st">
			<c:if test="${st.index%3==2}"><img src="${ctp}/images/advertise/${slimVO2.FSName}"></c:if>
			<c:if test="${not empty vos}">
				<c:set var="themeName" value="${themes[st.index]}"/>
				<%@ include file="/WEB-INF/views/include/main/main_theme.jsp"%>
				<br/><br/>
			</c:if>
			<c:if test="${st.index%3==0}"><%@ include file="/WEB-INF/views/include/main/carouselAdv.jsp" %></c:if>
			<br/><br/>
		</c:forEach>
		
		<!-- 하단 공지/고객센터 안내 -->
		<c:set var="vo" value="${noticeVo}"/>
		<%@ include file="/WEB-INF/views/include/main/main_noticeFAQ.jsp"%>
		<br/><br/><br/><br/>
	</div>

	<img src="${ctp}/images/advertise/${slimVO2.FSName}" style="width:100%">
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<a href="#" class="stretched-link top bg-danger text-white pl-2 pr-2 pt-2" style=""><i class="fas fa-sort-up"></i></a>
	
	<div class="modal fade" id="myModal">
	    <div class="modal-dialog">
			<div class="modal-content">
			  <div class="modal-header">
			    <h4 class="modal-title">비밀번호 1234</h4>
			    <button type="button" class="close" data-dismiss="modal">&times;</button>
			  </div>
			  <div class="modal-body">
			    편의를 위해 신청자에 한하여 비밀번호를 1234로 변경해드립니다. <br/>
			    희망하시는 분은 1:1문의 부탁드립니다. (<a href="${ctp}/member/login" class="text-primary">로그인</a> 후 이용 가능)<br/>
			    <br/><br/> 
			    <a href="${ctp}/support/qna" class="text-primary">1:1문의 바로가기</a>
			  </div>
			  <div class="modal-footer">
			    <button type="button" class="btn btn-danger" data-dismiss="modal"id="closeBtn" >Close</button>
			    <button type="button" class="btn btn-light" onclick="noShowToday()">오늘 하루 열지 않기</button>
			  </div>
			</div>
	    </div>
    </div>
</body>
</html>


