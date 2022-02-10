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
	function performStat(idx) {
		url = "${ctp}/member/mypage/myPerform/performDetail?idx="+idx;
		window.open(url, "performInfoWin", "width=400px, height=400px");
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
				<div id="detail" class="col-9 p-0">
					<h4>내작품관리</h4>
					<div>
						'내작품관리'에서는 내가 담당한 작품의 상세페이지 조회수, 누적 판매 금액 등의 통계를 조회 할 수 있습니다.<br/>
						작품등록 신청후 관리자 승인이 있어야 메인 화면에 노출됩니다. 공연 일정 등록은 각 작품 상세페이지에서 가능합니다. <br/>
						작품 정보를 수정하면 관리자 승인전까지 메인에 노출되지 않습니다. <br/>
						
					</div>
					<div style="text-align: right;">
					<button class="btn btn-danger m-2" onclick="location.href='${ctp}/member/mypage/myPerform/newPerform';">작품등록 신청</button>
					</div>
					<table class="table table-hover">
						<tr style="font-size: 1.2em;text-align: center;">
							<th>제목</th>
							<th>극장</th>
							<th>공연기간</th>
							<th>예매건수</th>
							<th style="min-width:95px;">상세보기</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td style="font-size: 1.2em;text-align: center;<c:if test="${!vo.checked}">opacity:0.8;</c:if>">
									<c:if test="${vo.checked}">
										<a href="${ctp}/perform/performInfo?idx=${vo.idx}"><b>${vo.title}</b></a>
									</c:if>
									<c:if test="${!vo.checked}">
										<b>${vo.title}</b>(인증대기)
									</c:if>
								</td>
								<td style="text-align: center;">${vo.theater}</td>
								<td>${fn:substring(vo.startDate, 0, 10)}~${fn:substring(vo.endDate, 0, 10)}</td>
								<td style="text-align: center;">${vo.ticketSales}</td>
								<td style="padding: 10px 0;">
									<button type="button" class="btn btn-outline-danger btn-sm" onclick="performStat(${vo.idx})">통계</button>
									<button type="button" class="btn btn-outline-danger btn-sm" 
									onclick="location.href='${ctp}/member/mypage/myPerform/updatePerform?idx=${vo.idx}';">수정</button>
								</td>
							</tr>
						</c:forEach>
					</table>
					<c:set var="linkpath" value="member/mypage/myPerform/performList"/>
					<%@ include file="/WEB-INF/views/include/paging.jsp" %>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>