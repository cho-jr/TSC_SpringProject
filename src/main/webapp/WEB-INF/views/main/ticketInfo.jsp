<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style type="text/css">
	*{font-size: 1.2em;}
</style>
</head>
<body style="overflow-x: hidden;">
	<section>
		<div style="width:100%;margin:0 auto;">
			<table class="table table-hover table-bordered">
				<tr><th colspan="3" class="text-center"><h4><b>예매 상세</b></h4></th></tr>
				<tr><th>상태</th>
				<c:if test="${ticketVo.cancle}">
					<td colspan="2" style="font-size: 1.3em; font-weight: 700; color: #700;">취소</td>
				</c:if>
				<c:if test="${!ticketVo.cancle}">
					<td colspan="2" style="font-size: 1.3em; font-weight: 700; color: #007;">유효</td>
				</c:if>
				<tr>
					<th style="width:30%;">구매자</th>
					<td colspan="2">${ticketVo.memberNick}</td>
				</tr>
				<tr>
					<th>공연 제목</th>
					<td colspan="2">
						${performVo.title}
					</td>
				</tr>
				<tr>
					<th>관람일</th>
					<td colspan="2">
						${fn:substring(scheduleVo.schedule, 0, 16)}
					</td>
				</tr>
				<tr>
					<th>구매좌석</th>
					<td colspan="2">
						${performVo.seat}/
						${ticketVo.selectSeatNum}
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<a href="${ctp}/perform/performInfo?idx=${performVo.idx}" target="_blank" title="공연정보 보러가기">
							<img src="${ctp}/${performVo.posterFSN}" width="100%"/>
						</a>				
					</td>
				</tr>
			</table>
		</div>
	</section>
</body>
</html>