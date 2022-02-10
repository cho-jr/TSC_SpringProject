<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/support/qna/qnaList"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자메뉴-1:1문의</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<style type="text/css">
	th { text-align: center;}
	#tableHeader td{padding:0 5px;}
</style>
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
	
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&condition=${condition}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
		location.href = link;
	}
	
	function registAnswer(idx){
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		
		var answer = $("#answer"+idx).val();
		var query= {
				idx : idx, 
				answer : answer
		}
		var date = new Date();
		var today = date.getFullYear() +'-'+date.getMonth()+1 +'-'+date.getDate();
		$.ajax({
			type : "post", 
			url : "${ctp}/admin/support/qna/registAnswer", 
			data : query, 
			success : function() {
				$("#answerRow"+idx).html('<td></td><td style="text-align: right;">답변</td><td>'+answer.replace(/\n+/g, '<br/>')+'</td><td style="text-align: center;">'+today+'</td>');
				$('#lost_mask').css({'width':'0','height':'0'});
			}
		});
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
		<div class="container-fluid p-3">
			<h3>&lt;1:1문의 내역&gt;</h3>
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
							<option value="all" <c:if test="${condition=='all'}">selected</c:if>>전체</option>
							<option value="noAnswer" <c:if test="${condition=='noAnswer'}">selected</c:if>>미답변</option>
							<option value="answer" <c:if test="${condition=='answer'}">selected</c:if>>답변완료</option>
						</select>
					</td>
					<td style="width:33%">
						<div class="input-group mb-3">
						    <input type="text" class="form-control" id="keyWord" placeholder="제목, 내용, 답변, 회원명 검색가능">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
						    </div>
						</div>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr>
					<th style="width:15%">회원명</th>
					<th style="width:15%">처리현황</th>
					<th>질문</th>
					<th style="width:15%">작성일</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td>${vo.nick}</td>
						<td style="text-align: center;">
							<c:if test="${empty vo.answer}">문의 접수</c:if>
							<c:if test="${!empty vo.answer}">답변 완료</c:if>
						</td>
						<td class="pl-4"><b><a href="javascript:show(${vo.idx});"><c:out value="${vo.title}"/></a></b></td>
						<td style="text-align: center;"><c:out value="${fn:substring(vo.WDate, 0, 10)}"/></td>
					</tr>
					<tr class="detail ${vo.idx}" >
						<td></td>
						<td style="text-align: right;">질문</td>
						<td>${vo.content}</td>
						<td></td>
					</tr>
					<tr class="detail ${vo.idx}" id="answerRow${vo.idx}">
						<td></td>
						<td style="text-align: right;">답변</td>
					<c:if test="${empty vo.answer}">
						<td>
							<textarea rows="3" class="form-control" placeholder="답변을 입력해주세요" id="answer${vo.idx}">
안녕하십니까? 저희 서비스를 이용해주셔서 감사합니다. 

감사합니다. 좋은 하루 보내십시오.
							</textarea>
							<button style="float:right;"class="btn btn-sm btn-danger" onclick="registAnswer(${vo.idx})">답변등록</button>
						</td>
						<td></td>
					</c:if>
					<c:if test="${!empty vo.answer}">
						<td>${fn:replace(vo.answer, newLine, '<br/>')}</td><td style="text-align: center;">${fn:substring(vo.ADate, 0, 10)}</td>
					</c:if>
					</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/support/qna/qnaList"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>