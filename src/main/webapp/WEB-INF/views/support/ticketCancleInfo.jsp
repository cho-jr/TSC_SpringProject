<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style type="text/css">
	.info {font-size: 1.1em;}
</style>
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
					<h4>예매취소/환불안내</h4>
					<div>
						예매 취소 및 환불 규정과 방법을 안내드립니다. <br/>
						마이페이지에서 직접 예매 취소에 어려움이 있으시면 고객센터 1588-1234로 유선 연락 바랍니다. 
					</div>
					<br/>
					<hr style="background-color: #eee;"/><br/>
					<ul class="nav nav-tabs mb-4" style="justify-content:flex-start;font-size: 1.5em;width:712px;">
					    <li class="nav-item">
					    	<a class="nav-link active" data-toggle="tab" href="#ticket" id="tickettab">예매취소 안내</a>
					    </li>
					    <li class="nav-item">
					    	<a class="nav-link" data-toggle="tab" href="#payBack" id="payBacktab">환불 안내</a>
					    </li>
					</ul>
					<div class="tab-content">
					    <div class="tab-pane container active" id="ticket">
							<div class="info">
								<span style="font-size:1.1em;"><b>[예매 취소 마감시간]</b></span><br/>
								기획사 정책에 따라 특정 상품의 예매 취소 마감시간이 다를 수 있습니다.<br/>
								예매 시 확인 및 동의 후 진행이 가능하며, 예매 후에는 마이페이지 예매 상세 페이지에서 확인하실 수 있습니다.<br/>
								
								공연/전시<br/>
								- 현장 수령 티켓 : 행사일 1일 전 17:00까지<br/>
							</div><br/>
							<hr style="background-color: #eee;"/><br/>
							
							<div class="info">
								<span style="font-size:1.1em;"><b>[예매 취소시 유의사항]</b></span><br/>
								수수료 부과<br/>
								- 상품의 특성에 따라 취소수수료 정책이 달라질 수 있습니다. (예매 시 확인 가능)<br/>
								- 예매수수료는 예매 당일 밤 12시 이전까지만 환불됩니다.<br/>
								<br/>예매 후 예매내역에 대한 변경 불가
								<br/>- 예매된 건에 대한 일부 변경(날짜/시간/좌석/결제 등)은 불가하여, 기존 예매건을 취소하시고 다시 예매를 하셔야 합니다.
								<br/>단, 취소 시점에 따라 예매수수료가 환불되지 않거나 취소수수료가 부과될 수 있습니다.
								<br/>- 재예매를 하실 경우, 기존에 예매하셨던 좌석이 보장되지 않을 수 있습니다.<br/>
								<br/>일괄 취소
								<br/>- 일부 상품의 경우, 우천 취소 등의 상황에 따라 일괄 취소가 발생할 수 있으며 일괄 취소 시 취소수수료가 부과되지 않습니다.
								<br/>단, 일괄 취소 공지 이전에 직접 예매를 취소하신 경우에는 취소수수료가 반환되지 않습니다.
								<br/>- 행사 상의 문제로 인해 환불을 받으실 경우 별도의 수수료를 공제하지 않으며, 환불 주체가 티켓링크가 아닌 행사 주최사가
								<br/>될 수 있습니다.
							</div><br/>
					    </div>
					    
					    <div class="tab-pane container fade" id="payBack">
							<div class="info">
								<span style="font-size:1.1em;"><b>[무통장 입금으로 결제하신 경우]</b></span><br/>
								<br/>수수료(예매수수료, 취소수수료)를 제외한 나머지 금액이 고객 환불 계좌에 입금됩니다.
								<br/>온라인 취소 시, 마이페이지 > 환불계좌관리에서 환불계좌 정보(본인 명의)를 정확히 입력해 주시기 바랍니다 .
								<br/>- 타인의 계좌를 이용하거나 명의를 도용했을 경우 서비스 이용이 제한될 수 있습니다.
								<br/>- 취소 처리를 접수한 날로부터 영업일 기준 3~5일 이내에 환불받으실 수 있습니다.
							</div><br/>
						    <hr style="background-color: #eee;"/><br/>
							<div class="info">
								<span style="font-size:1.1em;"><b>[카드로 결제하신 경우]</b></span><br/>
								<br/>배송료 및 취소시점에 따른 취소수수료, 예매수수료를 제외한 금액이 부분 취소 처리 됩니다.
								<br/>- 취소일로부터 영업일 기준 3~5일 정도 후 (평일 기준, 토/일/공휴일 제외) 카드사에서 확인 가능합니다.
								<br/>- 카드사 관련 문의는 개인 정보 확인 절차로 인해 티켓링크에서 대신 확인해드릴 수 없습니다.
								<br/><br/><br/>
								
								<table class="table">
	                                <thead>
	                                <tr class="table-danger text-center">
	                                    <th scope="col">카드사 명</th>
	                                    <th scope="col">연락처</th>
	                                    <th scope="col">카드사 명</th>
	                                    <th scope="col">연락처</th>
	                                </tr>
	                                </thead>
	                                <tbody>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">신한</th>
	                                    <td class="color_black">1544-7000</td>
	                                    <th scope="row" class="color_gray">하나SK</th>
	                                    <td class="color_black">1599-1155</td>
	                                </tr>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">비씨</th>
	                                    <td class="color_black">1588-4000</td>
	                                    <th scope="row" class="color_gray">우리</th>
	                                    <td class="color_black">1588-9955</td>
	                                </tr>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">삼성</th>
	                                    <td class="color_black">1588-8700</td>
	                                    <th scope="row" class="color_gray">광주</th>
	                                    <td class="color_black">1588-3388</td>
	                                </tr>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">현대</th>
	                                    <td class="color_black">1577-6000</td>
	                                    <th scope="row" class="color_gray">수협</th>
	                                    <td class="color_black">1588-1515</td>
	                                </tr>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">국민</th>
	                                    <td class="color_black">1588-1688</td>
	                                    <th scope="row" class="color_gray">전북</th>
	                                    <td class="color_black">1588-4477</td>
	                                </tr>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">외환</th>
	                                    <td class="color_black">1588-3200</td>
	                                    <th scope="row" class="color_gray">롯데</th>
	                                    <td class="color_black">1588-8100</td>
	                                </tr>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">농협</th>
	                                    <td class="color_black">1588-1600</td>
	                                    <th scope="row" class="color_gray">제주</th>
	                                    <td class="color_black">1588-0079</td>
	                                </tr>
	                                <tr class="text-center">
	                                    <th scope="row" class="color_gray">씨티</th>
	                                    <td class="color_black">1566-1000</td>
	                                    <th scope="row" class="color_gray">신협체크</th>
	                                    <td class="color_black">042-720-1000</td>
	                                </tr>
	                                </tbody>
	                            </table>
								
								
							</div><br/>
						    <hr style="background-color: #eee;"/><br/>
							<div class="info">
								<span style="font-size:1.1em;"><b>[휴대폰으로 결제하신 경우]</b></span><br/>
								<br/>배송료 및 취소시점에 따른 취소수수료 재결제 요청 후, 기존 승인금액은 전체 취소 처리 됩니다.
								<br/>- 원천사(통신사)의 익월 취소불가 정책으로 인해 휴대폰 소액결제의 승인 취소는 예매 당월까지만 가능합니다.
								<br/>익월로 넘어가는 경우 승인 취소가 아닌 환불 처리를 해드립니다.
								<br/>- 통신사 변경, 월 결제 한도 초과로 인한 취소수수료 재결제 불가 등의 경우 환불 처리를 해드립니다.
								<br/>- 원활한 환불 처리를 위하여 마이페이지 > 환불계좌관리에서 환불계좌 정보(본인 명의)를 정확히 입력해 주시기 바랍니다.
								<br/>타인의 계좌를 이용하거나 명의를 도용했을 경우 서비스 이용이 제한될 수 있습니다.
								<br/>예매 취소 하실 경우 휴대폰 결제 수수료도 취소(또는 환불) 됩니다.
							</div><br/>
					    </div>
					</div>
					<br/>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>