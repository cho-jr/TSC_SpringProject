<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/setTheater/theaterList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<script type="text/javascript">
	$(document).ready(function(){
		$("#tableHeader td").addClass("align-bottom");
		$("#pageSize").on("change", function() {
			location.href = "${ctp}/${linkpath}?keyWord=${keyWord}&orderBy=${orderBy}&pag=1&pageSize="+$("#pageSize").val();
		});
		/* $("#orderBy").on("change", function() {
			var link = "${ctp}/${linkpath}?orderBy="+$(this).val()+"&pag=1&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}";
			location.href = link;
		}); */
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
	
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}";
		location.href = link;
	}
	
	function deleteTheater(idx) {
		var ans = confirm("선택하신 극장을 목록에서 삭제하시겠습니까?");
		if(!ans) return false;
		
		$.ajax({
			type: "post", 
			url: "${ctp}/admin/setTheater/deleteTheater", 
			data: {idx:idx}, 
			success: function() {
				alert("삭제했습니다. ");
				location.href="${ctp}/${linkpath}?keyWord=${keyWord}&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}";
			}
		});
	}
	function deleteTheaters() {
		var theaters = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			theaters.push($(this).val());
		});
		if(theaters.length==0) {
			alert("선택된 극장이 없습니다. ");
			return false;
		}
		var ans = confirm("선택하신 극장을 목록에서 삭제하시겠습니까?");
		if(!ans) return false;
		for(let i=0; i<theaters.length; i++) {
			$.ajax({
				type: "post", 
				url: "${ctp}/admin/setTheater/deleteTheater", 
				data: {idx:theaters[i]}
			});
		}
		alert("삭제했습니다.");
		location.href="${ctp}/${linkpath}?keyWord=${keyWord}&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}";
	}
	
	var correcting = false;
	// 수정할 수 있게 폼 변경, 수정버튼->저장버튼
	function correction(idx) {
		if(correcting) {
			alert("이미 수정중인 항목이 있습니다. ");
			return false;
		}
		$("#address2_"+idx).html('<input type="text" class="form-control" value="'+$("#address2_"+idx).html()+'"/>');
		$("#correctionBtn"+idx).html('<button type="button" class="btn btn-secondary btn-sm" onclick="save('+idx+')">저장</button>');
		correcting = true;
	}
	
	// 수정 내용 저장처리
	function save(idx){
		var updateAddress = $("#address2_"+idx+" input").val();
		var query = {
				idx:idx, 
				address2: updateAddress
		}
		$.ajax({
			type: "post", 
			url: "${ctp}/admin/setTheater/updateTheaterAddress", 
			data: query, 
			success: function() {
				$("#address2_"+idx).html(updateAddress);
				$("#correctionBtn"+idx).html('<button type="button" class="btn btn-secondary btn-sm" onclick="correction('+idx+')">수정</button>');
			}
		});
		correcting = false;
	}
	
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>
	<section>
		<div class="container-fluid m-3">
			<h3>&lt;극장 목록&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td style="width:12%; min-width: 140px;">
						<div class="custom-control custom-checkbox mb-2">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</div>
					</td>
					<td>
						<button type="button" class="btn btn-outline-secondary btn-sm mb-2" onclick="deleteTheaters()">선택극장 삭제</button>
					<td style="width:20%">
						<%-- 
						<select class="form-control mb-2" id="orderBy">
							<option value="name" <c:if test="${orderBy=='name'}">selected</c:if>>이름순</option>
							<option value="address" <c:if test="${orderBy=='address'}">selected</c:if>>지역별</option>
						</select>
						 --%>
					</td>
					<td>
						<select id="pageSize" class="form-control mb-2">
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5건씩 보기</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10건씩 보기</option>
							<option value="20" <c:if test="${pagingVO.pageSize==20}">selected</c:if>>20건씩 보기</option>
						</select>
					</td>
					<td style="width:33%">
						<div class="input-group mb-2">
						    <input type="text" class="form-control" id="keyWord" placeholder="극장명, 주소 검색">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
						    </div>
						</div>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr>
					<th>선택</th>
					<th>극장이름</th>
					<th>주소</th>
					<th>상세주소</th>
					<th style="width:10%">수정/삭제</th>
				</tr>
				<c:forEach items="${vos}" var="vo">
					<tr>
						<td><input type="checkbox" value="${vo.idx}" name="selectedIdx"/></td>
						<td>${vo.name}</td>
						<td>${vo.address1}</td>
						<td id="address2_${vo.idx}">${vo.address2 }</td>
						<td>
							<span id="correctionBtn${vo.idx}">
								<button type="button" class="btn btn-secondary btn-sm" onclick="correction(${vo.idx})">수정</button>
							</span>
							<button type="button" class="btn btn-secondary btn-sm" onclick="deleteTheater(${vo.idx})">삭제</button>
						</td>
					</tr>
				</c:forEach>
			</table>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>