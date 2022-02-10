<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/review/reportedReview"/>
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
	#tableHeader td{padding-bottom: 0;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$("button").addClass("btn btn-outline-danger btn-sm mb-1")
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
		
	function show(idx) {
		$(".det"+idx).toggle(0);
		$(".sum"+idx).toggle(0);
	}
	
	function warn(num) {
		// 1: 신고자
		// 2: 작성자
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val().split('/')[num]);
		});
		if(selected.length==0) {
			alert("선택한 신고리뷰가 없습니다. ");
			return false;
		}
		if(!confirm("경고가 누적되면 회원 활동에 제약이 있습니다. 선택한 회원을 경고하시겠습니까?")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {nick : selected[i]}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/member/addWarn", 
				data: query 
			});
		}
		alert("선택한 회원을 경고했습니다. ");
	}
	
	//리뷰 내용 숨기기
	function hideContent() {
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val().split('/')[0]);
		});
		if(selected.length==0) {
			alert("선택한 신고리뷰가 없습니다. ");
			return false;
		}
		if(!confirm("선택한 리뷰의 내용을 숨기시겠습니까?")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {idx : selected[i]}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/review/hideContent", 
				data: query 
			});
		}
		alert("선택한 글 내용을 숨겼습니다. ");
	}
	
	// 신고 삭제 
	function deleteReport() {
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val().split('/')[3]);
		});
		if(selected.length==0) {
			alert("선택한 신고리뷰가 없습니다. ");
			return false;
		}
		if(!confirm("선택한 신고사항을 삭제하시겠습니까?")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {idx : selected[i]}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/review/deleteReport", 
				data: query 
			});
		}
		alert("선택한 신고사항을 삭제했습니다. ");
		location.href = "${ctp}/${linkpath}";
	}
	

	// 새 창에 회원정보
	function newWin(nick) {
		url = "${ctp}/admin/member/memberDetail?nick="+nick;
		window.open(url, "newWin", "width=600px, height=700px");
	}
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container-fluid p-3">
			<h3>&lt;신고리뷰관리&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td style="width:12%; min-width: 140px;" >
						<div class="custom-control custom-checkbox">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</div>
					</td>
					<td style="width:33%">
						<button type="button" onclick="warn(2)">작성자 경고</button>
						<button type="button" onclick="warn(1)">신고자 경고</button>
						<button type="button" onclick="hideContent()">리뷰 내용 숨기기</button>
						<button type="button" onclick="deleteReport()">신고 삭제</button>
					</td>
					<td style="width:25%">
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
							<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>작성일순</option>
							<option value="reporterNick" <c:if test="${orderBy=='reporterNick'}">selected</c:if>>신고회원</option>
							<option value="reviewIdx" <c:if test="${orderBy=='reviewIdx'}">selected</c:if>>리뷰별</option>
						</select>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr>
					<th>선택</th>
					<th style="min-width: 90px;">신고자</th>
					<th style="min-width: 130px;">작성자</th>
					<th>별점</th>
					<th>리뷰내용</th>
					<th style="min-width: 200px;">작성일</th>
					<th>신고사유</th>
					<th style="min-width: 200px;">신고일</th>
				</tr>
				<c:forEach var="vo" items="${vos}" varStatus="st">
					<tr >
						<td><input type="checkbox" name="selectedIdx" value="${reviewVos[st.index].idx}/${vo.reporterNick}/${reviewVos[st.index].nick}/${vo.idx}"></td>
						<%-- <td>${vo.reporterNick}</td> --%>
						<td style="font-weight: 600;text-align: center;">
							<c:if test="${empty vo.reporterNick}">(알 수 없음)</c:if> 
							<a href="javascript:newWin('${vo.reporterNick}')">${vo.reporterNick}</a>
						</td>
						
						<td style="font-weight: 600;text-align: center;">
							<c:if test="${empty reviewVos[st.index].nick}">(알 수 없음)</c:if>
							<a href="javascript:newWin('${reviewVos[st.index].nick}')">${reviewVos[st.index].nick}</a>
						</td>
						<td>${reviewVos[st.index].star}</td>
						<td style="width:28%;" class="summary sum${vo.idx}" onclick="show(${vo.idx})">
							<c:if test="${fn:contains(reviewVos[st.index].reviewContent, '@@WARN')}">
								<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
							</c:if>
							<c:if test="${not fn:contains(reviewVos[st.index].reviewContent, '@@WARN')}">
								${fn:substring(reviewVos[st.index].reviewContent, 0, 25)}
								<c:if test="${fn:length(reviewVos[st.index].reviewContent)>25}">...</c:if>
							</c:if>
						</td>
						<td style="width:28%;" class="detail det${vo.idx}" onclick="show(${vo.idx})">
							<c:if test="${fn:contains(reviewVos[st.index].reviewContent, '@@WARN')}">
								<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
							</c:if>
							<c:if test="${not fn:contains(reviewVos[st.index].reviewContent, '@@WARN')}">
								${reviewVos[st.index].reviewContent}
							</c:if>
						</td>
						<td>${reviewVos[st.index].WDate}</td>
						<td style="width:20%;" class="summary sum${vo.idx}" onclick="show(${vo.idx})">
							${fn:substring(vo.reason, 0, 12)}
							<c:if test="${fn:length(vo.reason)>12}">...</c:if>
						</td>
						<td style="width:17%;" class="detail det${vo.idx}" onclick="show(${vo.idx})">
							${vo.reason}
						</td>
						<td>${vo.RDate}</td>
					</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/review/reportedReview"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>		
		</div>
	</section>
</body>
</html>