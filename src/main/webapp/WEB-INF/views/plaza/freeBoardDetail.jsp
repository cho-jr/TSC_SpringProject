<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="plaza/freeBoardDetail"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style>
	th{text-align: center;}
	tr td:nth-child(n+3){text-align: right;}
</style>
<script type="text/javascript">
	var nick = '';
	$(document).ready(function() {
		nick = '${sNick}';
		$(".rereplyform").toggle(0);
		$(".hide").toggle(0);
		$("img").attr("style", "max-width:100%");
		$(".footAdv").attr("style", "max-width:200%");
		$(".footAdv").attr("style", "width:100%");
	});
	
	function submitReply() {
		if(nick=='') {
			alert("로그인이 필요한 서비스 입니다. ");
			return false;
		}
		
		var replyContent = document.getElementById("replyContent").value;
		if(replyContent=="") {
			alert("댓글을 입력하세요. ");
			return false;
		}
		
		var query = {
				boardIdx : ${vo.idx}, 
				nick : nick, 
				content : replyContent
		}
		$.ajax({
			type : 'post', 
			data : query, 
			url : "${ctp}/plaza/freeBoard/addReply", 
			success : function(data) {
				if(data=='fail') {
					alert("권한이 없습니다. ");
					return false;
				} else {
					alert("댓글을 달았습니다. ");
					location.reload();
				}
			}
		});
	}

	// 대댓글form
	function ReReplyForm(idx) {
		$("#rereplyform"+idx).toggle(300);
	}
	
	// 대댓글 등록
	function addReReply(idx) {
		if(nick=='') {
			alert("로그인이 필요한 서비스 입니다. ");
			return false;
		}
		
		var content = $("#rereplyContent"+idx).val();
		if(content=="") {
			alert("대댓글을 입력해주세요.");
			return false;
		}
		
		var query = {
				boardIdx : ${vo.idx}, 
				nick : nick, 
				content : content, 
				replyIdx : idx
		}
		
		$.ajax({
			type : 'post', 
			data : query, 
			url : "${ctp}/plaza/freeBoard/addReReply", 
			success : function(data) {
				if(data=='fail') {
					alert("권한이 없습니다. ");
					return false;
				} else {
					alert("대댓글을 달았습니다. ");
					location.reload();
				}
			}
		});
	}
	
	// 대댓 보기
	function showReReply(idx) {
		$("#show"+idx).toggle(0);
		$("#hide"+idx).toggle(0);
		if($("#rereplyList"+idx).html()!=""){
			$("#rereplyList"+idx).toggle(50);
		} else {
			$.ajax({
				type:"post", 
				url : "${ctp}/plaza/freeBoard/getReReply", 
				data : {idx : idx}, 
				success : function(data) {
					var addhtml = '<td colspan="3" style="padding:10px 10px 10px 60px;">'
										+'<table class="table table-borderless">';
					for(let i=0; i < data.length; i++) {
						addhtml+='<tr><td style="width:150px;font-size:1.2em;">'+data[i].nick+'</td><td>'+data[i].wdate.substring(0, 10)+'</td>';
						if(data[i].nick=='${sNick}'){
							addhtml+='<td style="width:100px;">'
										+'<a href="javascript:updateReplyform('+data[i].idx+')">수정</a>/'
										+'<a href="javascript:deleteReply('+data[i].idx+')">삭제</a>'
									+'</td>';
						}			
						addhtml+='</tr>'
								+'<tr style="border-bottom: 2px solid #de435755;">'
									+'<td colspan="3" id="replyContent'+data[i].idx+'" style="font-size:1.2em;">'+data[i].content.replace('\n', '<br/>')+'</td>'
								+'</tr>';
					}
					addhtml+='</table></td>';
					$("#rereplyList"+idx).html(addhtml);
				}
			});
		}
	}
	
	// 댓글 삭제
	function deleteReply(idx) {
		var ans = confirm("댓글을 삭제하시겠습니까?");
		if(!ans) return false;
		$.ajax({
			type:"post", 
			url : "${ctp}/plaza/freeBoard/deleteReReply", 
			data : {idx : idx}, 
			success : function() {
				alert("삭제했습니다. ");
				location.reload();
			}
		});
	}
	var correcting = false;
	// 댓글 수정 폼 띄우기
	function updateReplyform(idx) {
		if(correcting){
			alert("수정중인 댓글이 있습니다. 수정 완료 후 시도바랍니다. ");
			return false;
		}
		
		correcting = true;
		var content = $("#replyContent"+idx).html()
		content = content.replaceAll('&lt;br&gt;', '\n');
		content = content.replaceAll('<br>', '\n');
		addhtml = '<div class="row"><textarea rows="3" class="form-control col-11" id="updateReplyContent'+idx+'">'+content+'</textarea>'
				+'<div class="col-1 p-0">'
				+'<button type="button" onclick="updateReply('+idx+')" class="btn btn-danger btn-sm form-control" style="float:right;" >등록</button>'
				+'<button type="button" onclick="undoUpdate('+idx+')" class="btn btn-secondary btn-sm form-control" style="float:right;" >취소</button>'
				+'</div></div>';
		$("#replyContent"+idx).html(addhtml);
	}
	
	// 댓글 수정 등록
	function updateReply(idx) {
		var content = $("#updateReplyContent"+idx).val();
		if($("#updateReplyContent"+idx).val()=="") {
			alert("내용을 입력해주세요. ");
			return false;
		}
		
		$.ajax({
			type: "post", 
			url: "${ctp}/plaza/freeBoard/updateReply", 
			data : {idx : idx, content:content}, 
			success : function() {
				location.reload();
			}
		});
	}
	
	// 댓글 수정 취소
	function undoUpdate(idx) {
		$("#replyContent"+idx).html($("#updateReplyContent"+idx).html().replaceAll('\n', '<br>'));
		correcting = false;
	}
	
	//게시글 삭제
	function deleteBoard(idx) {
		var ans = confirm("글을 삭제하시겠습니까? 삭제하시면 복구할 수 없습니다. ");
		if(!ans) return false;
		
		location.href="${ctp}/plaza/freeBoard/deleteBoard?idx="+idx;
	}
	
	function recommend(idx){
		var nick = '${sNick}';
		if(nick==''){
			alert("로그인 필요합니다. ");
			return false;
		}
		var query = {
				boardIdx : idx, 
				nick : nick
		}
		$.ajax({
			type:"post", 
			url : "${ctp}/plaza/freeBoard/boardRecommend", 
			data: query, 
			success : function() {
				location.reload();
			}
		});
	}
	
	function cancleRecommend(idx) {
		var nick = '${sNick}';
		if(nick==''){
			alert("로그인 필요합니다. ");
			return false;
		}
		var query = {
				boardIdx : idx, 
				nick : nick
		}
		$.ajax({
			type:"post", 
			url : "${ctp}/plaza/freeBoard/boardRecommendCancle", 
			data: query, 
			success : function() {
				location.reload();
			}
		});
	}
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section class="row">
		<div class="col-2"></div>
		<div  class="col-8">
			<br/>
			<%@ include file="/WEB-INF/views/include/main/carouselAdv.jsp" %>
			<br/><br/>
			<h3>자유게시판</h3>
			
			<table class="table" style="max-width:1000px;">
				<tr class="table-danger">
					<td></td>
					<th style="width:50%;text-align: left;">${vo.title}</th>
					<td style="width:10%; min-width: 40px;"><c:if test="${empty vo.nick}"><span style="color:#777;">(알 수 없음)</span></c:if>${vo.nick}</td>
					<td style="min-width: 100px;">${fn:substring(vo.WDate, 0, 10)}</td>
					<td>조회수&nbsp;&nbsp;${vo.views}</td>
				</tr>
				<tr>
					<td colspan="5">
						<div style="min-height: 200px;padding:10px;font-size:1.2em;max-width: 1000px;">${vo.content}</div>
						<div style="text-align: center;">
							<c:if test="${not empty recoVo}">
								<button class="btn btn-danger btn-sm" onclick="cancleRecommend(${vo.idx})">
									<i style="font-size: 1.2em;" class="fas fa-heart"></i>&nbsp;
									<span class="badge badge-light">${vo.recommendCnt}</span>
								</button>
							</c:if>
							<c:if test="${empty recoVo}">
								<button class="btn btn-outline-danger btn-sm" onclick="recommend(${vo.idx})">
									<i style="font-size: 1.2em;" class="far fa-heart"></i>&nbsp;
									<span class="badge badge-secondary" style="opacity:0.7;">${vo.recommendCnt}</span>
								</button>
							</c:if>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="5" style="min-height: 100px;text-align: right;">
						<c:if test="${vo.nick==sNick && not empty sNick}">
							<button class="btn btn-secondary btn-sm"type="button" onclick="location.href='${ctp}/plaza/freeBoard/updateFreeBoard?idx=${vo.idx}'">수정</button>
							<button class="btn btn-secondary btn-sm"type="button" onclick="deleteBoard(${vo.idx})">삭제</button>
						</c:if>
						<button class="btn btn-danger btn-sm" 
						onclick="location.href='${ctp}/plaza/plaza?pag=${pag}&pageSize=${pageSize}&orderBy=${orderBy}&condition=${condition}&keyWord=${keyWord}&tab=freeBoard'">
							목록으로</button>
					</td>
				</tr>
				<tr>
					<td style="width:80px;">이전글 ▲</td>
					<td style="width:400px;">
						<c:if test="${!empty prevVo}">
							<a href="${ctp}/plaza/freeBoardDetail?idx=${prevVo.idx}">${prevVo.title}</a>
						</c:if>
						<c:if test="${empty prevVo}">
							<span style="color:#777;">이전 글이 없습니다.</span> 
						</c:if>
					</td>
					<td>${fn:substring(prevVo.WDate, 0, 10)}</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td>다음글 ▼</td>
					<td>
						<c:if test="${!empty nextVo}">
							<a href="${ctp}/plaza/freeBoardDetail?idx=${nextVo.idx}">${nextVo.title}</a>
						</c:if>
						<c:if test="${empty nextVo}">
							<span style="color:#777;">다음 글이 없습니다.</span>  
						</c:if>
					</td>
					<td>${fn:substring(nextVo.WDate, 0, 10)}</td>
					<td></td>
					<td></td>
				</tr>
			</table>
			<img alt="배너광고" src="${ctp}/images/advertise/${SAVo2.FSName}">
			<br/><br/>
			<div style="font-size: 1.6em;">댓글 ${fn:length(replyVos)}개</div>
			<table class="table table-borderless">
				<tr style="border-bottom: 2px solid #de4357;">
					<td colspan="2" class="p-4">
						<div class="row">
							<textarea rows="3" class="form-control col-11" id="replyContent"></textarea>
							<input type="button" class="btn btn-danger ml-1" value="등록" onclick="submitReply()"/>
						</div>
					</td>
				<tr/>
				<c:forEach var="vo" items="${replyVos}">
					<tr style="border-top: 2px solid #de4357;">
						<td style="width:150px;font-size:1.2em;">
							<c:if test="${empty vo.nick}">(알 수 없음)</c:if>
							${vo.nick}
						</td>
						<td>${fn:substring(vo.WDate, 0, 10)}</td>
						<c:if test="${vo.nick==sNick && not empty sNick}">
							<td style="width:100px;">
							<a href="javascript:updateReplyform(${vo.idx})">수정/</a>
							<a href="javascript:deleteReply(${vo.idx})">삭제</a>
							</td>
						</c:if>
					</tr>
					<tr>
						<td colspan="3" id="replyContent${vo.idx}" 
						style="font-size:1.2em;padding:20px;<c:if test="${empty vo.nick}">color:#777;</c:if>">${fn:replace(vo.content, newLine, '<br/>')}</td>
					</tr>
					<tr style="border-bottom: 2px solid #de435755;">
						<td colspan="3" style="padding:0;">
							<c:if test="${vo.rereplyCnt>0}">
								<button type="button" onclick="showReReply(${vo.idx})" class="btn">
										답글 ${vo.rereplyCnt }개 
										<span id="show${vo.idx}" class="show">보기 ▼</span>
										<span id="hide${vo.idx}" class="hide">숨기기 ▲</span>
								</button>
							</c:if>
							<button type="button" onclick="ReReplyForm(${vo.idx})" class="btn btn-light">답글</button>
						</td>
					</tr>
					<tr id="rereplyform${vo.idx}" class="rereplyform" style="border-bottom: 2px solid #de435755;">
						<td style="padding-left:50px;">답글 : </td>
						<td><textarea rows="1" class="form-control" id="rereplyContent${vo.idx}"></textarea></td>
						<td><button type="button" onclick="addReReply(${vo.idx})" class="btn btn-outline-danger">등록</button></td>
					</tr>
					<tr id="rereplyList${vo.idx}" style="border-bottom: 2px solid #de4357;"></tr>
				</c:forEach>
			</table>
			<br/><br/>
		</div>
		<div class="col-2"></div>
	</section>
	<br/><br/><br/><br/>
	<footer>
		<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</footer>
</body>
</html>