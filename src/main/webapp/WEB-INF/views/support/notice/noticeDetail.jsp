<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script type="text/javascript">
	$(function() {
		$("img").attr("style", "width:100%");
	});
</script>
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
					<h3>공지사항</h3>
					<table class="table">
						<tr class="table-danger">
							<td></td>
							<th style="width:400px;">${vo.title}</th>
							<td>${fn:substring(vo.WDate, 0, 10)}</td>
							<td>조회수&nbsp;&nbsp;${vo.views}</td>
						</tr>
						<tr>
							<td colspan="4" style="min-height: 200px;">${vo.content}</td>
						</tr>
						<tr>
							<td colspan="4" style="min-height: 100px;text-align: right;">
								<button class="btn btn-danger btn-sm" onclick="location.href='${ctp}/support/notice/noticeList'">목록으로</button>
							</td>
						</tr>
						<tr>
							<td style="width:80px;">이전글 ▲</td>
							<td colspan="2" style="width:400px;">
								<c:if test="${!empty prevVo}">
									<a href="${ctp}/support/notice/noticeDetail?idx=${prevVo.idx}">${prevVo.title}</a>
								</c:if>
								<c:if test="${empty prevVo}">
									<span style="color:#777;">이전 글이 없습니다.</span> 
								</c:if>
							</td>
							<td>${fn:substring(prevVo.WDate, 0, 10)}</td>
						</tr>
						<tr>
							<td>다음글 ▼</td>
							<td colspan="2">
								<c:if test="${!empty nextVo}">
									<a href="${ctp}/support/notice/noticeDetail?idx=${nextVo.idx}">${nextVo.title}</a>
								</c:if>
								<c:if test="${empty nextVo}">
									<span style="color:#777;">다음 글이 없습니다.</span>  
								</c:if>
							</td>
							<td>${fn:substring(nextVo.WDate, 0, 10)}</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>