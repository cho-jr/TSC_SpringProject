<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지-공연정보수정</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<jsp:include page="/WEB-INF/views/include/addressAPI.jsp"/>
<script src="${ctp}/ckeditor/ckeditor.js"></script>
<style type="text/css">
	#inputTable tr th {width:10%;}
</style>
<script type="text/javascript">
	
	var cntP=1;
	var cntS=0;
	var checkedManager = false;	
	// 가격 옵션 추가
	function addPriceForm() {
		cntP++;
		var addPriceForm = '<div class="input-group mb-3" id="priceForm'+cntP+'">'+
		    				'<input type="text" name="seat" id="seat'+cntP+'" class="form-control" placeholder="좌석명/등급">'+
		    				'<input type="number" name="price" id="price'+cntP+'" class="form-control" placeholder="가격">'+
		    				'<div class="input-group-append">'+
			   					'<button class="btn btn-secondary" type="button" onclick="deleteForm(\'#priceForm'+cntP+'\')">삭제</button>'+
							'</div>'+
						'</div>';
		$("#priceForm").append(addPriceForm);
	}
	// 세일 항목 추가
	function addSaleForm() {
		cntS++;
		var addSaleForm = '<div class="input-group mb-3" id="saleForm'+cntS+'">'
							    +'<input type="text" name="sale" id="sale'+cntS+'" class="form-control" placeholder="할인 항목명">'
						    +'<input type="number" name="salePrice" id="salePrice'+cntS+'" class="form-control" placeholder="가격(원)/비율(%)">'
							+'<div class="input-group-prepend">'
							    +'<select name="saleMethod" id="saleMethod'+cntS+'" class="form-control">'
								        +'<option value="0">--할인 방식 선택--</option>'
								        +'<option value="1">할인비율(-%)</option>'
								        +'<option value="2">할인가격(-원)</option>'
								        +'<option value="3">판매가격(원)</option>'
							    +'</select>'
							+'</div>'
						    +'<div class="input-group-append">'
							    +'<button class="btn btn-secondary" type="button" onclick="deleteForm(\'#saleForm'+cntS+'\')">삭제</button>'
							+'</div>'
						+'</div>';
		$("#saleForm").append(addSaleForm);
	}
	
	// 폼 삭제
	function deleteForm(selected) {
		$(selected).remove();
	}
	
	// 등록하기
	function fCheck() {
		// 정규화시작
		var manager = myform.manager.value;
		var title = myform.title.value;
		var theater = myform.theater.value;
		var startDate = myform.startDate.value;
		var endDate = myform.endDate.value;
		var rating = myform.rating.value;
		var runningTime = myform.runningTime.value;
		var seat1 = $("#seat1").val();
		var price1 = $("#price1").val();
		var fName = myform.fName.value;
		
		
		if(title==""){
			alert("제목을 입력하세요.");
			return false;
		}
		if(theater==""){
			alert("극장을 입력하세요.");
			return false;
		}
		if(startDate==""){
			alert("공연 시작일을 입력하세요.");
			return false;
		}
		if(endDate==""){
			alert("공연 종료일을 입력하세요.");
			return false;
		}
		if(rating==""){
			alert("관람등급을 입력하세요.");
			return false;
		}
		if(runningTime==""){
			alert("관람시간을 입력하세요.");
			return false;
		}
		if(seat1==""){
			alert("좌석명을 입력하세요. ");
			return false;
		}
		if(price1==""){
			alert("티켓가격을 입력하세요.");
			return false;
		}
		// 정규화 끝
		
		var ans = confirm("입력하신 내용으로 변경됩니다. 정말 등록하시겠습니까?");
		if(!ans) return false;
		myform.submit();
	}
	
	// 이미지 미리보기
	function setThumbnail(event){
		var reader = new FileReader();

		reader.onload = function(event) {
			var img = document.getElementById("showPoster");
			img.setAttribute("src", event.target.result);
		}
		reader.readAsDataURL(event.target.files[0]);
	}
	function deletePerform(idx){
		var ans = confirm("작품 정보를 모두 삭제하시겠습니까? 삭제한 정보는 복구할 수 었습니다. ");
		if(!ans) return false;
		
		$.ajax({
			type:"post", 
			url: "${ctp}/member/mypage/myPerform/deletePerform", 
			data : {idx : idx}, 
			success: function(){
				location.href = "${ctp}/msg/deletePerformOk";
			}
		});
	}
	
	function goBack(){
		var ans = confirm("수정내용을 저장하지 않고 돌아가시겠습니까?");
		if(!ans) return false;
		history.back();
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
					<h3 style="text-align: center;">작품 수정</h3>
					<section>
						<div class="container-fluid p-0">
							<form class="form-group" name="myform" method="post" enctype="multipart/form-data" action="${ctp}/member/mypage/myPerform/updatePerform">
								<table class="table" id="inputTable">
									<tr>
										<th class="table-danger">담당자</th>
										<td colspan="3">
											<div class="input-group">
												<input type="text" name="manager" id="manager" value="${vo.manager}" class="form-control" required readonly/>
											</div>
										</td>
									</tr>				
									<tr>
										<th class="table-danger">제목</th>
										<td colspan="3"><input type="text" name="title" value="${vo.title}" id="title" placeholder="제목" class="form-control" required/></td>
									</tr>				
									<tr>
										<th class="table-danger">극장</th>
										<td colspan="3">
											<input type="text" name="theater" value="${vo.theater}" id="theater" list="theaterList" placeholder="장소/극장명" class="form-control" required/>
											<datalist id="theaterList">
												<c:forEach var="vo" items="${vos}">
													<option value="${vo.name}/${vo.address1}"></option>
												</c:forEach>
											</datalist>
											<span class="text-muted">*신규 극장은 주소를 입력하세요.</span>
											<div class="form-group">
												<div class="input-group mb-1">
													<div class="input-group-prepend">
														<span class="input-group-text">주소</span>
													</div>
													<input type="text" name="addrCode" id="sample4_postcode" placeholder="우편번호" class="form-control" required > 
													<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-danger"><br>
												</div>
												<div class="input-group">
													<input type="text" name="address1" id="sample4_roadAddress" class="form-control" placeholder="도로명주소" required > 
													<span id="guide" style="color: #999; display: none"></span>
													<input type="text" name="address2" id="sample4_detailAddress" class="form-control" placeholder="상세주소" required > 
													<input type="text" name="address3" id="sample4_extraAddress" class="form-control" placeholder="참고항목" required >
												</div>
											</div>
										</td>
									</tr>	
									<tr>
										<th class="table-danger">공연기간</th>
										<td colspan="3">
											<input type="date" name="startDate" value="${fn:substring(vo.startDate, 0, 10)}">~<input type="date" name="endDate" value="${fn:substring(vo.endDate, 0, 10)}"/>
										</td>
									</tr>			
									<tr>
										<th class="table-danger">관람등급</th>
										<td>
											<select name="rating" id="rating" class="form-control">
												<option <c:if test="${vo.rating==0}">selected</c:if> value="0">전체이용가</option>
												<c:forEach var="age" begin="4" end="18" step="1" >
													<option <c:if test="${vo.rating==age}">selected</c:if> value="${age}">만${age}세이상 </option>
												</c:forEach>
											</select>
										</td>
										<th class="table-danger">관람시간(분)</th>
										<td>
											<div class="input-group mb-3">
												<input type="number" name="runningTime" id="runningTime" value="${vo.runningTime}" min="10" max="999" value="100" class="form-control" required/>
											    <div class="input-group-append">
											      <span class="input-group-text">분</span>
											    </div>
											</div>
										</td>
									</tr>							
									<tr>
										<!-- 동적폼 -> 좌석, 가격 -->
										<th class="table-danger">가격</th>
										<td colspan="3">
											<div id="priceForm">
												<c:set var="seatArr" value="${fn:split(vo.seat, ',')}"/>							
												<c:set var="priceArr" value="${fn:split(vo.price, ',')}"/>							
												<c:forEach var="seat" items="${seatArr}" varStatus="st">
													<div class="input-group mb-3" id="priceForm1">
													    <input type="text" name="seat" id="seat${st.count}" class="form-control" value="${seat}" required>
													    <input type="number" name="price" id="price${st.count}" class="form-control" value="${priceArr[st.index]}" required>
													</div>
													<script type="text/javascript">cntP++;</script>
												</c:forEach>
												<script type="text/javascript">cntP--;</script>
											</div>
											<button type="button" onclick="addPriceForm()" class="btn btn-secondary">좌석/가격 추가</button>
										</td>
									</tr>				
									<tr>
										<!-- 동적폼 -> 할인 항목, 가격/비율 선택 -->
										<th class="table-danger">할인</th>
										<td colspan="3">
											<button type="button" onclick="addSaleForm()" class="btn btn-secondary">할인 항목 추가</button>
											<div id="saleForm">
												<c:set var="saleArr" value="${fn:split(vo.sale, ',')}"/>							
												<c:set var="salePriceArr" value="${fn:split(vo.salePrice, ',')}"/>		
												<c:set var="saleMethodArr" value="${fn:split(vo.saleMethod, ',')}"/>		
												<c:forEach var="sale" items="${saleArr}" varStatus="st">
													<div class="input-group mb-3" id="saleForm${st.count}">
													    <input type="text" name="sale" id="sale${st.count}" class="form-control" value="${sale}">
													    <input type="number" name="salePrice" id="salePrice${st.count}" class="form-control" value="${salePriceArr[st.index]}">
														<div class="input-group-prepend">
														    <select name="saleMethod" id="saleMethod${st.count}" class="form-control">
														    	<c:set var="selected" value="${saleMethodArr[st.index]}"/>
														        <option value="0">--할인 방식 선택--</option>
														        <option value="1" <c:if test="${selected==1}">selected</c:if>>할인비율(-%)</option>
														        <option value="2" <c:if test="${selected==2}">selected</c:if>>할인가격(-원)</option>
														        <option value="3" <c:if test="${selected==3}">selected</c:if>>판매가격(원)</option>
														    </select>
														</div>
													    <div class="input-group-append">
														    <button class="btn btn-secondary" type="button" onclick="deleteForm(\'#saleForm${st.count}\')">삭제</button>
														</div>
													</div>
													<script type="text/javascript">cntS++;</script>
												</c:forEach>
											</div>
										</td>
									</tr>				
									<tr>
										<th class="table-danger">포스터</th>
										<td colspan="3">
											<input type="file" name="fName" id="fName" class="form-control" accept=".jpg,.png" onchange="setThumbnail(event);"/>
											<img id="showPoster" src="${ctp}/${vo.posterFSN}" width="100px;"/>
										</td>
									</tr>				
									<tr>
										<th class="table-danger">상세정보</th>
										<td colspan="3">
											<textarea rows="6" name="content" id="CKEDITOR" class="form-control" required>
												${vo.content}
											</textarea>
										</td>
									    <script>
									      	CKEDITOR.replace("content",{
									      		uploadUrl: "${ctp}/imageUpload",				
									      		filebrowserUploadUrl : "${ctp}/imageUpload",	
									      		height:460
									      	});
									   	</script>
									</tr>	
									<tr>
										<th></th>
										<td align="right" colspan="3">
											<button class="btn btn-outline-secondary btn-sm" onclick="deletePerform(${vo.idx})">작품삭제</button>
											<button type="button" onclick="goBack()" class="btn btn-secondary">돌아가기</button>
											<button type="button" onclick="fCheck()" class="btn btn-secondary">등록</button>
										</td>
									</tr>			
								</table>
								<input type="hidden" value="false" name="checked"/>
								<input type="hidden" name="idx" value="${vo.idx}"/>
								<input type="hidden" name="oriPosterFSN" value="${vo.posterFSN}"/>
								<input type="hidden" name="oriContent"/>
	 	 						<div id="oriContent" style="display:none;">${vo.content}</div>
							</form>
						</div>
					</section>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>