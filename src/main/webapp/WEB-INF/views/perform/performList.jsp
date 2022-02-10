<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>performList.jsp</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style type="text/css">
	.card-img-overlay {visibility: hidden;}
	.card:hover .card-img-overlay {visibility: visible;background-color: rgba(0, 0, 0, 0.4);z-index: 99;}
	h2{margin:10px 0 0 10px; font-weight: 500;}
	label {font-size: 1.2em}
	#ListHead {padding:0;margin:0;}
	#ListHead td{padding:0 10px;margin:0;}
</style>
<script>
	var orderBy = '${orderBy}';
	// 공연중 작품만 보기, 전체 작품 보기
	function changeList() {
		var condition = $("#condition").val();
		location.href="${ctp}/perform/performList?condition="+condition+"&orderBy=${orderBy}";
	}

	function changeOrderBy() {
		var orderBy = $("#orderBy").val();
		location.href="${ctp}/perform/performList?condition=${condition}&orderBy="+orderBy;
	}
		
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section class="row">
		<div class="col-2"></div>
		<div style="width:1000px;" class="col-8">
			<br/>
			<%@ include file="/WEB-INF/views/include/main/carouselAdv.jsp" %>
			<br/><br/>
			<c:if test="${not empty keyWord}"><h2>'${keyWord}' 검색결과</h2></c:if>
			<c:if test="${empty keyWord}"><h2>전체작품</h2></c:if>
			
			<table id="ListHead" class="table table-borderless">
				<tr>
					<td style="width:55%"></td>
					<td style="width:20%">
						<select class="form-control mr-4" id="condition" onchange="changeList()">
							<option value="proceeding" <c:if test="${condition=='proceeding'}">selected</c:if>>공연중</option>
							<option value="comingsoon" <c:if test="${condition=='comingsoon'}">selected</c:if>>공연예정작</option>
							<option value="all" <c:if test="${condition=='all'}">selected</c:if>>전체보기</option>
							<option value="last" <c:if test="${condition=='last'}">selected</c:if>>지난 공연</option>
						</select>
					</td>
					<td style="width:21%">
						<select class="form-control mr-4" id="orderBy" onchange="changeOrderBy()">
							<option value="ticketSales" <c:if test="${orderBy=='ticketSales'}">selected</c:if>>예매 많은순</option>
							<option value="endDate" <c:if test="${orderBy=='endDate'}">selected</c:if>>남은 공연일순</option>
							<option value="startDate" <c:if test="${orderBy=='startDate'}">selected</c:if>>공연시작일순</option>
							<option value="star" <c:if test="${orderBy=='star'}">selected</c:if>>관객 평점순</option>
						</select>
					</td>
					<td style="width:4%">
					</td>
				</tr>
			</table>
			<table>
				<tr>
				<c:set var="cnt" value="0"/>
				<c:forEach var="vo" items="${vos}">
					<c:set var="cnt" value="${cnt+1}"/>
					<td>
						<div class="card" style="width:300px;margin:10px;">
						    <img class="card-img-top" src="${ctp}/${vo.posterFSN}" alt="Card image" style="width:100%;height:367px;">
						    <div class="card-img-overlay align-middle" style="text-align:center;">
						    	<div style="position:relative;top:0px;height:480px;">
									<a href="${ctp}/perform/performInfo?idx=${vo.idx}" class="btn btn-danger stretched-link"
										style="margin:160px 30px;">상세보기</a><br/>
						    	</div>
							</div>
						    <div class="card-body">
						    	<c:if test="${fn:length(vo.title)>12}"><h4 class="card-title">${fn:substring(vo.title, 0, 12)}...</h4></c:if>
						    	<c:if test="${fn:length(vo.title)<=12}"><h4 class="card-title">${vo.title}</h4></c:if>
							    <p class="card-text">${fn:substring(vo.startDate,0,10)} ~ ${fn:substring(vo.endDate,0,10)}</p>
							    <p class="card-text">${vo.theater}</p>
							    <p class="card-text"><span style="color:#aa3;">★</span>${fn:substring(vo.star, 0, 3)}</p>
						    </div>
						</div>
					</td>
					<c:if test="${cnt%3==0}"> </tr><tr> </c:if>
				</c:forEach>
				<c:if test="${cnt<=3}">
					<c:if test="${empty vos}">
						<tr style="height:100px; font-size: 2em;"><td colspan="3" style="padding:20px;"> 선택하신 조건에 맞는 공연이 없습니다...😥😥</td></tr>
					</c:if>
					<tr style="font-size: 2em;font-weight:700;"><td colspan="3" style="padding:40px;">😍진행중인 공연 더보기😍<br/></td></tr>
					<c:set var="cnt" value="0"/>
					<c:forEach var="vo" items="${moreVos}">
						<c:set var="cnt" value="${cnt+1}"/>
						<td>
							<div class="card" style="width:300px;margin:10px;">
							    <img class="card-img-top" src="${ctp}/${vo.posterFSN}" alt="Card image" style="width:100%;height:367px;">
							    <div class="card-img-overlay align-middle" style="text-align:center;">
							    	<div style="position:relative;top:0px;height:480px;">
										<a href="${ctp}/perform/performInfo?idx=${vo.idx}" class="btn btn-danger stretched-link"
											style="margin:160px 30px;">상세보기</a><br/>
							    	</div>
								</div>
							    <div class="card-body">
							    	<c:if test="${fn:length(vo.title)>12}"><h4 class="card-title">${fn:substring(vo.title, 0, 12)}...</h4></c:if>
							    	<c:if test="${fn:length(vo.title)<=12}"><h4 class="card-title">${vo.title}</h4></c:if>
								    <p class="card-text">${fn:substring(vo.startDate,0,10)} ~ ${fn:substring(vo.endDate,0,10)}</p>
								    <p class="card-text">${vo.theater}</p>
								    <p class="card-text"><span style="color:#aa3;">★</span>${fn:substring(vo.star, 0, 3)}</p>
							    </div>
							</div>
						</td>
						<c:if test="${cnt%3==0}"> </tr><tr> </c:if>
					</c:forEach>
				</c:if>
			</table>
		</div>
		<div class="col-2 pl-2">
			<div style="position:sticky; top:30px;">
				<img class="cardAdv" src="${ctp}/images/advertise/${CAVo1.FSName}"/>
				<img class="cardAdv" src="${ctp}/images/advertise/${CAVo2.FSName}"/>
			</div>
		</div>
	</section>
	<br/><br/><br/>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>