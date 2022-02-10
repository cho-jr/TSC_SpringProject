<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style type="text/css">
	th {text-align: center;}
</style>
<script type="text/javascript">
	$(function() {
		$(".detail").toggle(0);
	});
	
	function show(idx) {
		$(".det"+idx).toggle(0);
		$(".sum"+idx).toggle(0);
	}
	
	// 내가 쓴 리뷰 수정 삭제
	function updateReview(idx){
		url = "${ctp}/member/mypage/myReview/updateReview?idx="+idx;
		window.open(url, "nWin", "width=500px, height=270px, location=no")
	}
	function deleteReview(idx) {
		var ans = confirm("리뷰를 삭제하시겠습니까?");
		if(!ans) return false;
		
		$.ajax({
			type: "post", 
			url: "${ctp}/perform/reviewDelete", 
			data : {idx:idx+0}, 
			success: function() {
				alert("삭제되었습니다. ");
				location.reload();
			}, 
			error:function() {
				alert("전송오류");
			}
		});
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
				<div id="detail" class="col-9">
					<h4>&lt;내가 쓴 리뷰&gt;</h4>
					<br/><br/>
					<table class="table table-hover" style="clear:both;margin-top:20px;">
						<tr>
							<th style="width:15%;">제목</th>
							<th style="width:50px;">별점</th>
							<th style="width:45%">리뷰</th>
							<th style="width:15%">작성일</th>
							<th style="width:15%">수정/삭제</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td style="text-align: center;">
									<a href="${ctp}/perform/performInfo?idx=${vo.performIdx}">${vo.performTitle}</a>
								</td>
								<td style="padding:12px;" class="" id="star${vo.idx}">
									<c:choose>
										<c:when test="${vo.star==1}"><span style="color:#f90">★</span>★★★★</c:when>
										<c:when test="${vo.star==2}"><span style="color:#f90">★★</span>★★★</c:when>
										<c:when test="${vo.star==3}"><span style="color:#f90">★★★</span>★★</c:when>
										<c:when test="${vo.star==4}"><span style="color:#f90">★★★★</span>★</c:when>
										<c:when test="${vo.star==5}"><span style="color:#f90">★★★★★</span></c:when>
										<c:otherwise>별점 없음</c:otherwise>
									</c:choose>
								</td>
								
								<td id="reviewContent${vo.idx}" class="summary sum${vo.idx}" onclick="show(${vo.idx})">
									<c:if test="${fn:contains(vo.reviewContent, '@@WARN')}">
										<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
									</c:if>
									<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
										${fn:substring(vo.reviewContent, 0, 50)}
										<c:if test="${fn:length(vo.reviewContent)>50}">...</c:if>
									</c:if>
								</td>
								<td id="reviewContent${vo.idx}" class="detail det${vo.idx}" onclick="show(${vo.idx})">
									<c:if test="${fn:contains(vo.reviewContent, '@@WARN')}">
										<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
									</c:if>
									<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
										${fn:replace(vo.reviewContent, newLine, '<br/>')}										
									</c:if>
								</td>
								<td style="text-align: center;"><c:out value="${fn:substring(vo.WDate, 0, 10)}"/></td>
								<td style="text-align: center;">
									<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
										<a href="javascript:updateReview(${vo.idx})">수정</a>&nbsp;/
									</c:if>
									<a href="javascript:deleteReview(${vo.idx})">삭제</a>
								</td>								
							</tr>
						</c:forEach>
					</table>
					<c:set var="linkpath" value="member/mypage/myReview/myReview"/>
					<%@ include file="/WEB-INF/views/include/paging.jsp" %>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>