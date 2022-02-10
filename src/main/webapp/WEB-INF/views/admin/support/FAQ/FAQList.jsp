<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/support/FAQ/FAQList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">

<style type="text/css">
	th, td {text-align: center;}
</style>
<script type="text/javascript">
	$(function() {
		$(".detail").toggle(0);
		$("#orderBy").on("change", function() {
			var link = "${ctp}/${linkpath}?orderBy="+$(this).val()+"&pag=1&pageSize=${pagingVO.pageSize}";
			location.href = link;
		});
		$("#pageSize").on("change", function() {
			var link = "${ctp}/${linkpath}?orderBy=${orderBy}&pag=1&pageSize="+$(this).val();
			location.href = link;
		});
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
	function showDetail(idx) {
		$("#content"+idx).toggle(0);
	}
	function newFAQ() {
		url = "${ctp}/admin/support/FAQ/newFAQ";
		window.open(url, "nWin", "width=600px, height=500px, location=no");
	}
	
	function updateFAQ(idx) {
		url = "${ctp}/admin/support/FAQ/updateFAQ?idx="+idx;
		window.open(url, "nWin", "width=500px, height=500px");
	}
	function deleteFAQ(idx) {
		var ans = confirm("선택하신 FAQ를 삭제하시겠습니까?");
		if(ans){
			$.ajax({
				type:"post", 
				url: "${ctp}/admin/support/FAQ/deleteFAQ", 
				data: {idx:idx}, 
				success: function() {
					alert("삭제했습니다. ");
					location.href= "${ctp}/${linkpath}?keyWord=${keyWord}&orderBy=${orderBy}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
				}
			});
		}
	}
	function deleteFAQs() {
		var ans = confirm("선택하신  FAQ를 삭제하시겠습니까?");
		if(!ans) return false;
		
		var selectedIdx = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			selectedIdx.push($(this).val());
		});
		if(!confirm(selectedIdx)) return false;
		for(var i=0; i<selectedIdx.length;i++) {
			
			$.ajax({
				type:"post", 
				url: "${ctp}/admin/support/FAQ/deleteFAQ", 
				data: {idx:selectedIdx[i]}, 
				success: function() {
					location.href= "${ctp}/${linkpath}?keyWord=${keyWord}&orderBy=${orderBy}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
				}
			});
		}
		alert("삭제했습니다. ");
	}
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>
	<section>
		<div class="container-fluid p-3">
			<h3>&lt;FAQ&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td style="width:12%; min-width: 140px;" >
						<div class="custom-control custom-checkbox">
						    <input type="checkbox" id="selectAll" value="0"/>
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</div>
					</td>
					<td style="width:15%">
						<button type="button" onclick="deleteFAQs()" class="btn btn-secondary btn-sm">삭제</button>
					</td>
					<td style="width:10%">
						<select class="form-control" id="pageSize">
							<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2줄</option>
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5줄</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10줄</option>
						</select>
					</td>
					<td style="width:20%">
						<select class="form-control" id="orderBy">
							<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>기본</option>
							<option value="grammer" <c:if test="${orderBy=='grammer'}">selected</c:if>>ㄱㄴㄷ순</option>
							<option value="views" <c:if test="${orderBy=='views'}">selected</c:if>>조회수순</option>
						</select>
					</td>
					<td style="width:33%">
						<div class="input-group mb-3">
						    <input type="text" class="form-control" id="keyWord" placeholder="제목, 내용 검색가능">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
						    </div>
						</div>
					</td>
					<td style="width:10%">
						<button type="button" class="btn btn-danger" onclick="newFAQ()">FAQ 등록</button>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr class="table-danger">
					<th style="width:10%">선택</th>
					<th style="width:10%">번호</th>
					<th style="width:50%">질문</th>
					<th style="width:10%">조회수</th>
					<th style="width:20%">수정/삭제</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
				<tr>
					<td><input type="checkbox" id="${vo.idx}" value="${vo.idx}" name="selectedIdx"/></td>
					<td>${vo.idx}</td>
					<td onclick="showDetail(${vo.idx})">${vo.question}</td>
					<td>${vo.views }</td>
					<td>
						<button type="button" onclick="updateFAQ(${vo.idx})" class="btn btn-outline-danger">수정</button>
						<button type="button" onclick="deleteFAQ(${vo.idx})" class="btn btn-outline-danger">삭제</button>
					</td>
				</tr>
				<tr id="content${vo.idx}" class="detail"><td></td><td>답변</td><td>${vo.answer}</td><td></td><td></td></tr>
				</c:forEach>
			</table>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>