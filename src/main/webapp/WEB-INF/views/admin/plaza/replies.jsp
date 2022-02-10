<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="linkpath" value="admin/plaza/replies"/>
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
	.boardLink:hover{text-decoration: underline;}
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
		$("#pageSize").on("change", function() {
			var link = "${ctp}/${linkpath}?condition=${condition}&orderBy=${orderBy}&pageSize="+$(this).val()+"&keyWord=${keyWord}";
			location.href = link;
		});
	});

	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&condition=${condition}&orderBy=${orderBy}&pageSize=${pagingVO.pageSize}";
		location.href = link;
	}
	
	function sendMailForm(nick){
		// ajax로 email 가져와서 
		$.ajax({
			type:"post", 
			url : "${ctp}/admin/plaza/getEmail", 
			data : {nick : nick}, 
			success : function(data){
				var regexEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
				if (!regexEmail.test(data)) {
					alert("이메일 주소가 잘못되어 메일을 보낼 수 없습니다. ");
				} else {
					myform.to.value = data;
					$("#myModal").modal();
				}
			}
		});
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
	
	// 댓글 삭제
	function deleteReply(idx){
		console.log(idx);
		var ans = confirm("댓글을 삭제하시겠습니까?");
		if(!ans) return false;
		
		$.ajax({
			type : "post", 
			url : "${ctp}/admin/plaza/deleteReply",
			data : {idx : idx}, 
			success : function() {
				alert("삭제 되었습니다. ");
				location.href="${ctp}/${linkpath}?pag=${pagingVO.pag}&keyWord=${keyWord}&pageSize=${pagingVO.pageSize}";
			}
		});
	}
	
	function deleteReplies(){
		if($('input:checkbox[type=checkbox]:checked').length<=0) {
			alert("선택한 댓글이 없습니다. ");
			return false;
		}
		var selected = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			selected.push($(this).val());
		});
		
		var ans = confirm("선택한 댓글을 모두 삭제하시겠습니까?");
		if(!ans) return false;
		for(let i=0; i<selected.length; i++) {
			$.ajax({
				type : "post", 
				data : {idx : selected[i]}, 
				url : "${ctp}/admin/plaza/deleteReply"
			});			
		}
		alert("삭제 되었습니다. ");
		location.href="${ctp}/${linkpath}?pag=${pagingVO.pag}&keyWord=${keyWord}&pageSize=${pagingVO.pageSize}";
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
			<h3>&lt;댓글 조회&gt;</h3>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td>
						<div class="custom-control custom-checkbox mb-2">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</div>
					</td>
					<td style="width:15%">
						
					</td>
					<td style="width:12%">
					</td>
					<td style="width:16%">
						<button class="btn btn-secondary btn-sm" onclick="deleteReplies()">삭제</button>
						<button class="btn btn-danger btn-sm" onclick="location.href='${ctp}/${linkpath}'">전체보기</button>
					</td>
					<td style="width:9%">
						<select class="form-control" id="pageSize">
							<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2줄</option>
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5줄</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10줄</option>
						</select>
					</td>
					<td style="width:33%">
						<div class="input-group">
						    <input type="text" class="form-control" value="${keyWord}" id="keyWord" placeholder="검색">
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
						<th style="min-width: 50px;">선택</th>
						<th style="min-width: 50px;">idx</th>
						<th style="min-width: 80px;">게시글</th>
						<th style="min-width: 80px;">작성자</th>
						<th>내용</th>
						<th style="width:140px;">작성일</th>
						<th>삭제</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${vos}">
						<tr>
							<td><input type="checkbox" value="${vo.idx}" name="selectedIdx"></td>
							<td>${vo.idx}</td>
							<td><a class="boardLink" href="${ctp}/plaza/freeBoardDetail?idx=${vo.boardIdx}" target="_blank">게시글</a></td>
							<td ondblclick="sendMailForm('${vo.nick}')">${vo.nick}</td>
							
							<td>${vo.content }</td>
							<td>${fn:substring(vo.WDate,0,10)}</td>
							<td class="p-0">
								<div class="hoverShow">
									<button type="button" class="btn btn-outline-secondary btn-sm" onclick="deleteReply(${vo.idx})">삭제</button>
								</div>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<c:set var="linkpath" value="admin/plaza/replies"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
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
					<form name="myform" method="post" action="${ctp}/admin/plaza/sendMail">
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