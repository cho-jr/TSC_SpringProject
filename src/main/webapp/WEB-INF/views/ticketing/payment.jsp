<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style>
	table tr td {font-size: 1.1em;font-weight: 500;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		var finalPrice = ${vo.price} + ${vo.ticketNum*500};
		$("#finalPrice").html(finalPrice);
		$("#finalPrice").html(finalPrice.toLocaleString('ko-KR'));
		$("#addPoint").html((finalPrice/100).toLocaleString('ko-KR'));
		myform.usePoint.value=0;
		myform.finalPrice.value=finalPrice;
		$("#agreeAll").on("change", function() {
			if($("#agreeAll").is(":checked")) {
				$("#agree2").prop("checked", true);
				$("#agree3").prop("checked", true);
				$("#agree4").prop("checked", true);
			} else {
				$("#agree2").prop("checked", false);
				$("#agree3").prop("checked", false);
				$("#agree4").prop("checked", false);
			}
		});
		
		$(".Pagree").on("change", function() {
			if($("#agree2").is(":checked")&&$("#agree3").is(":checked")&&$("#agree4").is(":checked")){
				$("#agreeAll").prop("checked", true);
			} else {
				$("#agreeAll").prop("checked", false);
			}
		});
		
		// 포인트 변경시
		$("#point").on("change", function() {
			if($("#point").val()<0) {
				alert("포인트는 양수만 입력하세요. ");
				$("#point").val(0);
				$("#usePoint").html("0");
				
				return false;
			}
			if($("#point").val() > ${point}) {
				alert("보유 포인트가 부족합니다. ");
				$("#point").val(0);
			} else if($("#point").val()>${vo.price}+${vo.ticketNum*500}){
				$("#point").val(${vo.price}+${vo.ticketNum*500});
			} else {
				var usePoint = $("#point").val()==""?0:$("#point").val()
				$("#usePoint").html(usePoint.toLocaleString('ko-KR'));	
				myform.usePoint.value=usePoint;
			}
			var finalPrice = ${vo.price} + ${vo.ticketNum*500} -$("#usePoint").html();
			
			$("#finalPrice").html(parseInt(finalPrice).toLocaleString('ko-KR'));
			$("#addPoint").html(Math.floor((finalPrice/100)).toLocaleString('ko-KR'));
			myform.finalPrice.value=finalPrice;
		});
	});
	
	function pointAll() {
		if(${point}>${vo.price}+${vo.ticketNum*500}){
			document.getElementById("point").value = ${vo.price}+${vo.ticketNum*500};
			//$("#usePoint").html(document.getElementById("point").value);
		} else {
			document.getElementById("point").value = ${point};
		}
		$("#usePoint").html(document.getElementById("point").value);
		var finalPrice = ${vo.price} + ${vo.ticketNum*500} -$("#usePoint").html();
		$("#finalPrice").html(parseInt(finalPrice).toLocaleString('ko-KR'));
		$("#addPoint").html(Math.floor((finalPrice/100)).toLocaleString('ko-KR'));
		myform.finalPrice.value=finalPrice;
	}
	function setPayBy(payBy) {
		if(payBy=="card") {
			$(".payBy").removeClass("btn-danger");
			$(".payBy").addClass("btn-outline-danger");
			$("#card").removeClass("btn-outline-danger");
			$("#card").addClass("btn-danger");
			myform.payBy.value = "카드";
			$("#demo").html("");
		}
		if(payBy=="phone") {
			$(".payBy").removeClass("btn-danger");
			$(".payBy").addClass("btn-outline-danger");
			$("#phone").removeClass("btn-outline-danger");
			$("#phone").addClass("btn-danger");
			myform.payBy.value = "휴대폰 결제";
			$("#demo").html("* 결제금액이 통신사 휴대폰 요금에 청구됩니다.<br/>* 월 결제 한도는 최대 50만원입니다.");
		}
		if(payBy=="accountTransfer") {
			$(".payBy").removeClass("btn-danger");
			$(".payBy").addClass("btn-outline-danger");
			$("#accountTransfer").removeClass("btn-outline-danger");
			$("#accountTransfer").addClass("btn-danger");
			myform.payBy.value = "실시간 계좌이체";
			$("#demo").html("* 본인 명의의 은행 계좌를 이용해 결제하실 수 있습니다.<br/>* 은행 점검 시간에는 결제가 불가할 수 있습니다.");
		}
	}
	// 결제처리
	function fCheck() {
		if(myform.payBy.value=="") {
			alert("결제 방식을 선택해주세요");
			return false;
		}
		if($("input:checkbox:checked").length<5){
			alert("약관에 모두 동의해주세요. ");
			return false;
		}
		var ans = confirm(parseInt(myform.finalPrice.value).toLocaleString('ko-KR')+"원이 결제됩니다. 결제하시겠습니까?");
		if(!ans) return false;
		
		myform.submit();
	}
	
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<%@ include file="/WEB-INF/views/include/main/carouselAdv.jsp" %>
			<br/><br/>
			<div style="margin:0 auto"><h2 style="text-align: center;">결제 확인</h2></div>
			<table class="table table-borderless">
				<tr>
					<td style="width:66%;">
						<table class="table table-borderless">
							<tr>
								<td>
									<%-- <img src="${ctp}/${vo.posterFSN}"> --%>
									<table class="table table-bordered" style="border:1px solid gray;">
										<tr><td style="width:30%;">이름</td><td style="width:70%;">${sNick}</td></tr>
										<tr><td>제목</td><td>${vo.performTitle}</td></tr>
										<tr><td>장소</td><td>${vo.performTheater}</td></tr>
										<tr><td>공연일시</td><td>${vo.performSchedule}</td></tr>
										<tr><td>구매좌석/매수</td><td>${vo.performSeat} / ${vo.selectSeatNum}</td></tr>
										<tr>
											<td>포인트 사용</td>
											<td>
												<div class="input-group">
													<input type="number" class="form-control" name="point" id="point" max="${point}" min="0"/>
												    <div class="input-group-append">
												    	<button class="btn btn-outline-danger" type="submit" onclick="pointAll()">전액 사용</button>
												    </div>
												</div>
												<span style="font-size: 1em; color:#777;">보유 포인트: ${point} P</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr></tr>
							<tr>
								<td>
									<div class="input-group mb-3 row" >
										<div class=""></div>
									    <div class="input-group-text ml-4 col-3" style="justify-content: center">
									        <span>결제방식 선택</span>
									    </div>
									    
										<div class="input-group col-7">
											<div class="input-group-prepend">
											    <button class="btn btn-outline-danger payBy" type="button" id="card" onclick="setPayBy('card')">카드</button>
											    <button class="btn btn-outline-danger payBy" type="button" id="phone" onclick="setPayBy('phone')">휴대폰 결제</button>
											</div>
										    <div class="input-group-append" style="border-left-width:0px">
											    <button class="btn btn-outline-danger payBy" type="button" id="accountTransfer" onclick="setPayBy('accountTransfer')">실시간 계좌이체</button>
										    </div>
									    </div>
									</div>
									
									<p id="demo" class="text-muted ml-4">
										
									</p>
								</td>
							</tr>
						</table>
					</td>
					<td style="width:33%;">
						<table class="table table-borderless">
							<tr>
								<td>
									<table class="table table-borderless" style="border:1px solid gray;">
										<tr><td colspan="2"><h3>결제금액</h3></td></tr>
										<tr><td>티켓금액</td><td style="text-align: right;"><fmt:formatNumber value="${vo.price}"/> 원</td></tr>
										<tr><td>예매수수료</td><td style="text-align: right;"><fmt:formatNumber value="${vo.ticketNum*500}"/> 원</td></tr>
										<tr><td>포인트</td><td style="text-align: right;">-<span id="usePoint">0</span> P</td></tr>
										<tr><td colspan="2"><hr/></td></tr>
										<tr>
											<td>총 결제금액</td>
											<td style="text-align: right;"><span id="finalPrice" class="emphasis"></span> 원</td>
										</tr>
										<tr>
											<td>포인트 적립</td>
											<td style="text-align: right;"><span id="addPoint" class="emphasis"></span> P</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="pl-3">
									<div class="custom-control custom-checkbox">
									    <input type="checkbox" class="custom-control-input" id="agree1" name="agree">
									    <label class="custom-control-label" for="agree1">상기 결제 내역을 모두 확인했습니다. </label>
									</div>
									<div class="custom-control custom-checkbox">
									    <input type="checkbox" class="custom-control-input" id="agreeAll">
									    <label class="custom-control-label" for="agreeAll"><b>결제대행서비스 약관에 모두 동의</b></label>
									</div>
									<div class="ml-4 pl-2">
										<input type="checkBox" id="agree2" class="form-check-input Pagree"/>
										전자금융거래 이용약관(<span class="text-primary" data-toggle="modal" data-target="#yakkwan2" style="cursor:pointer;">전문확인</span>)<br/>
										<input type="checkBox" id="agree3" class="form-check-input Pagree"/>
										개인정보 수집 이용약관(<span class="text-primary" data-toggle="modal" data-target="#yakkwan3" style="cursor:pointer;">전문확인</span>)<br/>
										<input type="checkBox" id="agree4" class="form-check-input Pagree"/>
										개인정보 제공 및 위탁 안내 약관(<span class="text-primary" data-toggle="modal" data-target="#yakkwan4" style="cursor:pointer;">전문확인</span>)<br/>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<form name="myform" method="post" action="${ctp}/ticketing/paymentComplete">
									
 										<input type="hidden" name="usePoint" />
										<input type="hidden" name="finalPrice" />
										<input type="hidden" name="payBy" />
										<input type="button" onclick="fCheck()" class="btn btn-danger btn-lg" value="결제" style="float:right;"/>  
									</form>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<div class="modal" id="yakkwan2">
			    <div class="modal-dialog modal-dialog-scrollable">
			        <div class="modal-content">
				        <!-- Modal Header -->
				        <div class="modal-header">
				        	<h4 class="modal-title">[전자금융거래 기본약관]</h4>
				        	<button type="button" class="close" data-dismiss="modal">&times;</button>
				        </div>
				        <!-- Modal body -->
				        <div class="modal-body" style="font-size: 1.1em;line-height: 2em;"><div style="border: 2px solid black;padding:5px;">
							<p>제1조 (목적)</p>
							<p>이 약관은 CJ올리브네트웍스(주)(이하 '회사'라 합니다)가 제공하는 전자지급결제대행서비스를 이용자가 이용함에 있어 회사와 이용자 사이의 전자금융거래에 관한 기본적인 사항을 정함을 목적으로 합니다.</p>
							<br />
							<p>제2조 (용어의 정의)</p>
							<p>이 약관에서 정하는 용어의 정의는 다음과 같습니다.</p>
							<p>1.'전자금융거래'라 함은 회사가 전자적 장치를 통하여 전자지급결제대행서비스 및 결제대금예치서비스(이하 '전자금융거래 서비스'라고 합니다)를 제공하고, 이용자가 회사의 종사자와 직접 대면하거나 의사소통을 하지 아니하고 자동화된 방식으로 이를 이용하는 거래를 말합니다. </p>
							<p>2.'전자지급결제대행서비스'라 함은 전자적 방법으로 재화의 구입 또는 용역의 이용에 있어서 지급결제정보를 송신하거나 수신하는 것 또는 그 대가의 정산을 대행하거나 매개하는 서비스를 말합니다. </p>
							<p>3.'이용자'라 함은 이 약관에 동의하고 회사가 제공하는 전자금융거래 서비스를 이용하는 자를 말합니다. </p>
							<p>4.'접근매체'라 함은 전자금융거래에 있어서 거래지시를 하거나 이용자 및 거래내용의 진실성과 정확성을 확보하기 위하여 사용되는 수단 또는 정보로서 전자식 카드 및 이에 준하는 전자적 정보(신용카드번호를 포함한다), '전자서명법'상의 인증서, 회사에 등록된 이용자번호, 이용자의 생체정보, 이상의 수단이나 정보를 사용하는데 필요한 비밀번호 등 전자금융거래법 제2조 제10호에서 정하고 있는 것을 말합니다. </p>
							<p>5.'거래지시'라 함은 이용자가 본 약관에 의하여 체결되는 전자금융거래계약에 따라 회사에 대하여 전자금융거래의 처리를 지시하는 것을 말합니다. </p>
							<p>6.'오류'라 함은 이용자의 고의 또는 과실 없이 전자금융거래가 전자금융거래계약 또는 이용자의 거래지시에 따라 이행되지 아니한 경우를 말합니다.</p>
							<br />
							<p>제3조 (약관의 명시 및 변경)</p>
							<p>1. 회사는 이용자가 전자금융거래 서비스를 이용하기 전에 이 약관을 게시하고 이용자가 이 약관의 중요한 내용을 확인할 수 있도록 합니다. </p>
							<p>2. 회사는 이용자의 요청이 있는 경우 전자문서의 전송방식에 의하여 본 약관의 사본을 이용자에게 교부합니다. </p>
							<p>3. 회사가 약관을 변경하는 때에는 그 시행일 1개월 전에 변경되는 약관을 회사가 제공하는 전자금융거래 서비스 이용 초기화면 및 회사의 홈페이지에 게시함으로써 이용자에게 공지합니다. </p>
							<br />
							<p>제4조 (전자지급결제대행서비스의 종류)</p>
							<p>회사가 제공하는 전자지급결제대행서비스는 지급결제수단에 따라 다음과 같이 구별됩니다. </p>
							<p>1. 신용카드결제대행서비스: 이용자가 결제대금의 지급을 위하여 제공한 지급결제수단이 신용카드인 경우로, 회사가 전자결제시스템을 통하여 신용카드 지불정보를 송,수신하고 결제대금의 정산을 대행하거나 매개하는 서비스를 말합니다. </p>
							<p>2. 계좌이체대행서비스: 이용자가 결제대금을 회사의 전자결제시스템을 통하여 금융기관에 등록한 자신의 계좌에서 출금하여 원하는 계좌로 이체할 수 있는 실시간 송금 서비스를 말합니다. </p>
							<p>3. 가상계좌서비스: 이용자가 결제대금을 현금으로 결제하고자 하는 경우 회사의 전자결제시스템을 통하여 자동으로 이용자만의 고유한 일회용 계좌의 발급을 통하여 결제대금의 지급이 이루어지는 서비스를 말합니다. </p>
							<p>4. 기타: 회사가 제공하는 서비스로서 지급결제수단의 종류에 따라 '휴대폰 결제대행서비스', 'ARS결제대행서비스', '상품권결제대행서비스'등이 있습니다. </p>
							<br />
							<p>제5조 (이용시간)</p>
							<p>1. 회사는 이용자에게 연중무휴 1일 24시간 전자금융거래 서비스를 제공함을 원칙으로 합니다. 단, 금융기관 및 기타 결제수단 발행업자의 사정에 따라 달리 정할 수 있습니다. </p>
							<p>2. 회사는 정보통신설비의 보수, 점검 기타 기술상의 필요나 금융기관 기타 결제수단 발행업자의 사정에 의하여 서비스 중단이 불가피한 경우, 서비스 중단 3일 전까지 게시가능한 전자적 수단을 통하여 서비스 중단 사실을 게시한 후 서비스를 일시 중단할 수 있습니다. 다만, 시스템 장애복구, 긴급한 프로그램 보수, 외부요인 등 불가피한 경우에는 사전 게시 없이 서비스를 중단할 수 있습니다. </p>
							<br />
							<p>제6조 (접근매체의 선정과 사용 및 관리)</p>
							<p>1. 회사는 전자금융거래 서비스 제공 시 접근매체를 선정하여 이용자의 신원, 권한 및 거래지시의 내용 등을 확인할 수 있습니다. </p>
							<p>2. 이용자는 접근매체를 제3자에게 대여하거나 사용을 위임하거나 양도 또는 담보 목적으로 제공할 수 없습니다. </p>
							<p>3. 이용자는 자신의 접근매체를 제3자에게 누설 또는 노출하거나 방치하여서는 안되며, 접근매체의 도용이나 위조 또는 변조를 방지하기 위하여 충분한 주의를 기울여야 합니다. </p>
							<p>4. 회사는 이용자로부터 접근매체의 분실이나 도난 등의 통지를 받은 때에는 그 때부터 제3자가 그 접근매체를 사용함으로 인하여 이용자에게 발생한 손해를 배상할 책임이 있습니다. </p>
							<br />
							<p>제7조 (거래내용의 확인)</p>
							<p>1. 회사는 이용자와 미리 약정한 전자적 방법을 통하여 이용자의 거래내용(이용자의 '오류정정 요구사실 및 처리결과에 관한 사항'을 포함합니다)을 확인할 수 있도록 하며, 이용자의 요청이 있는 경우에는 요청을 받은 날로부터 2주 이내에 모사전송 등의 방법으로 거래내용에 관한 서면을 교부합니다. </p>
							<p>2. 회사가 이용자에게 제공하는 거래내용 중 거래계좌의 명칭 또는 번호, 거래의 종류 및 금액, 거래상대방을 나타내는 정보, 거래일자, 전자적 장치의 종류 및 전자적 장치를 식별할 수 있는 정보와 해당 전자금융거래와 관련한 전자적 장치의 접속기록은 5년간, 건당 거래금액이 1만원 이하인 소액 전자금융거래에 관한 기록, 전자지급수단 이용시 거래승인에 관한 기록, 이용자의 오류정정 요구사실 및 처리결과에 관한 사항은 1년간의 기간을 대상으로 합니다. </p>
							<p>3. 이용자가 제1항에서 정한 서면교부를 요청하고자 할 경우 다음의 주소 및 전화번호로 요청할 수 있습니다. </p>
							<p>o- 주소 : 서울특별시 용산구 한강대로 366(동자동) 트윈시티 10층</p>
							<p>o- 전화번호 : 02-6252-0000</p>
							<p>o- 팩스번호 : 02-6252-0098</p>
							<p>o- 이메일주소 : pgadmin@cj.net</p>
							<br />
							<p>제8조 (오류의 정정 등)</p>
							<p>1. 이용자는 전자금융거래 서비스를 이용함에 있어 오류가 있음을 안 때에는 회사에 대하여 그 정정을 요구할 수 있습니다. </p>
							<p>2. 회사는 전항의 규정에 따른 오류의 정정요구를 받은 때에는 이를 즉시 조사하여 처리한 후 정정요구를 받은 날부터 2주 이내에 그 결과를 이용자에게 알려 드립니다. </p>
							<br />
							<p>제9조 (회사의 책임)</p>
							<p>1. 접근매체의 위조나 변조로 발생한 사고로 인하여 이용자에게 발생한 손해에 대하여 배상책임이 있습니다. 다만 이용자가 제6조 제2항에 위반하거나 제3자가 권한 없이 이용자의 접근매체를 이용하여 전자금융거래를 할 수 있음을 알았거나 알 수 있었음에도 불구하고 이용자가 자신의 접근매체를 누설 또는 노출하거나 방치한 경우 그 책임의 전부 또는 일부를 이용자가 부담하게 할 수 있습니다.</p>
							<p>2. 회사는 계약체결 또는 거래지시의 전자적 전송이나 처리과정에서 발생한 사고로 인하여 이용자에게 그 손해가 발생한 경우에는 그 손해를 배상할 책임이 있습니다. 다만 본 조 제1항 단서에 해당하거나 법인('중소기업기본법' 제2조 제2항에 의한 소기업을 제외합니다)인 이용자에게 손해가 발생한 경우로서 회사가 사고를 방지하기 위하여 보안절차를 수립하고 이를 철저히 준수하는 등 합리적으로 요구되는 충분한 주의의무를 다한 경우 그 책임의 전부 또는 일부를 이용자가 부담하게 할 수 있습니다. </p>
							<p>3. 회사는 이용자로부터의 거래지시가 있음에도 불구하고 천재지변, 회사의 귀책사유가 없는 정전, 화재, 통신장애 기타의 불가항력적인 사유로 처리 불가능하거나 지연된 경우로서 이용자에게 처리 불가능 또는 지연사유를 통지한 경우(금융기관 또는 결제수단 발행업체나 통신판매업자가 통지한 경우를 포함합니다)에는 이용자에 대하여 이로 인한 책임을 지지 아니합니다.</p>
							<p>4. 회사는 전자금융거래를 위한 전자적 장치 또는 ‘정보통신망 이용촉진 및 정보보호 등에 관한 법률’ 제2조제1항제1호에 따른 정보통신망에 침입하여 거짓이나 그 밖의 부정한 방법으로 획득한 접근매체의 이용으로 발생한 사고로 인하여 이용자에게 그 손해가 발생한 경우에는 그 손해를 배상할 책임이 있습니다. </p>
							<br />
							<p>제10조 (전자지급거래계약의 효력)</p>
							<p>1. 회사는 이용자의 거래지시가 전자지급거래에 관한 경우 그 지급절차를 대행하며, 전자지급거래에 관한 거래지시의 내용을 전송하여 지급이 이루어지도록 합니다. </p>
							<p>2. 회사는 이용자의 전자지급거래에 관한 거래지시에 따라 지급거래가 이루어지지 않은 경우 수령한 자금을 이용자에게 반환하여야 합니다. </p>
							<br />
							<p>제11조 (거래지시의 철회)</p>
							<p>1. 이용자는 전자지급거래에 관한 거래지시의 경우 지급의 효력이 발생하기 전까지 거래지시를 철회할 수 있습니다. </p>
							<p>2 .전항의 지급의 효력이 발생 시점이란 (i) 전자자금이체의 경우에는 거래지시된 금액의 정보에 대하여 수취인의 계좌가 개설되어 있는 금융기관의 계좌 원장에 입금기록이 끝난 때 (ii) 그 밖의 전자지급수단으로 지급하는 경우에는 거래지시된 금액의 정보가 수취인의 계좌가 개설되어 있는 금융기관의 전자적 장치에 입력이 끝난 때를 말합니다. </p>
							<p>3. 이용자는 지급의 효력이 발생한 경우에는 전자상거래 등에서의 소비자보호에 관한 법률 등 관련 법령상 청약의 철회의 방법에 따라 결제대금을 반환 받을 수 있습니다. </p>
							<br />
							<p>제12조 (전자지급결제대행 서비스 이용 기록의 생성 및 보존)</p>
							<p>1. 회사는 이용자가 전자금융거래의 내용을 추적, 검색하거나 그 내용에 오류가 발생한 경우에 이를 확인하거나 정정할 수 있는 기록을 생성하여 보존합니다. </p>
							<p>2. 전항의 규정에 따라 회사가 보존하여야 하는 기록의 종류 및 보존방법은 제7조 제2항에서 정한 바에 따릅니다. </p>
							<br />
							<p>제 13조 (전자금융거래정보의 제공금지) </p>
							<p>회사는 전자금융거래 서비스를 제공함에 있어서 취득한 이용자의 인적사항, 이용자의 계좌, 접근매체 및 전자금융거래의 내용과 실적에 관한 정보 또는 자료를 이용자의 동의를 얻지 아니하고 제3자에게 제공, 누설하거나 업무상 목적 외에 사용하지 아니합니다. </p>
							<br />
							<p>제 14조 (분쟁처리 및 분쟁조정) </p>
							<p>1. 이용자는 다음의 분쟁처리 책임자 및 담당자에 대하여 전자금융거래 서비스 이용과 관련한 의견 및 불만의 제기, 손해배상의 청구 등의 분쟁처리를 요구할 수 있습니다. </p>
							<p>담당자: 통신과금서비스 담당부서장</p>
							<p>연락처(전화번호 02-6252-0000, 전자우편주소 pgadmin@cj.net, FAX 02-6252-0098)</p>
							<br />
							<p>2. 이용자가 회사에 대하여 분쟁처리를 신청한 경우에는 회사는 15일 이내에 이에 대한 조사 또는 처리 결과를 이용자에게 안내합니다. </p>
							<br />
							<p>3. 이용자는 '금융감독기구의 설치 등에 관한 법률' 제51조의 규정에 따른 금융감독원의 금융분쟁조정위원회나 '소비자보호법' 제31조 제1항의 규정에 따른 소비자보호원에 회사의 전자금융거래 서비스의 이용과 관련한 분쟁조정을 신청할 수 있습니다. </p>
							<br />
							<p>제 15조 (회사의 안정성 확보 의무) </p>
							<br />
							<p>1. 회사는 전자금융거래의 안전성과 신뢰성을 확보할 수 있도록 전자금융거래의 종류별로 전자적 전송이나 처리를 위한 인력, 시설, 전자적 장치 등의 정보기술부문 및 전자금융업무에 관하여 금융감독위원회가 정하는 기준을 준수합니다. </p>
							<br />
							<p>제 16조 (약관 외 준칙 및 관할) </p>
							<br />
							<p>1. 이 약관에서 정하지 아니한 사항에 대하여는 전자금융거래법, 전자상거래 등에서의 소비자 보호에 관한 법률, 통신판매에 관한 법률, 여신전문금융업법 등 소비자보호 관련 법령에서 정한 바에 따릅니다. </p>
							<br />
							<p>2. 회사와 이용자간에 발생한 분쟁에 관한 관할은 민사소송법에서 정한 바에 따릅니다. </p>
							<br />
							<p>부칙 < 제 1 호, 2006.12.26. > </p>
							<br />
							<p>본 약관은 2007년 1월 1일부터 시행한다. </p>
							<br />
							<p>부칙 < 제 2 호, 2011.05.02.> </p>
							<br />
							<p>본 약관은 2011년 06월 20일부터 시행한다. </p>
							<p>(제 8조 2항 일부 개정)</p>
							<br />
							<p>부칙 < 제 3 호, 2014.11.25. > </p>
							<br />
							<p>본 약관은 2014년 12월 2일부터 시행한다.</p>
							<br />
							<p>부칙 < 제 4 호, 2017.9.21> </p>
							<br />
							<p>본 약관은 2017년 10월 12일부터 시행한다.	</p>
				        </div></div>
				        <!-- Modal footer -->
				        <div class="modal-footer">
				       		<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				        </div>
				    </div>
			    </div>
			</div>
			<div class="modal" id="yakkwan3">
			    <div class="modal-dialog modal-dialog-scrollable">
			        <div class="modal-content">
				        <!-- Modal Header -->
				        <div class="modal-header">
				        	<h4 class="modal-title">[개인정보의 수집 및 이용에 대한 동의]</h4>
				        	<button type="button" class="close" data-dismiss="modal">&times;</button>
				        </div>
				        <!-- Modal body -->
				        <div class="modal-body" style="font-size: 1.1em;line-height: 2em;"><div style="border: 2px solid black;padding:5px;">
				        	<p>CJ올리브네트웍스㈜(이하 '회사')는 이용자의 개인정보를 중요시하며, 『전자금융거래법』, 『개인정보보호법』, 『정보통신망 이용촉진 및 정보보호 등에 관한 법률』, 『전자상거래 등에서의 소비자보호에 관한 법률』, 『특정금융거래정보의 보고 및 이용 등에 관한 법률』 등을 준수하며 관련 법령에 의거한 개인정보처리방침을 정하여 이용자 권익을 보호하고 있습니다.</p><br /><br />
							<p>1. 회사는 전자금융거래서비스를 제공함에 있어서 취득한 정보를 이용자의 동의를 얻지 않고 제3자에게 제공, 누설하거나 업무상 목적 외에 사용하지 않습니다. 다만, 업무상 이용자 정보를 제3자에게 위탁할 경우 홈페이지(www.cjolivenetworks.co.kr)을 통해 이용자에게 고지합니다.</p><br />
							<p>2. 수집하는 개인정보 항목</p>
							<p>회사는 전자금융업자로서 고객 확인 및 검증, 결제내역 조회, 고객상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.</p><br />
							
							<p>[필수항목]</p><br />
							
							<p>신원 확인 및 고객 검증을 위한 수집 정보</p>
							<ul>
							<li>· 개인 및 개인사업자 : 고객ID, 이용자의 이름, 생년월일, 성별, 실명번호, 주소, 연락처</li>
							<li>· 영리법인의 경우 : 실지명의, 업종, 본점 및 사업장의 소재지, 연락처, 대표자의 성명, 생년월일 및 국적</li>
							<li>· 비영리법인 그 밖의 단체의 경우 : 실지명의, 설립목적, 주된 사무소의 소재지, 연락처, 대표자의 성명, 생년월일 및 국적</li>
							<li>· 외국인 및 외국단체의 경우 : 제1호 내지 제3호의 규정에 의한 분류에 따른 각 해당 사항, 국적, 국내의 거소 또는 사무소의 소재지</li>
							</ul><br />
							
							<p>고위험 거래 대상으로 분류 시 개인정보 추가 수집 내역</p>
							<ul>
							<li>· 개인 : 직업 또는 업종(개인사업자), 거래의 목적, 거래자금의 원천, 기타 자금세탁 우려를 해소하기 위해 필요하다고 판단한 사항으로 회사가 별도 고지한 정보유형</li>
							<li>· 법인 : 회사에 관한 기본정보(법인정보, 상장정보, 사업체 설립일, 홈페이지/이메일 등) 거래자금의 원천, 거래의 목적, 기타 자금세탁 우려를 해소하기 위해 필요하다고 판단한 사항으로 회사가 별도 고지한 정보유형</li>
							</ul><br />
							
							<p>결제내역 조회, 고객상담, 서비스 신청 등을 위한 수집 정보</p>
							<ul>
							<li>· 신용카드 : 카드번호, 유효기간 (결제방식에 따라 수집정보가 상이할 수 있습니다.)</li>
							<li>· 휴대전화 : 통신사명, 휴대전화번호</li>
							<li>· 계좌이체 : 은행명, 계좌번호</li>
							<li>· 가상계좌 : 은행명, 입금자명 (환불시, 추가로 은행명, 계좌번호, 예금주 정보를 수집합니다.)</li>
							<li>· ARS폰빌 : 유선전화번호</li>
							<li>· 문화상품권 : 컬처랜드 아이디</li>
							<li>· 도서문화상품권 : 북앤라이프 아이디</li>
							<li>· 현금영수증 : 고유식별정보 또는 휴대폰번호 또는 카드번호</li>
							<li>· 슈가페이 : 이용자ID, CI, 카드번호</li>
							</ul><br />
							<p>※ 서비스 이용과정중에서 아래와 같은 정보들이 자동으로 생성되어 수집됩니다.</p>
							<p>(IP Address, 서비스접속일시)</p><br />
							
							<p>3. 개인정보 수집방법</p>
							<ul>
							<li>· 회사의 결제서비스 이용 시</li>
							<li>· 결제내역 조회 및 고객 응대 입력 시</li>
							</ul><br />
							
							<p>4. 개인정보의 수집 및 이용목적</p>
							<p>회사가 이용자의 개인정보를 수집, 이용하는 목적은 아래와 같습니다.</p><br />
							<ul>
							<li>1) 이용자가 구매한 재화나 용역의 대금 결제</li>
							<li>2) 이용자가 결제한 거래의 취소 또는 환불</li>
							<li>3) 이용자가 결제한 거래의 청구 및 수납</li>
							<li>4) 이용자가 수납한 거래 대금의 정산</li>
							<li>5) 이용자가 결제한 거래의 내역을 요청하는 경우 응대 및 확인</li>
							<li>6) 통신과금서비스 이용이 불가능한 이용자와 불량, 불법 이용자의 부정 이용 방지</li>
							<li>7) 특정금융거래정보의 보고 및 이용 등에 관한 법률 제5조의2 및 동법 시행령 제10조의4에 따른 고객확인의무 이행 및 의심거래 보고</li>
							</ul><br />
							
							<p>5. 개인정보의 보유 및 이용기간</p>
							<p>회사가 이용자의 개인정보를 수집, 이용하는 목적은 아래와 같습니다. 회사는 개인정보 수집 및 이용목적이 달성된 후에는 예외 및 지체 없이 해당 정보를 파기합니다. 단, 『개인정보보호법』 및 『정보통신망 이용촉진 및 정보보호 등에 관한 법률』 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 아래와 같이 법령에서 정한 일정한 기간 동안 보관합니다.</p><br />
							
							<div style="font-size:13px;">
							<p>· 계약 또는 청약철회 등에 관한 기록</p>
							<p style="padding-left: 12px;">보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</p>
							<p style="padding-left: 12px; font-weight: bolder;">보존 기간 : 5년</p>
							<p>· 대금결제 및 재화 등의 공급에 관한 기록</p>
							<p style="padding-left: 12px;">보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</p>
							<p style="padding-left: 12px; font-weight: bolder;">보존 기간 : 5년</p>
							<p>· 전자금융 거래에 관한 기록</p>
							<p style="padding-left: 12px;">보존 이유 : 전자금융거래법</p>
							<p style="padding-left: 12px; font-weight: bolder;">보존 기간 : 5년</p>
							<p>· 소비자의 불만 또는 분쟁처리에 관한 기록</p>
							<p style="padding-left: 12px;">보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률</p>
							<p style="padding-left: 12px; font-weight: bolder;">보존 기간 : 3년</p>
							<p>· 웹사이트 방문기록</p>
							<p style="padding-left: 12px;">보존 이유 : 통신비밀보호법</p>
							<p style="padding-left: 12px; font-weight: bolder;">보존 기간 : 3개월</p>
							<p>· 신원 확인 및 고객 검증 등을 위한 기록</p>
							<p style="padding-left: 12px;">보존 이유 : 특정금융거래정보의 보고 및 이용 등에 관한 법률 및 동법 시행령</p>
							<p style="padding-left: 12px; font-weight: bolder;">보존 기간 : 5년</p>
							</div>
							<br />
							
							<p>6. 개인정보의 파기절차 및 방법</p>
							<p>회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.</p>
							<p>· 파기절차</p>
							<p>회원님이 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 데이터베이스(DB)로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(5. 보유 및 이용기간 참조) 일정 기간 저장된 후 파기됩니다.</p>
							<p>별도 DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다.</p>
							<p>· 파기방법</p>
							<p>전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.</p>
				        </div></div>
				        <!-- Modal footer -->
				        <div class="modal-footer">
				       		<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				        </div>
				    </div>
			    </div>
			</div>
			<div class="modal" id="yakkwan4">
			    <div class="modal-dialog modal-dialog-scrollable">
			        <div class="modal-content">
				        <!-- Modal Header -->
				        <div class="modal-header">
				        	<h4 class="modal-title">[개인정보의 제3자 제공 동의]</h4>
				        	<button type="button" class="close" data-dismiss="modal">&times;</button>
				        </div>
				        <!-- Modal body -->
				        <div class="modal-body" style="font-size: 1.1em;line-height: 2em;"><div style="border: 2px solid black;padding:5px;">
							<p>1. CJ올리브네트웍스㈜(이하 '회사')는 이용자의 개인정보를 본 개인정보처리방침에서 고지한 범위 내에서 사용하며, 이용자의 사전 동의 없이 동 범위를 초과하여 이용하거나 이용자의 개인 정보를 제3자에게 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.</p>
							<ul>
							<li>· 이용자가 사전에 동의한 경우</li>
							<li>· 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
							</ul><br />
							
							<p>2. 회사의 서비스 이행을 위하여 개인정보를 제3자에게 제공하고 있는 경우는 다음과 같습니다.</p><br />
							
							<p>1) 제공 목적 : 신용카드 결제</p>
							<p>- 제공 받는 자</p>
							<ul>
							<li>· 카드사: 국민, 비씨, 롯데, 삼성, NH농협, 현대, KEB하나, 신한</li>
							<li>· 은행: 신한, SC제일, 씨티, KEB하나, 농협, 기업, 국민, 대구, 부산, 경남, 우리</li>
							<li>· 부가통신사업자(VAN사): 파이서브코리아, 한국정보통신(KICC), KIS정보통신, ㈜코밴, NICE정보통신, VP(주)</li>
							<li>· 전자지급결제대행업자:KG이니시스</li>
							</ul>
							<p>-제공 정보</p>
							<p>· 결제정보 (비씨카드: IP포함)</p>
							<p>-보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
							
							<p>2) 제공 목적 : 간편결제</p>
							<p>- 제공 받는 자</p>
							<ul>
							<li>· 카카오페이: ㈜카카오페이</li>
							<li>· 페이코: NHN페이코㈜</li>
							<li>· 페이나우: LG유플러스</li>
							<li>· 스마일페이: LG CNS, ㈜이베이코리아</li>
							<li>· 네이버페이: 네이버파이낸셜㈜</li>
							<li>· 슈가페이: NICE정보통신</li>
							<li>· 토스: ㈜비바리퍼블리카</li>
							<li>· 내통장: 세틀뱅크㈜</li>
							<li>· 차이: ㈜차이코퍼레이션</li>
							<li>· 페이코인: ㈜다날</li>
							</ul>
							<p>- 제공 정보</p>
							<p>· 결제정보 (슈가페이: CI, 이용자ID 포함)</p>
							<p>- 보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
							
							<p>3) 제공 목적 : 계좌이체 결제</p>
							<p>- 제공받는 자</p>
							<ul>
							<li>· 은행: 기업, 국민, KEB하나, 수협, 농협, 우리, SC제일, 씨티, 대구, 부산, 광주, 제주, 전북, 경남, 새마을금고, 신협, 우체국, 신한, 산림조합, 산업</li>
							<li>· 증권: 유안타, 현대, 미래에셋, 한투, 우리투자, 하이투자, HMC투자, SK, 대신, 하나대투, 신한금융, 동부, 유진투자, 메리츠, 신영, 삼성, 한화, 대우</li>
							<li>· 금융결제원, LG유플러스</li>
							<li>· CMS 계좌이체: 효성에프엠에스</li>
							</ul>
							<p>- 제공 정보</p>
							<p>· 결제정보</p>
							<p>-보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
							
							<p>4) 제공 목적 : 가상계좌 결제</p>
							<p>- 제공받는 자</p>
							<ul>
							<li>· 은행: 기업, 국민, KEB하나, 수협, 농협, 우리, SC제일, 신한, 부산, 광주, 우체국</li>
							<li>· LG유플러스, 세틀뱅크 </li>
							</ul>
							<p>- 제공 정보</p>
							<p>· 결제정보</p>
							<p>-보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
							
							<p>5) 제공 목적 : 휴대폰 결제</p>
							<p>-제공받는 자</p>
							<ul>
							<li>· 이동통신사: (주)SKT, ㈜KT, ㈜LGU+, MVNO사업자</li>
							<li>· ㈜모빌리언스, 갤럭시아머니트리㈜, ㈜다날</li>
							</ul>
							<p>-제공 정보</p>
							<p>· 결제정보, 휴대폰번호</p>
							<p>-보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
							
							<p>6) 제공 목적 : 포인트 결제</p>
							<p>-제공받는 자</p>
							<ul>
							<li>· OK캐쉬백: SK마케팅앤컴퍼니㈜ </li>
							<li>· 에코마일리지: BC카드, 서울시 </li>
							</ul>
							<p>-제공 정보㈜ </p>
							<p>· 결제정보</p>
							<p>-보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
							
							<p>7) 제공 목적 : 상품권 결제</p>
							<p>-제공받는 자</p>
							<ul>
							<li>· 해피머니상품권: 해피머니아이엔씨</li>
							<li>· 도서문화상품권: 북앤라이프</li>
							<li>· 문화상품권: 컬쳐랜드</li>
							</ul>
							<p>-제공 정보</p>
							<p>· 결제정보 (컬쳐랜드, 해피머니아이엔씨 : IP포함)</p>
							<p>-보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
							
							<p>8) 제공 목적 : 현금영수증 발행</p>
							<p>-제공받는 자</p>
							<p>· 국세청</p>
							<p>-제공 정보</p>
							<p>· 결제정보, 고유식별정보, 휴대폰번호, 카드번호</p>
							<p>-보유 및 이용기간</p>
							<p>· 개인정보는 원칙적으로 개인 정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다</p>
							<p>(단, 다른 법령에 특별한 규정이 있을 경우 관련 법령에 따라 보관)</p><br />
				        </div></div>
				        <!-- Modal footer -->
				        <div class="modal-footer">
				       		<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				        </div>
				    </div>
			    </div>
			</div>
		</div>
	</section>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>