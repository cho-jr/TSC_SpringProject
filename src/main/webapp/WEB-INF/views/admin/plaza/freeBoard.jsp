<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/plaza/freeBoard"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
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
		$(".hide").toggle(0);
		$('#lost_mask').css({'width':'0','height':'0'});
		$("#orderBy").on("change", function() {
			var link = "${ctp}/${linkpath}?orderBy="+$(this).val()+"&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
			location.href = link;
		});
		$("#pageSize").on("change", function() {
			var link = "${ctp}/${linkpath}?condition=${condition}&pag=${pagingVO.pag}&pageSize="+$(this).val();
			location.href = link;
		});
		setInterval(function()
				{
					$(".new").toggleClass("badge-danger");
					$(".new").toggleClass("badge-primary");
				}, 700 );
	});
	
	function show(idx) {$(".content"+idx).toggle(100);}
	function showReply(idx) {$(".reply"+idx).toggle(100);}
	
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&condition=${condition}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
		location.href = link;
	}

	// 대댓글보기
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
					var addhtml = '<td colspan="4" style="padding:10px 10px 10px 60px;">'
										+'<table class="table table-borderless">';
					for(let i=0; i < data.length; i++) {
						addhtml+='<tr><td>'+data[i].nick+'</td>'
									+'<td colspan="3" id="replyContent'+data[i].idx+'">'+data[i].content+'</td>'
									+'<td>'+data[i].wdate.substring(0, 10)+'</td>'
									+'<td style="width:100px;" style="border-bottom: 2px solid #7775;">'
										+'<a href="javascript:deleteReply('+data[i].idx+')" class="btn btn-sm btn-danger">삭제</a>'
									+'</td>'
								+'</tr>';//.replace('\n', '<br/>')
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
	
	// 새 창에 회원정보
	function newWin(nick) {
		url = "${ctp}/admin/member/memberDetail?nick="+nick;
		window.open(url, "newWin", "width=600px, height=700px");
	}
	
	// 게시글 삭제
	function deleteBoard(idx){
		var ans = confirm("삭제하시겠습니까?");
		if(!ans) return false;
		$.ajax({
			type:"post", 
			url : "${ctp}/admin/plaza/deleteBoard", 
			data : {idx : idx}, 
			success : function() {
				alert("삭제했습니다. ");
				location.href="${ctp}/${linkpath}?keyWord=${keyWord}&pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
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
			<h3>&lt;자유게시판&gt;</h3>
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
						<select class="form-control" id="orderBy">
							<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>작성일순</option>
							<option value="views" <c:if test="${orderBy=='views'}">selected</c:if>>조회수순</option>
							<option value="nick" <c:if test="${orderBy=='nick'}">selected</c:if>>작성자별</option>
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
			<table class="table">
				<tr>
					<th style="width:5%">선택</th>
					<th style="width:15%">회원명</th>
					<th>제목</th>
					<th style="width:15%">작성일</th>
					<th style="width:7%">조회수</th>
					<th style="width:8%">삭제</th>
				</tr>
				<c:forEach var="vo" items="${vos}" varStatus="st">
					<tr>
						<td><input type="checkbox" name="selectIdx" value="${vo.idx}"/></td>
						<td style="font-weight: 600;text-align: center;"><c:if test="${empty vo.nick}">(알 수 없음)</c:if><a href="javascript:newWin('${vo.nick}')">${vo.nick}</a></td>
						<td class="pl-4">
							<jsp:useBean id="now" class="java.util.Date" />
							<fmt:parseDate var="WDate" value="${vo.WDate}" pattern="yyyy-MM-dd HH:mm:ss" />
							<fmt:formatDate value="${WDate}" pattern="yyyyMMddHHmm" var="WriteDate"/>
							<c:if test="${WDate.time>now.time-1000*60*60*24}"><span class="badge badge-pill badge-danger new" style="opacity:0.5;">new</span></c:if>
							<b><a href="javascript:show(${vo.idx});"><c:out value="${vo.title}"/></a></b> (${vo.replyCnt})
						</td>
						<td style="text-align: center;"><c:out value="${fn:substring(vo.WDate, 0, 10)}"/></td>
						<td class="text-center">${vo.views}</td>
						<td class="text-center"><button onclick="deleteBoard(${vo.idx})" class="btn btn-danger btn-sm">삭제</button></td>
					</tr>
					<tr class="detail content${vo.idx}" >
						<td></td><td></td>
						<td colspan="2">${vo.content}</td>
						<td></td>
					</tr>
					<tr>
						<td colspan="3"></td>
						<td class="text-primary" style="cursor: pointer;" onclick="showReply(${vo.idx})">
							<c:if test="${vo.replyCnt>0}">
								댓글 보기
							</c:if>
						</td>
						<td colspan="2"><a class="text-primary" style="cursor: pointer;" href='${ctp}/plaza/freeBoardDetail?idx=${vo.idx}' target="_blank">게시글로 이동</a></td>
					</tr>
					<tr class="detail reply${vo.idx}">
						<td></td>
						
						<td colspan="4" style="padding-right: 80px;">
							<table class="table table-bordered">
								<c:forEach var="rvo" items="${replyList[st.index]}">
									<tr style="border-top: 2px solid #777;">
										<td style="width:10%;min-width: 150px;">
											<c:if test="${empty rvo.nick}">(알 수 없음)</c:if>
											<a href="javascript:newWin('${rvo.nick}')" >${rvo.nick}</a>
										</td>
									
										<td colspan="3" id="replyContent${rvo.idx}" 
										style="width:65%;<c:if test="${empty rvo.nick}">color:#777;</c:if>">${fn:replace(rvo.content, newLine, '<br/>')}</td>
										<td>${fn:substring(rvo.WDate, 0, 10)}</td>
											<td style="width:100px;">
											<a href="javascript:deleteReply(${rvo.idx})" class="btn btn-sm btn-danger">삭제</a>
										</td>
									</tr>
									<tr style="border-bottom: 2px solid #7775;">
										<td colspan="3" style="padding:0;">
											<c:if test="${rvo.rereplyCnt>0}">
												<button type="button" onclick="showReReply(${rvo.idx})" class="btn">
														답글 ${rvo.rereplyCnt }개 
														<span id="show${rvo.idx}" class="show">보기 ▼</span>
														<span id="hide${rvo.idx}" class="hide">숨기기 ▲</span>
												</button>
											</c:if>
										</td>
									</tr>
									<tr id="rereplyList${rvo.idx}" style="border-bottom: 2px solid #777;"></tr>
								</c:forEach>
							</table>
						</td>
					</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/plaza/freeBoard"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>