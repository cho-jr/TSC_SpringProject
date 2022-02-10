package com.spring.cjs2108_cjr;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.cjs2108_cjr.service.MemberService;
import com.spring.cjs2108_cjr.service.PerformService;
import com.spring.cjs2108_cjr.service.TicketingService;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.MemberVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

@Controller
@RequestMapping("/ticketing")
public class TicketingController {
	@Autowired
	TicketingService ticketingService;
	
	@Autowired
	PerformService performService;
	
	@Autowired
	MemberService memberService;
	
	// 예매페이지 띄우기
	@RequestMapping(value="/ticketing", method = RequestMethod.GET)
	public String ticketingGet(Model model,
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "ticketSales", required = false) String orderBy,
			@RequestParam(name = "condition", defaultValue = "proceeding", required = false) String condition
			) {
		
		int totRecCnt = performService.getPerformCnt(keyWord, condition);
		
		// 공연 리스트		
		List<PerformVO> performVos = performService.getPerformList(keyWord, condition, orderBy, 0, totRecCnt);
		performVos.addAll(performService.getPerformList(keyWord, "comingsoon", orderBy, 0, totRecCnt));

		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO CAVo1 = performService.getCardAdv();
		AdvertiseVO CAVo2 = performService.getCardAdv();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("CAVo1", CAVo1);
		model.addAttribute("CAVo2", CAVo2);
		
		model.addAttribute("performVos", performVos);
		return "ticketing/ticketing";
	}
	
	// 작품상세 -> 예매페이지 띄우기
	@RequestMapping(value="/ticketing", method = RequestMethod.POST)
	public String ticketingPost(Model model,
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "ticketSales", required = false) String orderBy,
			@RequestParam(name = "condition", defaultValue = "proceeding", required = false) String condition,
			@RequestParam(name = "scheduleIdx", defaultValue = "0", required = false) String scheduleIdx
			) {
		int totRecCnt = performService.getPerformCnt(keyWord, condition);
		List<PerformVO> performVos = performService.getPerformList(keyWord, condition, orderBy, 0, totRecCnt);
		performVos.addAll(performService.getPerformList(keyWord, "comingsoon", orderBy, 0, totRecCnt));
		PerformScheduleVO scheduleVo = performService.getPerformScheduleByIdx(Integer.parseInt(scheduleIdx));
		List<PerformScheduleVO> scheduleVos = performService.getPerformScheduleList(scheduleVo.getPerformIdx());
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO CAVo1 = performService.getCardAdv();
		AdvertiseVO CAVo2 = performService.getCardAdv();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("CAVo1", CAVo1);
		model.addAttribute("CAVo2", CAVo2);
		model.addAttribute("performVos", performVos);
		model.addAttribute("scheduleVo", scheduleVo);
		model.addAttribute("scheduleVos", scheduleVos);
		return "ticketing/ticketing";
	}

	// 결제 창 띄우기 (세션-> 결제)
	@RequestMapping(value="/payment", method = RequestMethod.GET)
	public String paymentGet(HttpSession session, Model model) {
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		model.addAttribute("BAVos", BAVos);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		TicketingVO vo = (TicketingVO) session.getAttribute("sTicketingVO");
		if(vo != null) {
			MemberVO memberVo = memberService.getMemberVOByNickName((String)session.getAttribute("sNick"));
			model.addAttribute("point", memberVo.getPoint());
			
			model.addAttribute("vo", vo);
			return "ticketing/payment";
		} else return "redirect:/ticketing/ticketing";
	}
	
	// 결제 창 띄우기 (선택 -> 결제)
	@RequestMapping(value="/payment", method = RequestMethod.POST)
	public String paymentPost(HttpSession session, Model model, TicketingVO vo) {
		MemberVO memberVo = memberService.getMemberVOByNickName((String)session.getAttribute("sNick"));
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		model.addAttribute("BAVos", BAVos);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		// 결제 창으로 이동
		session.setAttribute("sTicketingVO", vo);
		model.addAttribute("point", memberVo.getPoint());
		model.addAttribute("vo", vo);
		return "ticketing/payment";
	}

	// 예매처리 완료
	@RequestMapping(value="/paymentComplete", method = RequestMethod.POST)
	public String paymentCompletePost(HttpSession session, TicketingVO vo) {
		String nick = (String) session.getAttribute("sNick");
		TicketingVO ticketingVO = (TicketingVO) session.getAttribute("sTicketingVO");
		ticketingVO.setUsePoint(vo.getUsePoint());
		ticketingVO.setFinalPrice(vo.getFinalPrice());
		ticketingVO.setPayBy(vo.getPayBy());
		int seatNum = 0;
		String[] seatNums = ticketingVO.getSelectSeatNum().split(",");
		for(int i = 0; i< seatNums.length; i++) {
			seatNum += Integer.parseInt(seatNums[i]);
		}
		ticketingVO.setTicketNum(seatNum);
		
		// 예매내역 ticketing 테이블에 저장
		ticketingService.registTicketing(ticketingVO);
		session.removeAttribute("sTicketingVO");
		
		// 결제금액의 1% 포인트 적립, 사용 포인트 차감
		memberService.earnPoints(nick, ticketingVO.getFinalPrice()/100 - vo.getUsePoint());
		
		// 작품 예매수 증가
		performService.increaseTicketSales(ticketingVO.getPerformIdx());
		
		// qr코드 생성
		String uploadPath = session.getServletContext().getRealPath("/resources/images/QRTicket/");
		int ticketIdx = ticketingService.getTicketIdx(nick)==null ? 0 : ticketingService.getTicketIdx(nick);
		// 변경 해야돼ㅐㅐㅐ 서버 주소
		String url = "http://218.236.203.146:9090/cjs2108_cjr/main/ticketInfo?idx="+ticketIdx;
		String barCodeName = ticketingService.createQRCode(
				nick, ticketIdx, uploadPath, url);
		
		return "redirect:/msg/ticketingOk";
	}
	
	// 선택한 공연 일정 리스트
	@ResponseBody
	@RequestMapping(value="/getPerformScheduleList", method = RequestMethod.POST)
	public String getPerformScheduleListPost(int performIdx) {
		List<PerformScheduleVO> vos = performService.getPerformScheduleList(performIdx);
		return vos.toString();
	}
	
//	// qr 코드 상세 정보
//	@RequestMapping(value = "/ticketInfo", method = RequestMethod.GET)
//	public String ticketInfoGet(int idx, Model model) {
//		TicketingVO ticketVo = ticketingService.getTicketInfo(idx);
//		PerformVO performVo = performService.getPerformInfo(ticketVo.getPerformIdx());
//		PerformScheduleVO scheduleVo = performService.getPerformScheduleByIdx(ticketVo.getPerformScheduleIdx());
//		//String QRCode = ticketingService.getQR(idx);
//		model.addAttribute("ticketVo", ticketVo);
//		model.addAttribute("performVo", performVo);
//		model.addAttribute("scheduleVo", scheduleVo);
//		//model.addAttribute("QRCode", QRCode);
//		return "ticketing/ticketInfo";
//	}
	
}
