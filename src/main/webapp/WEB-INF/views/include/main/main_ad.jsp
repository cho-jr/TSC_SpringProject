<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<link href="${ctp}/css/main_ad.css" rel="stylesheet" type="text/css" />
<div class="main_ad">
		<div class="contents">
			<div class="video_wrap">
				<video autoplay muted width="1080px">
					<source src='${ctp}/images/advertise/${advVo.FSName}' type='video/mp4'>
				</video>
				<strong id="ad_video_title">${advVo.title}</strong> 
				<span id="ad_video_text">${advVo.subMent}</span>
			</div>
		</div>
	</div>