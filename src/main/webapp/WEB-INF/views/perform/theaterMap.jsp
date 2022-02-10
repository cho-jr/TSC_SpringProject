<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7683b4256a3da48d3bfb00122371ef24&libraries=services,clusterer,drawing"></script>
<script type="text/javascript">
	$(function(){
		var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		var options = { //지도를 생성할 때 필요한 기본 옵션
			center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표.
			level: 3 //지도의 레벨(확대, 축소 정도)
		};
		
		var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
		
		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		// 주소로 좌표를 검색합니다
		geocoder.addressSearch('${theaterVo.address1}', function(result, status) {

		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {

		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

		        // 결과값으로 받은 위치를 마커로 표시합니다
		        var marker = new kakao.maps.Marker({
		            map: map,
		            position: coords
		        });

		        // 인포윈도우로 장소에 대한 설명을 표시합니다
		        var infowindow = new kakao.maps.InfoWindow({
		            content: '<div style="width:160px;text-align:center;padding:8px 0;border:4px solid #c56;">'
		            			+'<a href="https://map.kakao.com/?q=${theaterVo.name}" style="font-weight:600;font-size:1.2em;">${theaterVo.name}</a></div>'
		        });
		        infowindow.open(map, marker);

		        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
		        map.setCenter(coords);
		    } 
		});    
	});
</script>
<style type="text/css">
</style>

<br/><br/>
<br/>
<h2>&lt;${theaterVo.name}&gt; 상세정보</h2><hr/>
<br/><br/>
<div class="row">
	<div class="col-6 ml-4" id="map" style="width:500px;height:400px;"></div>
	<div class="col-5">
		<table class="table table-borderless theaterinfo">
			<tr>
				<th style="width:30%;">상세 주소 </th>
				<td style="line-height: 1.8em;">${theaterVo.address1} <br/>${theaterVo.address2} ${theaterVo.address3}</td>
			</tr>
			<tr>
				<th>공연(예정)작</th>
				<td>
					<c:forEach var="pvo" items="${performVos}"> 
						<a href="${ctp}/perform/performInfo?idx=${pvo.idx}">${pvo.title}</a><br/><br/>
					</c:forEach> 
				</td>
			</tr>
			<tr>
				<th></th>
				<td class="text-right"><a href="${ctp}/perform/performList" class="btn btn-danger">공연 더보기</a></td>
			</tr>
		</table>
	</div>
</div>
<br/><br/><br/><br/>
		