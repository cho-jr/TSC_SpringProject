<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/review/reviewList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<style>
	.hoverShow {visibility: hidden;}
	tr:hover .hoverShow {visibility: visible;}
	#tableHeader td{padding-bottom: 0;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$(".detail").toggle(0);
		// $('#lost_mask').css({'width':'0','height':'0'});
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
	
	function show(idx) {
		$(".det"+idx).toggle(0);
		$(".sum"+idx).toggle(0);
	}
	
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}";
		location.href = link;
	}
	
	function report() {
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("????????? ????????? ????????????. ");
			return false;
		}
		if(!confirm("????????? ????????? ?????????????????????????")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {
					reviewIdx : selected[i], 
					reporterNick : "${sNick}"
			}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/review/reportReview", 
				data: query 
			});
		}
		alert("????????? ????????? ??????????????????. ");
	}
	
	function deleteReview() {
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("????????? ????????? ????????????. ");
			return false;
		}
		if(!confirm("????????? ????????? ?????????????????????????")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {
					idx : selected[i] 
			}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/review/deleteReview", 
				data: query
			});
		}
		alert("????????? ????????? ??????????????????. ");
		location.href="${ctp}/admin/review/reviewList";
	}
	

	// ??? ?????? ????????????
	function newWin(nick) {
		url = "${ctp}/admin/member/memberDetail?nick="+nick;
		window.open(url, "newWin", "width=600px, height=700px");
	}
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>????????? ??????</h2></header>

	<section>
		<div class="container-fluid p-3">
			<h3>&lt;?????? ??????&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td style="width:12%; min-width: 140px;" >
						<div class="custom-control custom-checkbox">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>????????????</b></label>
						</div>
					</td>
					<td style="width:25%">
						<button type="button" onclick="report()" class="btn btn-secondary btn-sm">??????</button>
						<button type="button" onclick="deleteReview()" class="btn btn-secondary btn-sm">??????</button>
					</td>
					<td style="width:10%">
						<select class="form-control" id="pageSize">
							<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2???</option>
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5???</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10???</option>
						</select>
					</td>
					<td style="width:20%">
						<select class="form-control" id="orderBy">
							<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>????????????</option>
							<option value="star" <c:if test="${orderBy=='star'}">selected</c:if>>?????????</option>
							<option value="nick" <c:if test="${orderBy=='nick'}">selected</c:if>>?????????</option>
							<option value="performIdx" <c:if test="${orderBy=='performIdx'}">selected</c:if>>?????????</option>
						</select>
					</td>
					<td style="width:33%">
						<div class="input-group mb-3">
						    <input type="text" class="form-control" id="keyWord" placeholder="?????????, ?????? ????????????">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">??????</button>
						    </div>
						</div>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr>
					<th>??????</th>
					<th>?????????</th>
					<th>????????????</th>
					<th>??????</th>
					<th>????????????</th>
					<th>?????????</th>
					<th>????????????</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr >
						<td><input type="checkbox" name="selectedIdx" value="${vo.idx}"></td>
						<td style="font-weight: 600;text-align: center;"><c:if test="${empty vo.nick}">(??? ??? ??????)</c:if><a href="javascript:newWin('${vo.nick}')">${vo.nick}</a></td>
						<%-- <td><c:if test="${empty vo.nick}"><span style="color:#777;">(??? ??? ??????)</span></c:if>${vo.nick}</td> --%>
						<td>${vo.performIdx}</td>
						<td>${vo.star}</td>
						<td style="width:50%;" class="summary sum${vo.idx}" onclick="show(${vo.idx})">
							<c:if test="${fn:contains(vo.reviewContent, '@@WARN')}">
								<span style="color:#777">???????????? ?????? ????????? ????????????. </span>
							</c:if>
							<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
								${fn:substring(vo.reviewContent, 0, 40)}
								<c:if test="${fn:length(vo.reviewContent)>40}">...</c:if>
							</c:if>
						</td>
						<td style="width:50%;" class="detail det${vo.idx}" onclick="show(${vo.idx})">
							<c:if test="${fn:contains(vo.reviewContent, '@@WARN')}">
								<span style="color:#777">???????????? ?????? ????????? ????????????. </span>
							</c:if>
							<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
								${vo.reviewContent}
							</c:if>
						</td>
						<td>${vo.WDate}</td>
						<td><a href="${ctp}/perform/performInfo?idx=${vo.performIdx}" target="_blank" class="btn btn-outline-danger hoverShow">?????? ??????</a></td>
					</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/review/reviewList"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>