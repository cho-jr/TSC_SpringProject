<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>


<script>
$(function() {
	$("#RorderBy").on("change", function() {
		var link = "${ctp}/${linkpath}?orderBy="+$(this).val()+"&pag=1&pageSize=${pagingVO.pageSize}&tab=reviews";
		location.href = link;
	});
	$("#RpageSize").on("change", function() {
		var link = "${ctp}/${linkpath}?orderBy=${orderBy}&tab=reviews&pag=1&pageSize="+$(this).val();
		location.href = link;
	});
});

function Rsearch(){
	var link = "${ctp}/${linkpath}?keyWord="+$("#RkeyWord").val()
				+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}&tab=reviews";
	location.href = link;
}

//로그인 여부 확인
function loginCheck(){
	var sNick = '${sNick}';
	if(sNick==""){
		let ans = confirm("로그인이 필요한 서비스입니다. ");
		if(!ans) return false;
		location.href="${ctp}/member/login";
		return false;			
	} return true;
}
// 신고처리
function report(idx) {
	if(!loginCheck()) return false;
	var sNick = '${sNick}';
	var ans = prompt("신고 사유를 입력해주세요. ");
	if(ans=="" || ans==null) {
		alert("신고처리 되지 않았습니다. ");
		return false;
	}
	
	var query = {
			reporterNick : sNick, 
			reviewIdx:idx, 
			reason:ans
	}
	
	$.ajax({
		type:"post", 
		url:"${ctp}/perform/reportReview",  		
		data: query, 
		success:function() {
			alert("신고처리하였습니다. 불편을 드려 죄송합니다. 더 나은 TSC를 위해 노력하겠습니다. ");
		}
	});
}
</script>
<c:set var="tab" value="reviews"/>
<h3>리뷰모아보기</h3>
<div>모든 공연의 리뷰를 보실 수 있습니다. <br/><br/></div>
<table class="table table-borderless m-0 p-0" id="tableHeader">
	<tr>
		<td style="width:10%">
			<select class="form-control" id="RpageSize">
				<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2줄</option>
				<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5줄</option>
				<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10줄</option>
			</select>
		</td>
		<td style="width:20%">
			<select class="form-control" id="RorderBy">
				<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>작성일순</option>
				<option value="star" <c:if test="${orderBy=='star'}">selected</c:if>>별점순</option>
				<option value="nick" <c:if test="${orderBy=='nick'}">selected</c:if>>회원별</option>
				<option value="performIdx" <c:if test="${orderBy=='performIdx'}">selected</c:if>>작품별</option>
			</select>
		</td>
		<td style="width:33%">
			<div class="input-group mb-3">
			    <input type="text" class="form-control" id="RkeyWord" placeholder="작성자, 내용 검색가능">
			    <div class="input-group-append">
			    	<button class="btn btn-danger" type="submit" onclick="Rsearch()">검색</button>
			    </div>
			</div>
		</td>
	</tr>
</table>
<table class="table table-hover">
	<tr class="table-danger">
		<th style="min-width: 90px;">닉네임</th>
		<th style="min-width: 100px;">제목</th>
		<th>별점</th>
		<th>리뷰내용</th>
		<th style="min-width: 100px;">작성일</th>
		<th style="min-width: 150px;">보러가기</th>
	</tr>
	<c:forEach var="vo" items="${reviewVos}">
		<tr >
			<td>
				<c:if test="${empty vo.nick}"><span style="color:#777;">(알 수 없음)</span></c:if>
				<c:if test="${fn:length(vo.nick)<=2 }">${fn:replace(vo.nick, fn:substring(vo.nick, 0, 1), '*')}</c:if>
				<c:if test="${fn:length(vo.nick)>=3 && fn:length(vo.nick)<6}">${fn:replace(vo.nick, fn:substring(vo.nick, 1, 3), '**')}</c:if>
				<c:if test="${fn:length(vo.nick)>=6 }">${fn:replace(vo.nick, fn:substring(vo.nick, 1, 5), '****')}</c:if>
			</td>
			<td>${vo.performTitle}</td>
			<td>
				<c:choose>
					<c:when test="${vo.star==1}"><span style="color:#f90">★</span>★★★★</c:when>
					<c:when test="${vo.star==2}"><span style="color:#f90">★★</span>★★★</c:when>
					<c:when test="${vo.star==3}"><span style="color:#f90">★★★</span>★★</c:when>
					<c:when test="${vo.star==4}"><span style="color:#f90">★★★★</span>★</c:when>
					<c:when test="${vo.star==5}"><span style="color:#f90">★★★★★</span></c:when>
					<c:otherwise>별점 없음</c:otherwise>
				</c:choose>
			</td>
			<td style="width:50%;" class="summary sum${vo.idx}" onclick="show(${vo.idx})">
				<c:if test="${fn:contains(vo.reviewContent, '@@WARN')}">
					<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
				</c:if>
				<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
					${fn:substring(vo.reviewContent, 0, 40)}
					<c:if test="${fn:length(vo.reviewContent)>40}">...</c:if>
				</c:if>
			</td>
			<td style="width:50%;" class="detail det${vo.idx}" onclick="show(${vo.idx})">
				<c:if test="${fn:contains(vo.reviewContent, '@@WARN')}">
					<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
				</c:if>
				<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
					${vo.reviewContent}
				</c:if>
			</td>
			<td>${fn:substring(vo.WDate, 0, 10)}</td>
			<td>
				<a href="${ctp}/perform/performInfo?idx=${vo.performIdx}" class="btn btn-outline-danger btn-sm hoverShow">공연 정보</a>
				<c:if test="${not fn:contains(vo.reviewContent, '@@WARN')}">
					<a class="btn btn-sm hoverShow" href="javascript:report(${vo.idx})">신고</a>	
				</c:if>							
			</td>
		</tr>
	</c:forEach>
</table>
<c:set var="linkpath" value="plaza/plaza"/>
<c:set var="tab" value="reviews"/>

<c:set var="pagingVO" value="${reviewPagingVO}"/>
<%@ include file="/WEB-INF/views/include/paging.jsp" %>