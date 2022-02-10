<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="pagingVO" value="${freeBoardPagingVO}"/>
<style>
	#content tr td:nth-child(n+2) {text-align: center;}
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<script>

$(function() {
	$("#FpageSize").on("change", function() {
		var link = "${ctp}/${linkpath}?orderBy=${orderBy}&tab=freeBoard&pag=1&pageSize="+$(this).val();
		location.href = link;
	});
	setInterval(function()
		{
			$(".new").toggleClass("badge-danger");
			$(".new").toggleClass("badge-primary");
			$(".inssa").toggleClass("text-danger");
			$(".inssa").toggleClass("text-warning");
		}, 700 );
});

function Fsearch(){
	var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
				+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}&tab=freeBoard";
	location.href = link;
}

function writeBoard(){
	if('${sNick}'==''){
		alert("로그인이 필요한 서비스 입니다. ");
		return false;
	}
	location.href='${ctp}/plaza/newFreeBoard'
}
</script>
<c:set var="tab" value="freeBoard"/>
<h3>자유게시판</h3>
<div>
	자유롭게 글을 남기고 대화를 나누는 게시판입니다. 답변이 필요한 문의사항은 1:1문의를 이용해주세요. <br/>
	사이트 운영에 관한 건의사항은 [고객센터]-[건의사항]을 이용해주세요. <br/>
	공연 감상평(리뷰)은 해당 공연상세페이지 하단에 작성해주세요. <br/><br/>
</div>
<table class="table table-borderless m-0 p-0" id="tableHeader">
	<tr>
		<td style="width:10%">
			<button type="button" class="btn btn-danger btn-sm" onclick="writeBoard()">글쓰기</button>
		</td>
		<td style="width:10%">
			<select class="form-control" id="FpageSize">
				<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2줄</option>
				<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5줄</option>
				<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10줄</option>
			</select>
		</td>
		<td style="width:33%">
			<div class="input-group mb-3">
			    <input type="text" class="form-control" id="keyWord" placeholder="작성자, 제목 검색가능" value="${keyWord}">
			    <div class="input-group-append">
			    	<button class="btn btn-danger" type="submit" onclick="Fsearch()">검색</button>
			    </div>
			</div>
		</td>
	</tr>
</table>
<table class="table table-hover" id="content">
	<tr class="table-danger">
		<th style="width:60%;">제목</th>
		<th>작성자</th>
		<th>작성일</th>
		<th>조회</th>
		<th>추천</th>
	</tr>
	<jsp:useBean id="now" class="java.util.Date" />
	<c:forEach var="vo" items="${boardVos}">
		<fmt:parseDate var="WDate" value="${vo.WDate}" pattern="yyyy-MM-dd HH:mm:ss" />
		<fmt:formatDate value="${WDate}" pattern="yyyyMMddHHmm" var="WriteDate"/>
		<tr>
			<td>
				<c:if test="${WDate.time>now.time-1000*60*60*24}"><span class="badge badge-pill badge-danger new" style="opacity:0.5;">new</span></c:if>
				<a href="${ctp}/plaza/freeBoardDetail?idx=${vo.idx}">${vo.title}</a> (${vo.replyCnt})
			</td>
			<td><c:if test="${empty vo.nick}"><span style="color:#777;">(알 수 없음)</span></c:if>${vo.nick}</td>
			<td id="wdate${vo.idx}">${fn:substring(vo.WDate, 0, 10)}</td>
			<td>${vo.views }</td>
			<td>${vo.recommendCnt}</td>
		</tr>
		<c:if test="${WDate.time>now.time-1000*60*60*24}">
			<script>
				document.getElementById("wdate${vo.idx}").innerText=moment('${vo.WDate}').fromNow();
			</script>
		</c:if>
	</c:forEach>
</table>
<c:set var="linkpath" value="plaza/plaza"/>
<c:set var="tab" value="freeBoard"/>
<c:set var="pagingVO" value="${freeBoardPagingVO}"/>
<%@ include file="/WEB-INF/views/include/paging.jsp" %>

<br/><br/><br/><br/>
<h3><span class="text-danger inssa" style="opacity: 0.6"><i class="fas fa-star"></i></span>
	인기글
	<span class="text-danger inssa" style="opacity: 0.6"><i class="fas fa-star"></i></span>
</h3>
<table class="table table-hover" id="content">
	<tr class="table-danger">
		<th style="width:60%;">제목</th>
		<th>작성자</th>
		<th>작성일</th>
		<th>조회</th>
		<th>추천</th>
	</tr>
	<c:forEach var="vo" items="${inssaVos}">
		<fmt:parseDate var="WDate" value="${vo.WDate}" pattern="yyyy-MM-dd HH:mm:ss" />
		<fmt:formatDate value="${WDate}" pattern="yyyyMMddHHmm" var="WriteDate"/>
		<tr>
			<td>
				<c:if test="${WDate.time>now.time-1000*60*60*24}"><span class="badge badge-pill badge-danger new" style="opacity:0.5;">new</span></c:if>
				<a href="${ctp}/plaza/freeBoardDetail?idx=${vo.idx}">${vo.title}</a> (${vo.replyCnt})
			</td>
			<td><c:if test="${empty vo.nick}"><span style="color:#777;">(알 수 없음)</span></c:if>${vo.nick}</td>
			<td>${fn:substring(vo.WDate, 0, 10)}</td>
			<td>${vo.views }</td>
			<td>${vo.recommendCnt}</td>
		</tr>
	</c:forEach>
</table>
