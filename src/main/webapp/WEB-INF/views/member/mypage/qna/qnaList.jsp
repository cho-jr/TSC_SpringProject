<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="member/mypage/qna/qnaList"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1문의 내역</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style type="text/css">
	th { text-align: center;}
	.detail .table th, td{font-size: 1.2em;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$(".detail").toggle(1);
	});
	function show(idx) {
		$("."+idx).toggle(1);
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
					<h4>&lt;1:1 문의 내역&gt;</h4>
					<a class="btn btn-danger" href="${ctp}/support/qna" style="float:right;">문의하러가기</a>
					<br/><br/>
					<table class="table table-hover" style="clear:both;margin-top:20px;">
						<tr>
							<th style="width:15%">처리현황</th>
							<th>질문</th>
							<th style="width:20%">작성일</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td style="text-align: center;">
									<c:if test="${empty vo.answer}">문의 접수</c:if>
									<c:if test="${!empty vo.answer}">답변 완료</c:if>
								</td>
								<td class="pl-4"><b><a href="javascript:show(${vo.idx});"><c:out value="${vo.title}"/></a></b></td>
								<td style="text-align: center;"><c:out value="${fn:substring(vo.WDate, 0, 10)}"/></td>
							</tr>
							<tr class="detail ${vo.idx}" >
								<td style="text-align: right;">질문</td>
								<td>${vo.content}</td>
								<td></td>
							</tr>
							<tr class="detail ${vo.idx}">
								<td style="text-align: right;">답변</td>
							<c:if test="${empty vo.answer}">
								<td>
									아직 답변이 없습니다. 양해해주셔서 감사합니다. 
								</td>
								<td></td>
							</c:if>
							<c:if test="${!empty vo.answer}">
								<td>
									${fn:replace(vo.answer, newLine, '<br/>')}
								</td>
								<td>${fn:substring(vo.ADate, 0, 10)}</td>
							</c:if>
							</tr>
						</c:forEach>
					</table>
					<c:set var="linkpath" value="member/mypage/qna/qnaList"/>
					<%@ include file="/WEB-INF/views/include/paging.jsp" %>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>