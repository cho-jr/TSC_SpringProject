<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="linkpath" value="admin/setPerform/adminPerformList"/>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<style type="text/css">
	.hoverShow {visibility: hidden;}
	tr:hover .hoverShow {visibility: visible;}
	th { text-align: center;}
	#tableHeader td{padding:5px;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$("#tableHeader td").addClass("align-bottom");
		$("#selectAll").on("change", function() {
			if($("#selectAll").is(":checked")) {
				$("input[name=selectedIdx]").prop("checked", true);
			} else {
				$("input[name=selectedIdx]").prop("checked", false);
			}
		});
		$("input[name=selectedIdx]").on("change", function() {
			if($("input[name=selectedIdx]:checked").length==$("input[name=selectedIdx]").length) {
				$("#selectAll").prop("checked", true);
			} else {
				$("#selectAll").prop("checked", false);
			}
		});
	});

	function hide() {
		var idx = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			idx.push($(this).val().substring(0, $(this).val()));
		});
		
		if(idx.length==0) {
			alert("작품을 먼저 선택해주세요. ");
			return false;
		}
		var ans = confirm("인증해제 하면 메인 홈페이지 작품 목록에 노출되지 않습니다. 인증해제 하시겠습니까?");
		if(!ans) return false;
		
		for(var i in idx) {
			$.ajax({
				type:"post", 
				data : {idx : idx[i]}, 
				url: "${ctp}/admin/setPerform/checkedFalse"
			});
		}
		alert("인증해제 완료했습니다. ");
		location.href='${ctp}/${linkpath}?keyWord=${keyWord}&condition=${condition}&orderBy=${orderBy}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}';
	}
	
	function show() {
		var idx = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			idx.push($(this).val().substring(0, $(this).val()));
		});
		
		if(idx.length==0) {
			alert("작품을 먼저 선택해주세요. ");
			return false;
		}
		var ans = confirm("관리자 인증시 메인 홈페이지 작품 목록에 노출됩니다. 인증처리 하시겠습니까?");
		if(!ans) return false;
		
		for(var i in idx) {
			if(i!= null){
				$.ajax({
					type:"post", 
					data : {idx : idx[i]}, 
					url: "${ctp}/admin/setPerform/checkedTrue"
				});
			}
		}
		alert("관리자 인증처리 완료했습니다. ");
		location.href='${ctp}/${linkpath}?keyWord=${keyWord}&condition=${condition}&pag=${pagingVO.pag}&orderBy=${orderBy}&pageSize=${pagingVO.pageSize}';
	}
	
	function deletePerform(){
		var idx = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			idx.push($(this).val().substring(0, $(this).val()));
		});
		
		if(idx.length==0) {
			alert("작품을 먼저 선택해주세요. ");
			return false;
		}
		var ans = confirm("인증해제처리로 작품을 메인화면에 노출시키지 않을 수 있습니다. 삭제하시면 모든 작품 정보가 지워집니다. 정말 삭제하시겠습니까..?");
		if(!ans) return false;
		
		for(var i in idx) {
			if(i!= null){
				$.ajax({
					type:"post", 
					data : {idx : idx[i]}, 
					url: "${ctp}/admin/setPerform/performDelete"
				});
			}
		}
		alert("삭제했습니다. ");
		location.href='${ctp}/${linkpath}?keyWord=${keyWord}&condition=${condition}&pag=${pagingVO.pag}&orderBy=${orderBy}&pageSize=${pagingVO.pageSize}';
	}
	
	// 작품 정보 새창 띄우기
	function detailPerform(idx) {
		var url = "${ctp}/admin/setPerform/detailPerform?idx="+idx;
		window.open(url, "infoWin", "width=800px,height=600px");
	}
	// 공연 일정 등록/수정 새창 띄우기
	function updateSchedule(idx) {
		//var url = "${ctp}/admin/setPerform/updatePerformSchedule?idx="+idx;
		//var url = "${ctp}/member/mypage/myPerform/updatePerformSchedule?idx="+idx;
		var url = "${ctp}/member/mypage/myPerform/updatePerformSchedule?idx="+idx;
		window.open(url, "scheduleWin", "width=800px,height=650px");
	}
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&condition=${condition}&orderBy=${orderBy}&pageSize=${pagingVO.pageSize}";
		location.href = link;
	}
	$(document).ready(function() {
		$("#pageSize").on("change", function() {
			var link = "${ctp}/${linkpath}?condition=${condition}&orderBy=${orderBy}&pageSize="+$(this).val()+"&keyWord=${keyWord}";
			location.href = link;
		});
		$("#condition").on("change", function() {
			var link = "${ctp}/${linkpath}?condition="+$(this).val()+"&orderBy=${orderBy}&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}";
			location.href = link;
		});
		$("#orderBy").on("change", function() {
			var link = "${ctp}/${linkpath}?condition=${condition}&orderBy="+$(this).val()+"&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}";
			location.href = link;
		});
		
	});
	
	function sendMailForm(email){
		myform.to.value = email;
		$("#myModal").modal();
	}
	
	function sendMail(){
		var title = myform.title.value;
		var content = myform.content.value;
		var to = myform.to.value;
		
		if(to==""){
			alert("받는 사람을 입력하세요. ");
			return false;
		}
		if(title==""){
			alert("제목을 입력하세요. ");
			return false;
		}
		if(content==""){
			alert("내용을 입력하세요. ");
			return false;
		}
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		myform.submit();
	}
