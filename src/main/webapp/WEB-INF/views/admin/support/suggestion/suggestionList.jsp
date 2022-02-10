<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/support/suggestion/suggestionList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<script type="text/javascript">
	$(document).ready(function() {
		$(".detail").toggle(0);
		$('#lost_mask').css({'width':'0','height':'0'});
		$("#condition").on("change", function() {
			var link = "${ctp}/${linkpath}?condition="+$(this).val()+"&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
			location.href = link;
		});
		$("#pageSize").on("change", function() {
			var link = "${ctp}/${linkpath}?condition=${condition}&pag=${pagingVO.pag}&pageSize="+$(this).val();
			location.href = link;
		});
	});
	
	function show(idx) {$("."+idx).toggle(100);}
	
	function changeCondition(idx) {
		var ans = confirm("건의사항 처리상태를 바꾸시겠습니까?");
		if(!ans) {
			var link = "${ctp}/${linkpath}?condition=${condition}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
			location.href = link;			
			return false;
		}
		var condition = $("#cngCondition"+idx).val();
		var query = {
				idx : idx, 
				condition : condition
		}
		$.ajax({
			type: "post", 
			url : "${ctp}/admin/support/suggestion/changeCondition", 
			data : query
		});
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
			<h3>&lt;건의사항&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td style="width:37%"></td>
					<td style="width:10%">
						<select class="form-control" id="pageSize">
							<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2줄</option>
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5줄</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10줄</option>
						</select>
					</td>
					<td style="width:20%">
						<select class="form-control" id="condition">
							<option value="4" <c:if test="${condition==4}">selected</c:if>>전체</option>
							<option value="0" <c:if test="${condition==0}">selected</c:if>>미확인</option>
							<option value="1" <c:if test="${condition==1}">selected</c:if>>보류</option>
							<option value="2" <c:if test="${condition==2}">selected</c:if>>승인</option>
							<option value="3" <c:if test="${condition==3}">selected</c:if>>처리완료</option>
							<option value="-1" <c:if test="${condition==-1}">selected</c:if>>기각</option>
						</select>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr class="table-danger">
					<th style="width:8%">상태</th>
					<th style="width:8%">작성자</th>
					<th>제목</th>
					<th style="width:18%">작성일</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td>
							<select onchange="changeCondition(${vo.idx})" id="cngCondition${vo.idx}">
								<option value="4" <c:if test="${vo._condition==4}">selected</c:if>>전체</option>
								<option value="0" <c:if test="${vo._condition==0}">selected</c:if>>미확인</option>
								<option value="1" <c:if test="${vo._condition==1}">selected</c:if>>보류</option>
								<option value="2" <c:if test="${vo._condition==2}">selected</c:if>>승인</option>
								<option value="3" <c:if test="${vo._condition==3}">selected</c:if>>처리완료</option>
							   <option value="-1" <c:if test="${vo._condition==-1}">selected</c:if>>기각</option>
							</select>
						</td>
						<td style="font-weight: 600;text-align: center;">
							<c:if test="${empty vo.nick}">(알 수 없음)</c:if>
							<a href="javascript:newWin('${vo.nick}')">${vo.nick}</a>
						</td>
						<td onclick="show(${vo.idx})">${vo.title}</td>
						<td>${fn:substring(vo.WDate, 0, 16)}</td>
					</tr>
					<tr class="detail ${vo.idx}"><td></td><td></td><td colspan="2">${vo.content}</td></tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/support/suggestion/suggestionList"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>