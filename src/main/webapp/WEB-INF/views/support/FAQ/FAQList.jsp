<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="support/FAQ/FAQList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script type="text/javascript">
	$(function() {
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
	
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}";
		location.href = link;
	}
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<jsp:include page="/WEB-INF/views/support/include/supportHeader.jsp"/>
			<div class="row">
				<jsp:include page="/WEB-INF/views/support/include/supportSideBar.jsp"/>
				<div id="detail" class="col-9">
					<h3>FAQ</h3>
					자주 찾는 질문과 답을 조회할 수 있습니다. 궁금한 내용을 검색해주세요. 결과가 없다면 1:1문의를 이용해주세요. 
					<table class="table table-borderless m-0 p-0" id="tableHeader">
						<tr>
							<td style="width:12%; min-width: 140px;" >
								<select class="form-control" id="orderBy">
									<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>기본</option>
									<option value="question" <c:if test="${orderBy=='question'}">selected</c:if>>ㄱㄴㄷ순</option>
									<option value="views" <c:if test="${orderBy=='views'}">selected</c:if>>조회수순</option>
								</select>
							</td>
							<td style="width:10%">
								<select class="form-control" id="pageSize">
									<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2건</option>
									<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5건</option>
									<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10건</option>
								</select>
							</td>
							<td style="width:33%">
								<div class="input-group mb-3">
								    <input type="text" class="form-control" id="keyWord" placeholder="검색" value="${keyWord}">
								    <div class="input-group-append">
								    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
								    </div>
								</div>
							</td>
						</tr>
					</table>
					<table class="table table-hover">
						<tr class="table-danger">
							<th style="width:50px;">번호</th>
							<th>질문</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td style="text-align: center;">${vo.idx}</td>
								<%-- <td onclick="showDetail(${vo.idx})">${vo.question}</td> --%>
								<td><a href="${ctp}/support/FAQ/FAQDetail?idx=${vo.idx}">${vo.question}</a></td>
							</tr>
							<%-- <tr id="answer${vo.idx}" class="detail"><td></td><td>${vo.answer}</td></tr> --%>
						</c:forEach>
					</table>
					<%@ include file="/WEB-INF/views/include/paging.jsp" %>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>