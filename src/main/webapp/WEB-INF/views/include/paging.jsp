<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<ul class="pagination justify-content-center">
	<c:if test="${pagingVO.totPage == 0}"><p style="text-align:center"><b>내역이 없습니다.</b></p></c:if>
	<c:if test="${pagingVO.totPage != 0}">
	    <c:if test="${pagingVO.pag != 1}">
	    	<li class="page-item"><a href="${ctp}/${linkpath}?pag=1&pageSize=${pagingVO.pageSize}&orderBy=${orderBy}&condition=${condition}&keyWord=${keyWord}&tab=${tab}&date=${date}&idx=${idx}" 
	    	title="첫페이지" class="page-link text-danger">◁◁</a></li>
	    </c:if>
	    <c:if test="${pagingVO.curBlock > 0}">
	    	<li class="page-item"><a href="${ctp}/${linkpath}?pag=${(pagingVO.curBlock-1)*pagingVO.blockSize + 1}&pageSize=${pagingVO.pageSize}&orderBy=${orderBy}&condition=${condition}&keyWord=${keyWord}&tab=${tab}&date=${date}&idx=${idx}" 
	    	title="이전블록" class="page-link text-danger">◀</a></li>
	    </c:if>
	    <c:forEach var="i" begin="${(pagingVO.curBlock*pagingVO.blockSize)+1}" end="${(pagingVO.curBlock*pagingVO.blockSize)+pagingVO.blockSize}">
		    <c:if test="${i == pagingVO.pag && i <= pagingVO.totPage}">
		      	<li class="page-item active">
		      		<a href='${ctp}/${linkpath}?pag=${i}&pageSize=${pagingVO.pageSize}&orderBy=${orderBy}&condition=${condition}&keyWord=${keyWord}&tab=${tab}&date=${date}&idx=${idx}'
		      		class="page-link text-light bg-danger border-danger">${i}</a>
		      	</li>
		    </c:if>
		    <c:if test="${i != pagingVO.pag && i <= pagingVO.totPage}">
		      	<li class="page-item">
		      		<a href='${ctp}/${linkpath}?pag=${i}&pageSize=${pagingVO.pageSize}&orderBy=${orderBy}&condition=${condition}&keyWord=${keyWord}&tab=${tab}&date=${date}&idx=${idx}' 
		      		class="page-link text-danger">${i}</a></li>
		    </c:if>
	    </c:forEach>
	    <c:if test="${pagingVO.curBlock < pagingVO.lastBlock}">
	    	<li class="page-item">
	    		<a href="${ctp}/${linkpath}?pag=${(pagingVO.curBlock+1)*pagingVO.blockSize + 1}&pageSize=${pagingVO.pageSize}&orderBy=${orderBy}&condition=${condition}&keyWord=${keyWord}&tab=${tab}&date=${date}&idx=${idx}" 
	    		title="다음블록" class="page-link text-danger">▶</a></li>
	    </c:if>
	    <c:if test="${pagingVO.pag != pagingVO.totPage}">
	    	<li class="page-item"><a href="${ctp}/${linkpath}?pag=${pagingVO.totPage}&pageSize=${pagingVO.pageSize}&orderBy=${orderBy}&condition=${condition}&keyWord=${keyWord}&tab=${tab}&date=${date}&idx=${idx}" 
	    	title="마지막페이지" class="page-link text-danger">▷▷</a></li>
	    </c:if>
	</c:if>
</ul>