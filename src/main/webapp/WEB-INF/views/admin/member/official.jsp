<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/member/official"/>
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
	
	// 회원 경고
	function warnMember() {
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("선택한 회원이 없습니다. ");
			return false;
		}
		
		if(!confirm("경고가 누적되면 회원 활동에 제약이 있습니다. 선택한 회원을 경고하시겠습니까?")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {
					nick : selected[i]
			}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/member/addWarn", 
				data: query, 
				success : function() {
					location.href="${ctp}/${linkpath}";
				}
			});
		}
		alert("선택한 회원을 경고했습니다. ");
	}
	
	// 상세보기
	function officialDetail(nick) {
		url = "${ctp}/admin/member/officialDetail?nick="+nick;
		window.open(url, "newWin", "width=500px, height=600px");
	}
	
	function deleteApply() {
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("선택한 항목이 없습니다. ");
			return false;
		}
		
		if(!confirm("신청자에게 통보 없이 신청 내역이 삭제됩니다. 삭제하시겠습니까?")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {
					nick : selected[i]
			}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/member/deleteOfficialApply", 
				data: query, 
				success : function() {
					location.href="${ctp}/${linkpath}";
				}
			});
		}
		alert("신청 내역을 삭제했습니다. ");
	}
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container-fluid p-3">
			<h3>&lt;관계자 신규신청/등록&gt;</h3>
			<table style="width:100%">
				<tr>
					<td>
						<div class="custom-control custom-checkbox">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</div>
					</td>
					<td class="text-right">
						선택한 회원 : 
						<button class="btn btn-secondary btn-sm m-1" onclick="warnMember()">경고</button>
						<button class="btn btn-secondary btn-sm m-1" onclick="deleteApply()">신청삭제</button>							
					</td>
				</tr>
			</table>
		    
		    <table class="table table-hover">
				<tr>
					<th>선택</th>
					<th>닉네임</th>
					<th>사업자명</th>
					<th>정산계좌</th>
					<th>사업자번호</th>
					<th>상세보기</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td>
							<input type="checkbox" name="selectedIdx" id="${vo.nick}" value="${vo.nick}">
						</td>
						<td>${vo.nick}</td>
						<td>${vo.BName}</td>
						<td>${vo.bank} ${vo.accountHolder} ${vo.accountNum}</td>
						<td>${vo.BNumber}</td>
						<td><button type="button" class="btn btn-sm btn-outline-danger hoverShow" onclick="officialDetail('${vo.nick}')">상세보기</button></td><!-- 새창 팝업 -->
					</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/member/official"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>