</script>
</head>
<body style="margin-left: 20px;">
	<div id="lost_mask" style="position:fixed;z-index:9000;display:none;left:0;top:0; z-index:9000;background-color:#5558;text-align:center;color:white;">
		<div style="display: flex; align-items: center;margin: auto; height:100%;">
			<div class="spinner-border" style="margin: auto;"></div>
		</div>
	</div> 
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container">
			<h3>&lt;작품 목록&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td>
						<div class="custom-control custom-checkbox mb-2">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</div>
					</td>
					<td style="width:8%"><button class="btn btn-danger btn-sm" onclick="location.href='${ctp}/${linkpath}'">전체보기</button></td>
					<td style="width:9%">
						<select class="form-control" id="pageSize">
							<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2줄</option>
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5줄</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10줄</option>
						</select>
					</td>
					<td style="width:15%">
						<select class="form-control" id="condition">
							<option value="all" <c:if test="${condition=='all'}">selected</c:if>>전체</option>
							<option value="proceeding" <c:if test="${condition=='proceeding'}">selected</c:if>>공연중</option>
							<option value="last" <c:if test="${condition=='last'}">selected</c:if>>지난공연</option>
							<option value="comingsoon" <c:if test="${condition=='comingsoon'}">selected</c:if>>공연예정</option>
						</select>
					</td>
					<td style="width:20%">
						<select class="form-control" id="orderBy">
							<option value="ticketSales" <c:if test="${orderBy=='ticketSales'}">selected</c:if>>예매량순</option>
							<option value="endDate" <c:if test="${orderBy=='endDate'}">selected</c:if>>남은공연일순</option>
							<option value="manager" <c:if test="${orderBy=='manager'}">selected</c:if>>담당자별</option>
							<option value="theater" <c:if test="${orderBy=='theater'}">selected</c:if>>극장별</option>
							<option value="checked" <c:if test="${orderBy=='checked'}">selected</c:if>>미인증작우선</option>
							<option value="star" <c:if test="${orderBy=='star'}">selected</c:if>>별점순</option>
						</select>
					</td>
					<td style="width:33%">
						<div class="input-group">
						    <input type="text" class="form-control" value="${keyWord}" id="keyWord" placeholder="제목, 극장, 담당자 검색가능">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
						    </div>
						</div>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<thead>
					<tr class="text-center table-secondary">
						<th>선택</th>
						<th>idx</th>
						<th>담당자</th>
						<th>제목</th>
						<th>극장</th>
						<th style="min-width:240px;">공연기간</th>
						<th>상세보기</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${vos}">
						<tr>
							<td><input type="checkbox" value="${vo.idx}" name="selectedIdx"></td>
							<td>${vo.idx}</td>
							<td ondblclick="sendMailForm('${vo.manager}')">${vo.manager}</td>
							<td <c:if test="${!vo.checked}">style="opacity:0.7;"</c:if>>
									<c:if test="${vo.checked}">
										<a href="${ctp}/perform/performInfo?idx=${vo.idx}" target="_blank">
											<b>${vo.title}&nbsp;<span style="color:#fc0;">★</span>${fn:substring(vo.star, 0, 4)} </b>
										</a>
									</c:if>
									<c:if test="${!vo.checked}"><b>${vo.title}&nbsp;<span style="color:#fc0;">★</span>${fn:substring(vo.star, 0, 4)} </b>(인증대기)</c:if>
							</td>
							<td>${vo.theater }</td>
							<td>${fn:substring(vo.startDate,0,10)} ~ ${fn:substring(vo.endDate,0,10)}</td>
							<td style="width:170px;">
								<div class="hoverShow input-group">
										<button type="button" class="btn btn-outline-secondary btn-sm" onclick="detailPerform(${vo.idx})">작품상세정보</button>
										<button type="button" class="btn btn-outline-secondary btn-sm" onclick="updateSchedule(${vo.idx})">일정</button>
								</div>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<c:set var="linkpath" value="admin/setPerform/adminPerformList"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
			<button class="btn btn-secondary" onclick="hide()">인증해제</button>
			<button class="btn btn-secondary" onclick="show()">인증</button>
			<button class="btn btn-secondary btn-sm" onclick="deletePerform()">삭제</button>
		</div>
	</section>
	
	<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">메일 쓰기</h4>
					<button type="button" class="close" data-dismiss="modal">×</button>
				</div>
				<div class="modal-body text-right">
					<form name="myform" method="post" action="${ctp}/admin/setPerform/sendMail">
						<input type="text" name="to" class="form-control mb-1" placeholder="받는 사람"/>
						<input type="text" name="title" class="form-control mb-1" placeholder="제목"/>
						<textarea rows="5" name="content" class="form-control" placeholder="내용을 입력하세요. "></textarea>
						<button class="btn btn-danger btn-sm" type="button" onclick="sendMail()">전 송</button>
						<input type="hidden" name="nick" value="${vo.nick}"/>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>