<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="plaza/plaza"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style>
	th{text-align: center;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$(".detail").toggle(0);
		
		if('${tab}'=='freeBoard') $("#freeBoardtab").trigger("click");
		else if('${tab}'=='reviews') $("#reviewstab").trigger("click");
		//else if('${tab}'=='photo') $("#phototab").trigger("click");
	});
	
	function show(idx) {
		$(".det"+idx).toggle(0);
		$(".sum"+idx).toggle(0);
	}
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<%@ include file="/WEB-INF/views/include/main/carouselAdv.jsp" %>
			<br/><br/>
			<!-- Nav tabs -->
			<ul class="nav nav-tabs mb-4" style="justify-content:flex-start;font-size: 1.5em;">
			    <li class="nav-item">
			    	<a class="nav-link active" data-toggle="tab" href="#freeBoard" id="freeBoardtab">자유게시판</a>
			    </li>
			    <li class="nav-item">
			    	<a class="nav-link" data-toggle="tab" href="#reviews" id="reviewstab">리뷰 모아보기</a>
			    </li>
			    <!-- <li class="nav-item">
			    	<a class="nav-link" data-toggle="tab" href="#photo" id="phototab">사진첩</a>
			    </li> -->
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			    <div class="tab-pane container active" id="freeBoard">
			    	<%@ include file="/WEB-INF/views/plaza/include/freeBoard.jsp" %>
			    </div>
			    
			    <div class="tab-pane container fade" id="reviews">
				    <%@ include file="/WEB-INF/views/plaza/include/reviews.jsp" %>
			    </div>
			    
			    <!-- <div class="tab-pane container fade" id="photo">
			    	<h3>사진첩</h3>
			    </div> -->
			</div>
			<br/><br/>
		</div>
	</section>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>