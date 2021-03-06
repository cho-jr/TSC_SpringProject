package com.spring.cjs2108_cjr;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_cjr.pagination.PagingVO;
import com.spring.cjs2108_cjr.service.MemberService;
import com.spring.cjs2108_cjr.service.PerformService;
import com.spring.cjs2108_cjr.service.TicketingService;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.MemberVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;
import com.spring.cjs2108_cjr.vo.TheaterVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	String msgFlag = "";
	
	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	MemberService memberService;

	@Autowired
	TicketingService ticketingService;
	
	@Autowired
	PerformService performService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	// ????????? ??? ?????????
	@RequestMapping(value="/login", method = RequestMethod.GET)
	public String loginGet(HttpServletRequest request, Model model) {
		Cookie[] cookies = request.getCookies();	
		String email = "";
		for(int i=0; i<cookies.length; i++) {
			if(cookies[i].getName().equals("cEmail")) {
				email = cookies[i].getValue();
				request.setAttribute("email", email);
			}
			if(cookies[i].getName().equals("cSaveId")) {
				email = cookies[i].getValue();
				request.setAttribute("checked", "checked");
			}
		}
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		return "member/login";
	}
	// ????????? ??????
	@RequestMapping(value="/login", method = RequestMethod.POST)
	public String loginPost(String email, String pwd, boolean saveId, Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		MemberVO vo = memberService.getMemberVO(email);
		if(vo != null && passwordEncoder.matches(pwd, vo.getPwd())) {
			memberService.updateLastDate(email);
			// ????????? ????????? ????????? ????????? ????????? ???????????? ????????? ??????(ex ????????? ?????? ?????????)
			
			setLoginCookies(email, saveId, request, response);
			
			session.setAttribute("sNick", vo.getNick());
			session.setAttribute("sLevel", vo.getLevel());
			return "redirect:/msg/loginOk";
		} else {			
			return "redirect:/msg/loginNo";
		}
		
	}
	private void setLoginCookies(String email, boolean saveId, HttpServletRequest request,
			HttpServletResponse response) {
		if(saveId) {
			Cookie cookieEmail = new Cookie("cEmail", email);
			cookieEmail.setMaxAge(60*60*24*30);// 30???
			response.addCookie(cookieEmail);			
			
			Cookie cookiesaveId = new Cookie("cSaveId", "checked");
			cookiesaveId.setMaxAge(60*60*24*30);// 30???
			response.addCookie(cookiesaveId);	
			
		} else {
			Cookie[] cookies = request.getCookies();
			if(cookies != null) {
				for(int i = 0; i < cookies.length; i++) {
					if(cookies[i].getName().equals("cEmail") || cookies[i].getName().equals("cSaveId")) {
						cookies[i].setMaxAge(0);
						response.addCookie(cookies[i]);
					}
				}
			}
		}
	}
	// ???????????? ??????
	@RequestMapping(value="/logout")
	public String logoutGet(HttpSession session) {
		session.invalidate();
		return "redirect:/msg/logout";
	}
	
	// ?????? ?????? ??? ?????????
	@RequestMapping(value="/join", method = RequestMethod.GET)
	public String joinGet(Model model) {
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		return "member/join";
	}
	// ?????? ?????? ??????
	@RequestMapping(value="/join", method = RequestMethod.POST)
	public String joinPost(MemberVO vo) {
		if(memberService.getMemberVO(vo.getEmail())!=null || memberService.getMemberVOByNickName(vo.getNick())!=null) {
			return "redirect:/msg/joinFail";
		}
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		memberService.joinMember(vo);
		
		return "redirect:/msg/joinSuccess";
	}
	
	// ????????? ?????? ??????(Ajax)
	@ResponseBody
	@RequestMapping(value="/checkEmail", method = RequestMethod.POST)
	public String checkEmailPost(String email) {
		String res = "0";
		// ????????? ?????? ??????
		MemberVO vo = memberService.getMemberVO(email);
		if(vo != null) {	// ?????? ????????? ??????(?????? ??????)
			res = "0";
		} else {		// ?????? ????????? ??????
			res = "1";
		}
		
		return res;
	}
	// ????????? ?????? ??????(Ajax)
	@ResponseBody
	@RequestMapping(value="/checkNickName", method = RequestMethod.POST)
	public String checkNickNamePost(String nick) {
		String res = "0";
		// ????????? ?????? ??????
		MemberVO vo = memberService.getMemberVOByNickName(nick);
		if(vo == null) {	// ?????? ????????? ??????
			res = "1";
		} else {		// ?????? ????????? ??????(?????? ??????)
			res = "0";
		}
		return res;
	}
	
	// ?????? ?????? ??? ?????????
	@RequestMapping(value="/findPwd", method = RequestMethod.GET)
	public String findPwdGet() {
		return "member/findPwd";
	}
	
	// ajax ?????? ????????? ?????? ??? ???????????? ??????
	@ResponseBody
	@RequestMapping(value="/checkAndSendMail", method = RequestMethod.POST)
	public String checkAndSendMailPost(String name, String email) {
		String certCode = "";
		
		MemberVO vo = memberService.getMemberVO(email);
		if(vo != null && vo.getName().equals(name)) {
			try {
				// ???????????? ??????
				certCode = UUID.randomUUID().toString().substring(0, 6);
				// ?????? ?????????
				String title = ">>>[TSC] ???????????? ?????????????????????.";
				String content = " <div style='border: 3px solid #d35;padding:30px;margin:0 auto;width:600px;'>"
						+ "			    <h1 style='text-align: center;letter-spacing: 1em;'>TSC</h1>"
						+ "				<p style='background-color:#eee;padding:30px;'>" 
						+ "				?????? ??????????????? ??????????????????.<br><input type='text' readonly value='"+certCode+"'/>"
						+ "			    </p><p><img src='cid:mail.png' width='600px'></p>"
						+ "			    <h3>????????? ??? ????????? ??????, ????????? ?????? TSC</h3><hr>"			
									+ " <div class=\"footer\" style=\"background-color: #ddd; padding: 20px 40px;\">"
										+ "	<div style=\"width:980px; margin:0 auto;\">"
											+ "	<a>????????????</a>"
											+ "	<a>????????????????????????</a>"
											+ "	<a href=\"${ctp}/support/home\">????????????</a>"
											+ "	<a>????????????</a>"
											+ "	<hr/>"
											+ "	???????????? 1588-2188 (09:20 ~ 17:50 ??????)<br/>"
											+ "	Copyright &copy; The Scesent. All Rights reserved.<br/>"
										+ "	</div>"
									+ "</div>"
						+ "        </div>";
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
				
				messageHelper.setTo(email);
				messageHelper.setSubject(title);
				
				content = content.replace("\n", "<br>");
				messageHelper.setText(content, true);
				FileSystemResource file = new FileSystemResource("C:\\JavaCourse\\SpringProject\\cjs2108_cjr\\src\\main\\webapp\\resources\\images\\mail\\mail.png");
				messageHelper.addInline("mail.png", file);
				
				mailSender.send(message);
			} catch (MessagingException e) {
				e.printStackTrace();
			}
		}
		return certCode;
	}
	
	
	@RequestMapping(value="/changePwd", method = RequestMethod.GET)
	public String changePwdGet(String email, Model model) {
		model.addAttribute("email", email);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		return "member/changePwd";
	}
	@RequestMapping(value="/changePwd", method = RequestMethod.POST)
	public String changePwdPost(String email, String pwd) {
		pwd = passwordEncoder.encode(pwd);
		memberService.changePwd(email, pwd);
		return "redirect:/msg/changePwdOk";
	}

	@RequestMapping(value="/mypage", method = RequestMethod.GET)
	public String mypageGet(HttpSession session, Model model) {
		String nick = (String) session.getAttribute("sNick");
		MemberVO memberVo = memberService.getMemberVOByNickName(nick);
		int ticketNum = ticketingService.getTicketNum(nick);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("ticketNum", ticketNum);
		model.addAttribute("memberVo", memberVo); 
		return "member/mypage/mypage";
	}
	
	@RequestMapping(value="/mypage/memberInfo/changeNick", method = RequestMethod.GET)
	public String changeNickGet() {
		return "member/mypage/memberInfo/changeNick";
	}
	
	@ResponseBody
	@RequestMapping(value="/mypage/memberInfo/changeNick", method = RequestMethod.POST)
	public void changeNickPost(HttpSession session, String nick) {
		String sNick = (String) session.getAttribute("sNick");
		memberService.changeNick(nick, sNick);
		session.setAttribute("sNick", nick);
	}

	@RequestMapping(value="/mypage/memberInfo/changePwd", method = RequestMethod.GET)
	public String changePwdGet() {
		return "member/mypage/memberInfo/changePwd";
	}
	
	@ResponseBody
	@RequestMapping(value="/mypage/memberInfo/changePwd", method = RequestMethod.POST)
	public String changePwdPost(HttpSession session, String oldpwd, String pwd) {
		String sNick = (String) session.getAttribute("sNick");
		MemberVO vo = memberService.getMemberVOByNickName(sNick);
		String email = vo.getEmail();
		if(passwordEncoder.matches(oldpwd, vo.getPwd())) {
			pwd = passwordEncoder.encode(pwd);
			memberService.changePwd(email, pwd);
			return "1";
		} else {
			return "fail";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/mypage/memberInfo/changePhone", method = RequestMethod.POST)
	public void changePhonePost(HttpSession session, String phone) {
		String nick = (String) session.getAttribute("sNick");
		memberService.changePhone(phone, nick);
	}
	
	@ResponseBody
	@RequestMapping(value="/mypage/memberInfo/changeAddress", method = RequestMethod.POST)
	public String changeAddressPost(HttpSession session, String addrCode, String addr1, String addr2, String addr3) {
		String nick = (String) session.getAttribute("sNick");
		memberService.changeAddress(addrCode, addr1, addr2, addr3, nick);
		return "";
	}
	
	@RequestMapping(value="/mypage/myTickets/myTickets", method = RequestMethod.GET)
	public String myTicketsGet(HttpSession session, Model model, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize 
			) {
		//??????????????? ??????
		String nick = (String) session.getAttribute("sNick");
		MemberVO memberVo = memberService.getMemberVOByNickName(nick);
		int ticketNum = ticketingService.getTicketNum(nick);
		model.addAttribute("ticketNum", ticketNum);
		model.addAttribute("memberVo", memberVo); 
		
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		// ?????? ?????? ?????????
		int totRecCnt = ticketingService.getTicketsListCnt(nick);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<TicketingVO> vos = ticketingService.getTicketsList(nick, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		//
		return "member/mypage/myTickets/myTickets";
	}
	
	@RequestMapping(value="/mypage/myTickets/ticketInfo", method = RequestMethod.GET)
	public String ticketInfoGet(Model model, int idx) {
		TicketingVO ticketVo = ticketingService.getTicketInfo(idx);
		PerformVO performVo = performService.getPerformInfo(ticketVo.getPerformIdx());
		PerformScheduleVO scheduleVo = performService.getPerformScheduleByIdx(ticketVo.getPerformScheduleIdx());
		TheaterVO theaterVo = performService.getTheaterVO(performVo.getTheater());
		String QRCode = ticketingService.getQR(idx);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("ticketVo", ticketVo);
		model.addAttribute("performVo", performVo);
		model.addAttribute("scheduleVo", scheduleVo);
		model.addAttribute("theaterVo", theaterVo);
		model.addAttribute("QRCode", QRCode);
		return "member/mypage/myTickets/ticketInfo";
	}

	@ResponseBody
	@RequestMapping(value="/mypage/myTickets/ticketCancle", method = RequestMethod.POST)
	public String ticketCanclePost(HttpSession session, int idx) {
		String nick = (String) session.getAttribute("sNick");
		String res = "";
		// ????????? 3?????? ???????????? ??????
		Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
		SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyy-MM-dd");
		cal.add(Calendar.DATE, 3); // ?????? ?????? + 3???
		
		TicketingVO vo = ticketingService.getTicketInfo(idx);
		int scheduleIdx = vo.getPerformScheduleIdx();
		String performDate = performService.getPerformScheduleByIdx(scheduleIdx).getSchedule().substring(0, 10);
		Date todayPlus3 = null;
		Date schedule = null;
		try {
			schedule = dateFormat.parse(performDate);
			todayPlus3 = cal.getTime();
		} catch (ParseException e) {}
		
		if(todayPlus3.before(schedule)) {
			ticketingService.ticketCancle(idx);
			
			// ????????? ????????? ??????, ?????? ????????? ??????
			// ????????? ?????? ?????? ????????? ??????
			int plusPoint = (int) (vo.getUsePoint()-vo.getFinalPrice()*0.01);
			memberService.earnPoints(nick, plusPoint);
			
			// ?????? ?????? ??????
			String[] selectSeat = vo.getSelectSeatNum().split(",");
			String[] remainSeat = performService.getPerformScheduleByIdx(scheduleIdx).getRemainSeatNum().split(",");
			String[] OriSeat = performService.getPerformScheduleByIdx(scheduleIdx).getSeatNum().split(",");
			String remainSeatNum = "";
			for(int i = 0; i < selectSeat.length; i++) {
				int seat = Integer.parseInt(selectSeat[i]) + Integer.parseInt(remainSeat[i]);
				if(Integer.parseInt(OriSeat[i])>= seat) {
					remainSeatNum += seat + ",";
				} else {
					remainSeatNum += Integer.parseInt(OriSeat[i]) + ",";
				}
			}
			memberService.updateRemainSeatNum(scheduleIdx, remainSeatNum.substring(0, remainSeatNum.lastIndexOf(",")));
			res =  "success";			
		} else {
			res = "fail";
		}
		return res;			
	}
	
	@RequestMapping(value = "/mypage/qna/qnaList", method = RequestMethod.GET)
	public String qnaList(HttpSession session, Model model, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize 
			) {
		//??????????????? ??????
		String nick = (String) session.getAttribute("sNick");
		MemberVO memberVo = memberService.getMemberVOByNickName(nick);
		int ticketNum = ticketingService.getTicketNum(nick);
		model.addAttribute("ticketNum", ticketNum);
		model.addAttribute("memberVo", memberVo); 
		
		// ?????????
		int totRecCnt = memberService.getQnaListCnt(nick);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<QnaVO> vos = memberService.getQnaList(nick, pagingVO.getStartIndexNo(), pageSize);
		
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		
		return "member/mypage/qna/qnaList";
	}
	
	@RequestMapping(value="/mypage/myReview/myReview", method = RequestMethod.GET)
	public String myReview(HttpSession session, Model model, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize 
			) {
		//??????????????? ??????
		String nick = (String) session.getAttribute("sNick");
		MemberVO memberVo = memberService.getMemberVOByNickName(nick);
		int ticketNum = ticketingService.getTicketNum(nick);
		model.addAttribute("ticketNum", ticketNum);
		model.addAttribute("memberVo", memberVo); 
		
		// ?????????
		int totRecCnt = memberService.getMyReviewCnt(nick)==null?0:memberService.getMyReviewCnt(nick);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<ReviewVO> vos = memberService.getMyReviewList(nick, pagingVO.getStartIndexNo(), pageSize);
		for(ReviewVO vo : vos) {
			vo.setPerformTitle(performService.getPerformInfo(vo.getPerformIdx()).getTitle());
		}
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		return "member/mypage/myReview/myReview";
	}
	
	
	@RequestMapping(value="/mypage/myReview/updateReview", method = RequestMethod.GET)
	public String updateReviewGet(int idx, Model model) {
		ReviewVO vo = memberService.getReviewByIdx(idx);
		model.addAttribute("vo", vo);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		return "member/mypage/myReview/updateReview";
	}
	@ResponseBody
	@RequestMapping(value="/mypage/myReview/updateReview", method = RequestMethod.POST)
	public void updateReviewPost(ReviewVO vo) {
		performService.updateReview(vo);
	}
	
	@RequestMapping(value="/mypage/GOODBYE", method = RequestMethod.GET)
	public String GoodByePost(HttpSession session) {
		String nick = (String) session.getAttribute("sNick");
		memberService.goodByeMember(nick);
		session.invalidate();
		return "redirect:/msg/GoodBye";
	}
	
	@RequestMapping(value="mypage/myPerform/performList", method = RequestMethod.GET)
	public String performListGet(Model model, HttpSession session, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize 
			) {
		String nick = (String) session.getAttribute("sNick");
		MemberVO memberVo = memberService.getMemberVOByNickName(nick);
		int ticketNum = ticketingService.getTicketNum(nick);
		model.addAttribute("ticketNum", ticketNum);
		model.addAttribute("memberVo", memberVo); 
		
		String email = memberService.getMemberVOByNickName(nick).getEmail();
		
		int totRecCnt = performService.getMyPerformCnt(email)==null?0:performService.getMyPerformCnt(email);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<PerformVO> vos = performService.getMyPerform(email, pagingVO.getStartIndexNo(), pageSize);
		
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vos", vos); 
		model.addAttribute("pagingVO", pagingVO); 
		return "member/mypage/myPerform/performList";
	}

	@RequestMapping(value="/mypage/myPerform/performDetail", method = RequestMethod.GET)
	public String performDetail(int idx, Model model) {
		PerformVO vo = performService.getAllPerformInfo(idx);
		int performInfoViews = performService.getPerformInfoViews(idx)==null?0:performService.getPerformInfoViews(idx);
		List<TicketingVO> ticketingVos = ticketingService.getMyPerformTicketsList(idx);
		int sumPrice = 0;
		for(TicketingVO tvo : ticketingVos) {
			sumPrice  += tvo.getPrice();
		}
		
		// ?????? ?????????, ????????? ?????????
		List<PerformScheduleVO> scheduleVos = performService.getPerformScheduleList(idx);
		int[] seatNums;
		int[] remainSeatNums;
		int AllSeatNums = 0;
		int AllRemainSeatNums = 0;
		if(scheduleVos.size()>0) {
			if(scheduleVos.get(0).getSeatNum().contains(",")) {
				int seatlength = scheduleVos.get(0).getSeatNum().split(",").length;
				seatNums = new int[seatlength];
				remainSeatNums = new int[seatlength];
				
				for(PerformScheduleVO svo : scheduleVos) {
					for(int i = 0; i< svo.getSeatNum().split(",").length; i++) {
						seatNums[i] += Integer.parseInt(svo.getSeatNum().split(",")[i]);
						remainSeatNums[i] += Integer.parseInt(svo.getRemainSeatNum().split(",")[i]);
						AllSeatNums += Integer.parseInt(svo.getSeatNum().split(",")[i]);
						AllRemainSeatNums += Integer.parseInt(svo.getRemainSeatNum().split(",")[i]);
					}
				}
				model.addAttribute("seatNums", seatNums);
				model.addAttribute("remainSeatNums", remainSeatNums);
			}else {
				for(PerformScheduleVO svo : scheduleVos) {
					AllSeatNums += Integer.parseInt(svo.getSeatNum());
					AllRemainSeatNums += Integer.parseInt(svo.getRemainSeatNum());
				}
			}
			model.addAttribute("AllSeatNums", AllSeatNums);
			model.addAttribute("AllRemainSeatNums", AllRemainSeatNums);
		}
		
		// ????????? 
		int reviewCnt = performService.getTotalReviewCnt(idx)==null ? 0 : performService.getTotalReviewCnt(idx);
		double starAvg = performService.getReviewAvg(idx)==null? 0.0: performService.getReviewAvg(idx);
		
		model.addAttribute("vo", vo);
		model.addAttribute("ticketingVos", ticketingVos);
		model.addAttribute("performInfoViews", performInfoViews);
		model.addAttribute("sumPrice", sumPrice);
		model.addAttribute("reviewCnt", reviewCnt);
		model.addAttribute("starAvg", starAvg);
		
		return "member/mypage/myPerform/performDetail";
	}
	

	@RequestMapping(value="/mypage/myPerform/newPerform", method = RequestMethod.GET)
	public String newPerformGet(HttpSession session, Model model) {
		String nick = (String) session.getAttribute("sNick");
		MemberVO memberVo = memberService.getMemberVOByNickName(nick);
		int ticketNum = ticketingService.getTicketNum(nick);
		model.addAttribute("ticketNum", ticketNum);
		model.addAttribute("memberVo", memberVo); 
		
		String email = memberVo.getEmail();
		model.addAttribute("email", email);
		model.addAttribute("vos", performService.getTheaterList());
		return "member/mypage/myPerform/newPerform";
	}
	
	@RequestMapping(value="/mypage/myPerform/newPerform", method = RequestMethod.POST)
	public String newPerformGet(PerformVO vo, MultipartFile fName) {
		
		String theater = vo.getTheater();
		if(vo.getTheater().indexOf('/')!=-1) {
			theater = vo.getTheater().substring(0, vo.getTheater().indexOf('/'));
			vo.setTheater(theater);
		}
		
		// ????????? ?????? ????????? ??????
		String posterFileServerName = performService.posterUpload(fName);
		if(posterFileServerName.equals("")) {
			msgFlag = "posterUploadFail";
			return "redirect:/msg/"+msgFlag;
		}
		vo.setPosterOGN(fName.getOriginalFilename());
		vo.setPosterFSN("/images/perform/poster/" + posterFileServerName);
		// ?????? ???????????? ???????????? ????????? info ????????? ??????
		performService.uploadFileManage(vo.getContent());
		
		// content ??? img ????????? ???????????? ????????? ??????
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/perform/info/"));
		
		vo.setTitle(vo.getTitle().replace("<", "&lt;"));
		vo.setTitle(vo.getTitle().replace(">", "&gt;"));
		// DB??? vo ??????
		performService.registPerform(vo);
		
		// ??????theater ??????
		if(performService.getTheater(theater)==null && (vo.getAddress1()==null || !vo.getAddress1().equals(""))) {
			TheaterVO theaterVo = new TheaterVO();
			theaterVo.setName(theater);
			theaterVo.setAddress1(vo.getAddress1());
			theaterVo.setAddress2(vo.getAddress2());
			theaterVo.setAddress3(vo.getAddress3());
			performService.registTheater(theaterVo);
		}
		return "redirect:/msg/performRegistApplyOk";
	}
	// ?????? ??? ?????????
	@RequestMapping(value="/mypage/myPerform/updatePerform", method = RequestMethod.GET)
	public String updatePerformGet(HttpSession session, int idx, Model model) {
		//??????????????? ??????
		String nick = (String) session.getAttribute("sNick");
		MemberVO memberVo = memberService.getMemberVOByNickName(nick);
		int ticketNum = ticketingService.getTicketNum(nick);
		model.addAttribute("ticketNum", ticketNum);
		model.addAttribute("memberVo", memberVo); 
		
		PerformVO vo = performService.getAllPerformInfo(idx);
		model.addAttribute("vo", vo);
		
		// ?????? ????????? ????????????	'/images/ckeditor' ?????????!
		if(vo.getContent().indexOf("src=\"/") != -1) performService.imgCopyTempFolder(vo.getContent());
		
		model.addAttribute("vo", vo);
		model.addAttribute("vos", performService.getTheaterList());
		return "member/mypage/myPerform/updatePerform";
	}
	// ?????? ??????
	@RequestMapping(value="/mypage/myPerform/updatePerform", method = RequestMethod.POST)
	public String updatePerformPost(PerformVO vo, MultipartFile fName) {
		String theater = vo.getTheater();
		if(vo.getTheater().indexOf('/')!=-1) {
			theater = vo.getTheater().substring(0, vo.getTheater().indexOf('/'));
			vo.setTheater(theater);
		}
		
		// ckediter ?????? ?????? ??????, ??? ?????? ????????? ?????????
		if(vo.getOriContent().indexOf("src=\"/") != -1) performService.imgDelete(vo.getOriContent());
		vo.setContent(vo.getContent().replace("/images/perform/info/", "/images/ckeditor/"));
		performService.uploadFileManage(vo.getContent());
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/perform/info/"));
		
		
		
		//????????? ??????????????? ?????? ?????? service ???????????? DB??? ??????
		if(fName.getOriginalFilename().equals("")) {
			performService.updatePerformExceptPoster(vo);
		} else {
			String posterFileServerName = performService.posterUpload(fName);
			if(posterFileServerName.equals("")) {
				msgFlag = "posterUploadFail";
				return "redirect:/msg/"+msgFlag;
			}
			vo.setPosterOGN(fName.getOriginalFilename());
			vo.setPosterFSN("/images/perform/poster/" + posterFileServerName);
			performService.deletePoster(vo.getOriPosterFSN());
			
			performService.updatePerformAll(vo);
		}
		
		// ??????theater ??????
		if(performService.getTheater(theater)==null && (vo.getAddress1()==null || !vo.getAddress1().equals(""))) {
			TheaterVO theaterVo = new TheaterVO();
			theaterVo.setName(theater);
			theaterVo.setAddress1(vo.getAddress1());
			theaterVo.setAddress2(vo.getAddress2());
			theaterVo.setAddress3(vo.getAddress3());
			performService.registTheater(theaterVo);
		}
		return "redirect:/msg/updatePOK";
	}
	
	@RequestMapping(value="/mypage/myPerform/updatePerformSchedule", method = RequestMethod.GET)
	public String updatePerformSchedule(int idx, Model model) {	
		PerformVO performVo = performService.getAllPerformInfo(idx);
		performService.getSchedule(idx);
		
		model.addAttribute("performVo", performVo);
		return "member/mypage/myPerform/updatePerformSchedule";
	}
	
	@ResponseBody
	@RequestMapping(value="/mypage/myPerform/getScheduleDetail", method = RequestMethod.POST)
	public List<PerformScheduleVO> getScheduleDetailPost(String ymd, int performIdx){
		List<PerformScheduleVO> vos = performService.getPerformTime(ymd, performIdx);
		String seat = performService.getAllPerformInfo(performIdx).getSeat();
		for(PerformScheduleVO vo : vos) {
			vo.setSeat(seat);
		}
		return vos;
	}
	
	@ResponseBody
	@RequestMapping(value="/mypage/myPerform/deletePerform", method = RequestMethod.POST)
	public String deletePerformPost(int idx) {
		memberService.deletePerform(idx);
		return "";
	}
	
}
