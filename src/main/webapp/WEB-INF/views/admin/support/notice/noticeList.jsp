<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/support/notice/noticeList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">

<style type="text/css">
#tableHeader td{padding:1px;}
	th, td {text-align: center;}
</style>
<script type="text/javascript">
	$(function() {
		$("img").attr("style", "width:100%");
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
	function newNotice() {
		url = "${ctp}/admin/support/notice/newNotice";
		window.open(url, "nWin", "width=500px, height=500px, location=no");
	}
	
	function updateNotice(idx) {
		url = "${ctp}/admin/support/notice/updateNotice?idx="+idx;
		window.open(url, "nWin", "width=500px, height=500px");
	}
	function deleteNotice(idx) {
		var ans = confirm("???????????? ????????? ?????????????????????????");
		if(ans){
			$.ajax({
				type:"post", 
				url: "${ctp}/admin/support/notice/deleteNotice", 
				data: {idx:idx}, 
				success: function() {
					alert("??????????????????. ");
					location.href= "${ctp}/${linkpath}?keyWord=${keyWord}&orderBy=${orderBy}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
				}
			});
		}
	}
	function changeImportant0() {
		var selected = [];
		$("input:checkbox[name=selectedIdx]:checked").each(function() {
			selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("????????? ??????????????? ????????????. ");
			return false;
		}
		
		var ans = confirm("???????????? ??????????????? ?????? ????????? ?????????????????????? ?????? ????????? ????????? ???????????? ????????????. ");
		if(!ans) return false;
		for(let i=0; i<selected.length; i++) {
			$.ajax({
				type: "post", 
				url: "${ctp}/admin/support/notice/updateNoticeImportant",
				data: {idx : selected[i]}
			});
		}
		location.href="${ctp}/${linkpath}";
	}
	
	// ????????? ??????
	function changeImportantpm(idx, pm) {
		var query = {
				idx : idx, 
				pm : pm
		}	
		$.ajax({
			type:"post", 
			url: "${ctp}/admin/support/notice/changeImportant", 
			data : query,
			success: function() {
				location.href='${ctp}/admin/support/notice/noticeList';
			}
		});
	}
	
	/* function mainNotice(idx) {
		var ans = confirm("?????? ????????? ????????? ?????? ???????????????. ?????? ????????? ?????????????????????????");
		if(!ans) return false;
		$.ajax({
			type:"post", 
			url: "${ctp}/admin/support/notice/setPopupNotice", 
			data : query,
			success: function() {
				alert("?????????????????????. ")
				location.href='${ctp}/admin/support/notice/noticeList';
			}
		});
	} */
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>????????? ??????</h2></header>
	<section style="width:1250px;">
		<div class="container-fluid p-3">
			<h3>&lt;????????????&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td style="width:12%; min-width: 80px;" >
						<div class="custom-control custom-checkbox">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>????????????</b></label>
						</div>
					</td>
					<td style="width:20%">
						<button type="button" onclick="deleteReview()" class="btn btn-secondary btn-sm">??????</button>
						<button type="button" onclick="changeImportant0()" class="btn btn-secondary btn-sm">??????????????? ??????</button>
					</td>
					<td style="width:10%">
						<select class="form-control" id="pageSize">
							<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2???</option>
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5???</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10???</option>
						</select>
					</td>
					<td style="width:17%">
						<select class="form-control" id="orderBy">
							<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>????????????</option>
							<option value="important" <c:if test="${orderBy=='important'}">selected</c:if>>????????????(??????????????????)</option>
						</select>
					</td>
					<td style="width:30%">
						<div class="input-group mb-3">
						    <input type="text" class="form-control" id="keyWord" placeholder="??????, ?????? ????????????">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">??????</button>
						    </div>
						</div>
					</td>
					<td style="width:12%">
						<button type="button" class="btn btn-danger" onclick="newNotice()">????????????</button>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr class="table-danger">
					<th style="width:7%">??????</th>
					<th style="width:7%">??????</th>
					<th style="width:41%">??????</th>
					<th style="width:16%">?????????</th>
					<th style="width:7%">?????????</th>
					<th style="width:7%">??????</th>
					<th style="width:15%">??????/??????</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
				<tr>
					<td><input type="checkbox" id="${vo.idx}" name="selectedIdx" value="${vo.idx}"/></td>
					<td ondblclick="mainNotice(${vo.idx})">${vo.idx}</td>
					<td onclick="showDetail(${vo.idx})">${vo.title }</td>
					<td>${fn:substring(vo.WDate, 0, 10)}</td>
					<td>${vo.views }</td>
					<td>
						<span class="badge badge-secondary" style="cursor:pointer" onclick="changeImportantpm(${vo.idx}, 'minus')">-</span>
						&nbsp;${vo.important}&nbsp;
						<span class="badge badge-secondary" style="cursor:pointer" onclick="changeImportantpm(${vo.idx}, 'plus')">+</span>
					</td>
					<td>
						<button type="button" onclick="updateNotice(${vo.idx})" class="btn btn-outline-danger">??????</button>
						<button type="button" onclick="deleteNotice(${vo.idx})" class="btn btn-outline-danger">??????</button>
					</td>
				</tr>
				<tr id="content${vo.idx}" class="detail"><td></td><td>??????</td><td class="text-left">${vo.content}<td><td></td><td></td></tr>
				</c:forEach>
			</table>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>