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
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<script src="${ctp}/ckeditor/ckeditor.js"></script>
<style type="text/css">
	#inputTable tr th {width:10%;}
</style>
<script type="text/javascript">
	var cntS = 0;
	var cntP = 0;

	// 이미지 미리보기
	function setThumbnail(event){
		var reader = new FileReader();

		reader.onload = function(event) {
			var img = document.getElementById("showPoster");
			img.setAttribute("src", event.target.result);
		}
		reader.readAsDataURL(event.target.files[0]);
	}
	
	$(document).ready(function(){
		$('#content img').css({
			"width" : "100%", 
			"height" : "auto"	
		});
	});
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container-fluid" style="width:100%;">
			<h3>&lt;작품상세보기&gt;</h3>
				<table class="table" id="inputTable" style="width:800px;">
					<tr>
						<th class="table-secondary" style="width:20%;min-width:150px;">담당자 이메일</th>
						<td colspan="3">${vo.manager}</td>
					</tr>				
					<tr>
						<th class="table-secondary">제목</th>
						<td colspan="3">${vo.title}</td>
					</tr>				
					<tr>
						<th class="table-secondary">극장</th>
						<td colspan="3">${vo.theater}</td>
					</tr>	
					<tr>
						<th class="table-secondary">공연 기간</th>
						<td colspan="3">
							${fn:substring(vo.startDate, 0, 10)}~${fn:substring(vo.endDate, 0, 10)}
						</td>
					</tr>			
					<tr>
						<th class="table-secondary">관람등급</th>
						<td>
							<c:if test="${vo.rating==0}">전체이용가</c:if>
							<c:if test="${vo.rating!=0}">만${vo.rating}세이상</c:if>
						</td>
						<th class="table-secondary" style="width:20%;">관람시간(분)</th>
						<td>${vo.runningTime}분</td>
					</tr>							
					<tr>
						<!-- 동적폼 -> 좌석, 가격 -->
						<th class="table-secondary">가격</th>
						<td colspan="3">
							<div id="priceForm">
								<c:set var="seatArr" value="${fn:split(vo.seat, ',')}"/>							
								<c:set var="priceArr" value="${fn:split(vo.price, ',')}"/>							
								<c:forEach var="seat" items="${seatArr}" varStatus="st">
									<div class="input-group mb-3" id="priceForm1"><span class="emphasis">${seat}/${priceArr[st.index]}</span></div>
									<script type="text/javascript">cntP++;</script>
								</c:forEach>
									<script type="text/javascript">cntP--;</script>
							</div>
						</td>
					</tr>				
					<tr>
						<!-- 동적폼 -> 할인 항목, 가격/비율 선택 -->
						<th class="table-secondary">할인</th>
						<td colspan="3">
							<div id="saleForm">
								<c:set var="saleArr" value="${fn:split(vo.sale, ',')}"/>							
								<c:set var="salePriceArr" value="${fn:split(vo.salePrice, ',')}"/>		
								<c:set var="saleMethodArr" value="${fn:split(vo.saleMethod, ',')}"/>		
								<c:forEach var="sale" items="${saleArr}" varStatus="st">
									<div class="input-group mb-3" id="saleForm${st.count}">
									    ${sale} : <span class="emphasis">${salePriceArr[st.index]}</span>
								    	<c:set var="selected" value="${saleMethodArr[st.index]}"/>
								       	<c:if test="${selected==1}">% 할인</c:if>
								      	<c:if test="${selected==2}">원 할인</c:if>
								        <c:if test="${selected==3}">원</c:if>
									</div>
									<script type="text/javascript">cntS++;</script>
								</c:forEach>
							</div>
						</td>
					</tr>				
					<tr>
						<th class="table-secondary">포스터</th>
						<td colspan="3"><img id="showPoster" src="${ctp}/${vo.posterFSN}" width="200px;"/></td>
					</tr>				
					<tr>
						<th class="table-secondary">상세정보</th>
						<td colspan="3">
							<div style="height:500px; overflow: auto;width:700px;" id="content">
								${vo.content}
							</div>
						</td>
					</tr>	
					<tr>
						<th></th>
						<td align="right" colspan="3">
							<button type="button" onclick="window.close()" class="btn btn-secondary">닫기</button>
							<button type="button" onclick="location.href='${ctp}/admin/setPerform/updatePerform?idx=${vo.idx}'" class="btn btn-secondary">수정</button>
						</td>
					</tr>			
				</table>
				<input type="hidden" value="true" name="checked"/>
				<input type="hidden" name="idx" value="${vo.idx}"/>
				<input type="hidden" name="oriPosterFSN" value="${vo.posterFSN}"/>
				
				<input type="hidden" name="oriContent"/>
	 	 		<div id="oriContent" style="display:none;">${vo.content}</div>
			</form>
		</div>
	</section>
</body>
</html>