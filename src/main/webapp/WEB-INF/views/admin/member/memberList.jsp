<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
</style>
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
		
		$("select[name=orderBy]").on("change", function() {
			location.href="${ctp}/admin/member/memberList?orderBy="+$(this).val();
		});
	});
	
	function changeLevel(level) {
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("선택한 회원이 없습니다. ");
			return false;
		}
		for(let i=0; i< selected.length; i++) {
			var query = {
					nick : selected[i], 
					level : level
			}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/member/changeLevel", 
				data: query, 
				success : function() {
					location.href="${ctp}/admin/member/memberList";
				}
			});
		}
		alert("선택한 회원의 등급을 변경했습니다. ");
	}
	
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
					location.href="${ctp}/admin/member/memberList";
				}
			});
		}
		alert("선택한 회원을 경고했습니다. ");
	}
	
	// 회원 완전탈퇴
	function GoodBye(){
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("선택한 회원이 없습니다. ");
			return false;
		}
		
		if(!confirm("탈퇴하시면 로그인 불가하며 로그인 필요한 서비스를 이용할 수 없습니다. \n탈퇴시 복구 불가합니다. 탈퇴처리하시겠습니까?")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {
					nick : selected[i], 
			}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/member/goodByeMember", 
				data: query
			});
		}
		alert("선택한 회원을 탈퇴처리했습니다. ");
		location.href="${ctp}/admin/member/memberList";
	}
	
	// 회원 완전탈퇴
	function ByeBye(){
		var selected = [];
		$('input[name=selectedIdx]:checked').each(function () {
		    selected.push($(this).val());
		});
		if(selected.length==0) {
			alert("선택한 회원이 없습니다. ");
			return false;
		}
		
		if(!confirm("완전탈퇴하시면 모든 회원 정보가 지워집니다. 완전탈퇴처리하시겠습니까?")) return false;
		for(let i=0; i< selected.length; i++) {
			var query = {
					nick : selected[i], 
			}
			$.ajax({
				type:"post", 
				url:"${ctp}/admin/member/deleteMember", 
				data: query
			});
		}
		alert("선택한 회원 정보를 완전히 삭제했습니다. ");
		location.href="${ctp}/admin/member/memberList";
	}
	
	// 상세보기
	function memberDetail(nick) {
		url = "${ctp}/admin/member/memberDetail?nick="+nick;
		window.open(url, "memberInfoWin", "width=500px, height=600px");
	}
	
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>
	<section>
		<div class="container-fluid p-3">
			<h3>&lt;회원 목록&gt;</h3>
			<!-- 선택한 회원 등급 변경, 탈퇴, 경고 누적 --><!-- 최근 접속일 1년이상 지난 회원 휴면회원 전환버튼 -->
			<form method="get" action="${ctp}/admin/member/memberList">
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
							<button class="btn btn-secondary btn-sm m-1 dropdown-toggle" data-toggle="dropdown">등급변경</button>
							<div class="dropdown-menu">
						        <a class="dropdown-item" href="javascript:changeLevel(0)">일반회원</a>
						        <a class="dropdown-item" href="javascript:changeLevel(1)">관계자</a>
						    </div>
							<button class="btn btn-secondary btn-sm m-1" onclick="GoodBye()">탈퇴</button>
							<button class="btn btn-secondary btn-sm m-1" onclick="ByeBye()">완전탈퇴</button>
							<button class="btn btn-secondary btn-sm m-1" onclick="warnMember()">경고</button>
						</td>
						<td style="width:20%">
							<select name="orderBy" class="form-control" id="orderBy">
								<option value="joinDate" <c:if test="${orderBy=='joinDate'}">selected</c:if>>가입일순</option>
								<option value="level" <c:if test="${orderBy=='level'}">selected</c:if>>등급 높은순</option>
								<option value="lastDate" <c:if test="${orderBy=='lastDate'}">selected</c:if>>마지막접속일순</option>
								<option value="warn" <c:if test="${orderBy=='warn'}">selected</c:if>>경고많은순</option>
							</select>
						</td>
						<td style="width:25%">
							<div class="input-group">
							    <input type="search" class="form-control" placeholder="검색" name="keyWord">
							    <div class="input-group-append">
							    	<button class="btn btn-danger" type="submit">검색</button>
							    </div>
							</div>
						</td>
					</tr>
				</table>
		    </form>
			
			<table class="table table-hover">
				<tr>
					<th>선택</th>
					<th>닉네임</th>
					<th>이름</th>
					<th>회원등급</th>
					<th>최근접속일</th>
					<th>포인트</th>
					<th>경고누적</th>
					<th>상세보기</th><!-- 이메일, phone, 주소 팝업에 띄우기, 메일 보내기 -->
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td>
							<input type="checkbox" name="selectedIdx" id="${vo.nick}" value="${vo.nick}">
						</td>
						<td>${vo.nick}</td>
						<td>${vo.name}</td>
						<td>
							<c:choose>
								<c:when test="${vo.level==-1}">탈퇴</c:when>
								<c:when test="${vo.level==0}">일반</c:when>
								<c:when test="${vo.level==1}">관계자</c:when>
								<c:when test="${vo.level==2}">관리자</c:when>
							</c:choose>
						</td>
						<td>${vo.lastDate}</td>
						<td>${vo.point}</td>
						<td>${vo.warn}</td>
						<td><button type="button" class="btn btn-sm btn-outline-danger hoverShow" onclick="memberDetail('${vo.nick}')">상세보기</button></td><!-- 새창 팝업 -->
					</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/member/memberList"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>