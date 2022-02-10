<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/setMain/setMainAd"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<script type="text/javascript">
	function mainAdCheck() {
	 	var file = mainAdForm.file.value;
	 	var ext = file.substring(file.lastIndexOf(".")+1);  // 화일의 확장자만 구하기
	 	var uExt = ext.toUpperCase();  // 확장자를 대문자로 치환
	 	//var maxSize = 1024 * 1024 * 10;   // 최대 10MByte 까지 허용
	 	var title = mainAdForm.title.value;
	 	var subMent = mainAdForm.subMent.value;
	 	
	 	if(file == "") {
	 		alert("업로드할 파일을 선택하세요!");
	 		return false;
	 	}
	 	else if(title == "") {
	 		alert("업로드할 파일의 제목을 입력하세요!");
	 		mainAdForm.title.focus();
	 		return false;
	 	}
	 	else if(subMent == "") {
	 		alert("추가 설명을 입력하세요!");
	 		mainAdForm.subMent.focus();
	 		return false;
	 	}
	 	
	 	if(uExt != "MP4") {
	 		alert("업로드 가능파일은 'MP4'파일만 가능합니다.");
	 		return false;
	 	}
	 	else {
	 		mainAdForm.submit();
	 	}
	}
	
	//배너광고 등록 검사
	function bannerCheck(){
		var file = bannerForm.file.value;
	 	var ext = file.substring(file.lastIndexOf(".")+1);  // 화일의 확장자만 구하기
	 	var uExt = ext.toUpperCase();  // 확장자를 대문자로 치환
	 	
	 	if(file == "") {
	 		alert("업로드할 파일을 선택하세요!");
	 		return false;
	 	}
	 	if(uExt != "JPG" && uExt != "PNG" && uExt != "GIF") {
	 		alert("업로드 가능파일은 '.jpg, .png, .gif' 파일만 가능합니다.");
	 		return false;
	 	}
	 	else {
	 		bannerForm.submit();
	 	}
	}
	//슬림광고 등록 검사
	function slimAdCheck(){
		var file = slimForm.file.value;
	 	var ext = file.substring(file.lastIndexOf(".")+1);  // 화일의 확장자만 구하기
	 	var uExt = ext.toUpperCase();  // 확장자를 대문자로 치환
	 	
	 	if(file == "") {
	 		alert("업로드할 파일을 선택하세요!");
	 		return false;
	 	}
	 	if(uExt != "JPG" && uExt != "PNG" && uExt != "GIF") {
	 		alert("업로드 가능파일은 '.jpg, .png, .gif' 파일만 가능합니다.");
	 		return false;
	 	}
	 	else {
	 		slimForm.submit();
	 	}
	}
	//카드광고 등록 검사
	function cardCheck(){
		var file = cardForm.file.value;
	 	var ext = file.substring(file.lastIndexOf(".")+1);  // 화일의 확장자만 구하기
	 	var uExt = ext.toUpperCase();  // 확장자를 대문자로 치환
	 	
	 	if(file == "") {
	 		alert("업로드할 파일을 선택하세요!");
	 		return false;
	 	}
	 	if(uExt != "JPG" && uExt != "PNG" && uExt != "GIF") {
	 		alert("업로드 가능파일은 '.jpg, .png, .gif' 파일만 가능합니다.");
	 		return false;
	 	}
	 	else {
	 		cardForm.submit();
	 	}
	}
	
	// 숨김
	function checkFalse(idx){
		$.ajax({
			type:"post", 
			url: "${ctp}/admin/setMain/advCheckFalse", 
			data: {idx : idx}, 
			success: function(data) {
				if(data=="false") {
					alert("광고가 1개 이상 필요합니다. 먼저 추가 또는 숨김해제 해주세요. ")
				} else {
					location.href="${ctp}/${linkpath}";
				}
			}
		});
	}
	
	// 숨김해제
	function checkTrue(idx){
		$.ajax({
			type:"post", 
			url: "${ctp}/admin/setMain/advCheckTrue", 
			data: {idx : idx}, 
			success: function() {
				location.href="${ctp}/${linkpath}";
			}
		});
	}
	// 삭제
	function deleteAdv(idx){
		var ans = confirm("정말 삭제하시겠습니까?");
		if(!ans) return false;
		$.ajax({
			type:"post", 
			url: "${ctp}/admin/setMain/deleteAdv", 
			data: {idx : idx}, 
			success: function(data) {
				if(data=="false") {
					alert("광고가 1개 이상 필요합니다. 먼저 추가 또는 숨김해제 해주세요. ")
				} else {
					alert("삭제했습니다. ");
					location.href="${ctp}/${linkpath}";
				}
			}
		});
	}
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container-fluid">
			<h3>&lt;광고 설정&gt;</h3>
			
			<ul class="nav nav-tabs mb-4" style="justify-content:flex-start;font-size: 1.5em;">
			    <li class="nav-item">
			    	<a class="nav-link active" data-toggle="tab" href="#main" id="maint">메인영상</a>
			    </li>
			    <li class="nav-item">
			    	<a class="nav-link" data-toggle="tab" href="#banner" id="bannert">배너</a>
			    </li>
			    <li class="nav-item">
			    	<a class="nav-link" data-toggle="tab" href="#slim" id="slimt">슬림</a>
			    </li>
			    <li class="nav-item">
			    	<a class="nav-link" data-toggle="tab" href="#card" id="cardt">카드</a>
			    </li>
			</ul>
			
			<!-- Tab panes -->
			<div class="tab-content">
			    <div class="tab-pane container active" id="main">
			    	<form name="mainAdForm" method="post" enctype="multipart/form-data" action="${ctp}/admin/setMain/addMainVideo">
						<input type="file" accept=".mp4" name="file" id="file"/>
						<input type="text" name="title" class="form-control" placeholder="영상제목"/>
						<textarea rows="3" class="form-control" name="subMent" placeholder="추가설명"></textarea>
						<input type="button" class="btn btn-danger btn-sm" value="등록" onclick="mainAdCheck()"/>
						<input type="hidden" name="fsize"/>
					</form>
					<hr/>
					<h4>현재 광고</h4>
					<div class="row">
						<c:forEach items="${vos}" var="vo">
							<c:if test="${vo.adtype=='main'}">
								<div id="${vo.idx}" class="col-3 p-3" <c:if test="${!vo.checked}">style="opacity:0.6;"</c:if>>
									<video autoplay muted width="100%" >
										<source src='${ctp}/images/advertise/${vo.FSName}' type='video/mp4'>
									</video><br/>
									${vo.title}<br/>
									${vo.subMent}<br/>
									<c:if test="${vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkFalse(${vo.idx})">숨김</button>
									</c:if>
									<c:if test="${!vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkTrue(${vo.idx})">숨김해제</button>
									</c:if>
									<button class="btn btn-sm btn-danger" onclick="deleteAdv(${vo.idx})">삭제</button>
								</div>
							</c:if>
						</c:forEach>
					</div>
			    </div>
			    
			    <div class="tab-pane container fade" id="banner">
				    <form name="bannerForm" enctype="multipart/form-data" method="post" action="${ctp}/admin/setMain/addBanner">
						<input type="file" accept=".jpg, .png, .gif" name="file"/>
						<input type="button" class="btn btn-danger btn-sm" value="등록" onclick="bannerCheck()"/>
					</form>
					<div class="row">
						<c:forEach items="${vos}" var="vo">
							<c:if test="${vo.adtype=='banner'}">
								<div id="${vo.idx}" class="col-4 p-3" <c:if test="${!vo.checked}">style="opacity:0.6;"</c:if>>
									<img alt="배너광고" src='${ctp}/images/advertise/${vo.FSName}' style="width:100%;">
									
									<c:if test="${vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkFalse(${vo.idx})">숨김</button>
									</c:if>
									<c:if test="${!vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkTrue(${vo.idx})">숨김해제</button>
									</c:if>
									<button class="btn btn-sm btn-danger" onclick="deleteAdv(${vo.idx})">삭제</button>
								</div>
							</c:if>
						</c:forEach>
					</div>
			    </div>
			    
			    <div class="tab-pane container fade" id="slim">
			    	<form name="slimForm" enctype="multipart/form-data" method="post" action="${ctp}/admin/setMain/addSlim">
						<input type="file" accept=".jpg, .png, .gif" name="file"/>
						<input type="button" class="btn btn-danger btn-sm" value="등록" onclick="slimAdCheck()"/>
					</form>
					<div class="row">
						<c:forEach items="${vos}" var="vo">
							<c:if test="${vo.adtype=='slim'}">
								<div id="${vo.idx}" class="col-10 p-3" <c:if test="${!vo.checked}">style="opacity:0.6;"</c:if>>
									<img alt="슬림광고" src='${ctp}/images/advertise/${vo.FSName}' style="width:100%;">
									
									<c:if test="${vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkFalse(${vo.idx})">숨김</button>
									</c:if>
									<c:if test="${!vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkTrue(${vo.idx})">숨김해제</button>
									</c:if>
									<button class="btn btn-sm btn-danger" onclick="deleteAdv(${vo.idx})">삭제</button>
								</div>
							</c:if>
						</c:forEach>
					</div>
			    </div>
			    <div class="tab-pane container fade" id="card">
			    	<form name="cardForm" enctype="multipart/form-data" method="post" action="${ctp}/admin/setMain/addCard">
						<input type="file" accept=".jpg, .png, .gif" name="file"/>
						<input type="button" class="btn btn-danger btn-sm" value="등록" onclick="cardCheck()"/>
					</form>
						<div class="row">
						<c:forEach items="${vos}" var="vo">
							<c:if test="${vo.adtype=='card'}">
								<div id="${vo.idx}" class="col-2 p-3" <c:if test="${!vo.checked}">style="opacity:0.6;"</c:if>>
									<img alt="슬림광고" src='${ctp}/images/advertise/${vo.FSName}' style="width:100%;">
									
									<c:if test="${vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkFalse(${vo.idx})">숨김</button>
									</c:if>
									<c:if test="${!vo.checked}">
										<button class="btn btn-sm btn-danger" onclick="checkTrue(${vo.idx})">숨김해제</button>
									</c:if>
									<button class="btn btn-sm btn-danger" onclick="deleteAdv(${vo.idx})">삭제</button>
								</div>
							</c:if>
						</c:forEach>
					</div>
			    </div>
			</div>
		</div>
	</section>
</body>
</html>