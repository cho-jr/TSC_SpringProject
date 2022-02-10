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
<body>
	<section style="padding:20px;margin:20px;">
		<h3>&lt;작품 상세정보&gt;</h3>
		<table class="table table-bordered">
			<tr>
				<th style="width:200px;">제목</th>
				<td>${vo.title}</td>
			</tr>
			<tr>
				<th style="width:200px;">상세페이지 조회수</th>
				<td>누적:${performInfoViews}</td>
			</tr>
			<tr>
				<th style="width:200px;">총티켓판매금액</th>
				<td><fmt:formatNumber value="${sumPrice}"/> 원</td>
			</tr>
			<tr>
				<th style="width:200px;">예매율</th>
				<td> 
					<c:if test="${not empty AllSeatNums}">
						<c:if test="${not empty seatNums}">
							좌석별 : <br/>
							<c:set var="seatArr" value="${fn:split(vo.seat, ',')}"/>
							<c:forEach var="seat" items="${seatArr}" varStatus="st">
								${seatArr[st.index]} : ${fn:substring((seatNums[st.index]-remainSeatNums[st.index])/seatNums[st.index]*100, 0, 4)} %
								<meter value="${(seatNums[st.index]-remainSeatNums[st.index])/seatNums[st.index]*100}" min="0" max="100" low="10" high="40"></meter>
								<br/>
							</c:forEach>
							<hr/>
						</c:if>
						전체 : 
						${fn:substring((AllSeatNums-AllRemainSeatNums)/AllSeatNums*100, 0, 4)} % 
						<meter value="${(AllSeatNums-AllRemainSeatNums)/AllSeatNums*100}" min="0" max="100" low="10" high="40"></meter><br/>
					</c:if>
					<c:if test="${empty AllSeatNums}">등록된 일정이 없습니다. </c:if>
				</td>
			</tr>
			<tr>
				<th style="width:200px;">리뷰수 / 별점</th>
				<td>${reviewCnt} 건<br/>  ${starAvg}/5 점</td>
			</tr>
			<tr>
				<th style="width:200px;"></th>
				<td><button type="button" onclick="window.close()" class="btn btn-danger btn-sm">닫기</button></td>
			</tr>
		</table>
	</section>
</body>
</html>