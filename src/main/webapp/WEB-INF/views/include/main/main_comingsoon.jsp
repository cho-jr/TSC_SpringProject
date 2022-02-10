<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>

	<div style="width:100%; border:2px solid white;">
		<br/>
		<div style="font-size: 2.5em;color:#222;">
			<b>&nbsp;&nbsp;공연예정작&nbsp;</b>
			<span class="plusBtn mt-2">
				<a href="${ctp}/perform/performList?condition=comingsoon&orderBy=startDate">더보기&nbsp;&nbsp;<i class="fas fa-plus"></i></a>
			</span><br/>
		</div>
		<table>
			<tr>
			<c:forEach var="i" begin="0" end="3">
				<c:if test="${!empty comingsoonVos[i]}">
					<td style="padding-left: 0px;">
						<div class="card" style="width:230px;margin:10px;border-radius: 13px; border:0px;">
						    <img class="card-img-top" src="${ctp}/${comingsoonVos[i].posterFSN}" alt="Card image" style="width:100%;height:284px; border-radius: 13px;">
						    <div class="card-img-overlay align-middle" style="text-align:center;border-radius: 13px;">
						    	<div style="position:relative;top:0px;height:120px;">
									<a href="${ctp}/perform/performInfo?idx=${comingsoonVos[i].idx}" class="btn btn-danger stretched-link"
									style="margin:100px 30px;">상세보기</a><br/>
						    	</div>
							</div>
						</div>
					    <div class="container">
					    	<c:if test="${fn:length(comingsoonVos[i].title)>10}"><h5 class="card-title">${fn:substring(comingsoonVos[i].title, 0, 10)}...</h5></c:if>
					    	<c:if test="${fn:length(comingsoonVos[i].title)<=10}"><h5 class="card-title">${comingsoonVos[i].title}</h5></c:if>
						    <p class="card-text">
						    	${fn:substring(comingsoonVos[i].startDate,0,10)} ~ ${fn:substring(comingsoonVos[i].endDate,0,10)}<br/>
						    	${comingsoonVos[i].theater}<br/>
						    	<span style="color:#aa3;">★</span>${fn:substring(comingsoonVos[i].star, 0, 3)}
						    </p>
					    </div>
					</td>
				</c:if>
			</c:forEach>
		</table>
	</div>