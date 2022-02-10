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
</head>
<body style="overflow-x: hidden;">
	<section>
		<div style="width:500px;margin:0 auto;">
			<table class="table table-hover table-bordered">
				<tr><th colspan="3" class="text-center"><h4><b>예매 상세</b></h4></th></tr>
				<tr>
					<th style="width:110px;">구매자</th>
					<td>${ticketVo.memberNick}</td>
					<td rowspan="2">
						<c:if test="${not empty QRCode}">
							<img src="${ctp}/images/QRTicket/${QRCode}" width="150px"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th>공연 제목</th>
					<td>
						<a href="${ctp}/perform/performInfo?idx=${performVo.idx}" target="_blank" title="공연정보 보러가기"><b>${performVo.title}</b></a><br/>
					</td>
				</tr>
				<tr>
					<th>관람등급</th>
					<td colspan="1">${performVo.rating}</td>
					<td rowspan="3">
						<a href="${ctp}/perform/performInfo?idx=${performVo.idx}" target="_blank" title="공연정보 보러가기">
							<img src="${ctp}/${performVo.posterFSN}" width="150px"/>
						</a>
					</td>
				</tr>
				<tr>
					<th>관람시간</th>
					<td colspan="1">${performVo.runningTime}</td>
				</tr>
				<tr>
					<th>극장</th>
					<td colspan="1">
						${performVo.theater}
						<br/><br/>
						상세 주소 : ${theaterVo.address1} ${theaterVo.address2} ${theaterVo.address3}
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
					<th>결제금액</th>
					<td colspan="2">
						<fmt:formatNumber value="${ticketVo.finalPrice}"/> 
					</td>
				</tr>
				<tr>
					<th>결제수단</th>
					<td colspan="2">
						${ticketVo.payBy}
					</td>
				</tr>
				<tr>
					<th>결제일</th>
					<td colspan="2">
						${ticketVo.payDate}
					</td>
				</tr>
				<tr>
					<th>상태</th>
					<td colspan="2">
						<c:if test="${ticketVo.print}">발권 완료</c:if>
						<c:if test="${!ticketVo.print && ticketVo.cancle}">예매 취소</c:if>
						<c:if test="${!ticketVo.print && !ticketVo.cancle}">
							예매 취소 가능일 : 관람일 3일 전까지 가능 
						</c:if>
					</td>
				</tr>
			</table>
		</div>
	</section>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>