package com.spring.cjs2108_cjr;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_cjr.service.MemberService;
import com.spring.cjs2108_cjr.service.PerformService;
import com.spring.cjs2108_cjr.service.SupportService;
import com.spring.cjs2108_cjr.service.TicketingService;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.NoticeVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.ThemePerformVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	MemberService memberService;

	@Autowired
	TicketingService ticketingService;

	@Autowired
	PerformService performService;

	@Autowired
	SupportService supportService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String goHome(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		model.addAttribute("serverTime", formattedDate );
		model.addAttribute("date", date);
		return "/home";
	}
	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession session, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "ticketSales", required = false) String orderBy,
			@RequestParam(name = "condition", defaultValue = "proceeding", required = false) String condition
			) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String visit = session.getAttribute("visit")== null? "" : (String)session.getAttribute("visit");
		String nick = session.getAttribute("sNick")== null? "" : (String)session.getAttribute("sNick");
		
		if(visit.equals("")) {
			// db에  idx, vData, sessionId, hostIp 저장
			HttpServletRequest request =((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			String hostIp = request.getRemoteAddr();
			memberService.addVisit(session.getId(), hostIp);
			
			session.setAttribute("visit", "1");
		} else if(!nick.equals("") && visit.equals("1")) {
			// db에서 세션아이디 같은 행에 닉네임 저장
			memberService.setVisitNick(nick, session.getId());
			session.setAttribute("visit", "2");
		} else if(!nick.equals("") && visit.equals("2")) {
			// 방문 데이터 수집 안함
		}
		
		//// 메인 광고영상하나 골라와!
		AdvertiseVO advVo = performService.getMainAdvertise();
		
		//// 추천작 4개(예매 많은 순으로 일단 했는뎅 나중에 관리자가 설정한 거 추천해줘도 괜찮을듯?)
		List<PerformVO> recommandVos = performService.getPerformList(keyWord, condition, orderBy, 0, 4);
		for(PerformVO vo : recommandVos) {
			double avg = performService.getReviewAvg(vo.getIdx())==null? 0.0: performService.getReviewAvg(vo.getIdx());
			vo.setStar(avg);
		}
		//// 공연 예정작 4개
		List<PerformVO> comingsoonVos = performService.getPerformList(keyWord, "comingsoon", "startDate", 0, 4);
		for(PerformVO vo : comingsoonVos) {
			double avg = performService.getReviewAvg(vo.getIdx())==null? 0.0: performService.getReviewAvg(vo.getIdx());
			vo.setStar(avg);
		}
		
		// 관리자 설정 테마
		List<List<PerformVO>> themesVos = new ArrayList<List<PerformVO>>();
		List<String> themes = performService.getShowThemes();
		for(int i= 0; i<themes.size();i++) {
			List<PerformVO> performVos = new ArrayList<PerformVO>();
			List<Integer> performIdxList = performService.getPerformsInTheme(themes.get(i));
			
			for(int performIdx : performIdxList) {
				PerformVO vo = performService.getPerformInfo(performIdx);
				if(vo!=null) {
					double avg = performService.getReviewAvg(performIdx)==null? 0.0: performService.getReviewAvg(performIdx);
					vo.setStar(avg);
					performVos.add(vo);
				}
			}
			themesVos.add(performVos);
		}
		
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO slimVO1 = performService.getSlimAdv();
		AdvertiseVO slimVO2 = performService.getSlimAdv();
		
		List<NoticeVO> noticeVos = supportService.getNoticeList("important", "", 0, 1);
		NoticeVO noticeVo = noticeVos.get(0);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("advVo", advVo);
		model.addAttribute("recommandVos", recommandVos);
		model.addAttribute("comingsoonVos", comingsoonVos);
		model.addAttribute("themesVos", themesVos);
		model.addAttribute("themes", themes);
		model.addAttribute("noticeVo", noticeVo);
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("slimVO1", slimVO1);
		model.addAttribute("slimVO2", slimVO2);
		
		return "main/main";
	}
	
	// ck editor 파일 저장
	@ResponseBody
	@RequestMapping("/imageUpload")
	public void imageUploadGet(HttpServletRequest request, HttpServletResponse response, @RequestParam MultipartFile upload) throws Exception {
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String originalFilename = upload.getOriginalFilename();
		
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		originalFilename = sdf.format(date) + "_" + originalFilename;
		
		byte[] bytes = upload.getBytes();
		
		// ckeditor에서 올린 파일을 서버 파일시스템에 저장시켜준다.
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/ckeditor/");
		OutputStream outStr = new FileOutputStream(new File(uploadPath + originalFilename));
		outStr.write(bytes);		// 서버에 업로드시킨 그림파일이 저장된다.
		
		// 서버 파일시스템에 저장된 파일을 화면(textarea)에 출력하기
		PrintWriter out = response.getWriter();
		String fileUrl = request.getContextPath() + "/images/ckeditor/" + originalFilename;
		out.println("{\"originalFilename\":\""+originalFilename+"\",\"uploaded\":1,\"url\":\""+fileUrl+"\"}");       /* "atom":"12.jpg","uploaded":1,"": */
		
		out.flush();
		outStr.close();
	}
	
	@RequestMapping("/close")
	public String closeGet() {
		return "/include/close";
	}
	
	// qr 코드 상세 정보 확인
	@RequestMapping(value = "/main/ticketInfo", method = RequestMethod.GET)
	public String ticketInfoGet(int idx, Model model) {
		TicketingVO ticketVo = ticketingService.getTicketInfo(idx);
		PerformVO performVo = performService.getPerformInfo(ticketVo.getPerformIdx());
		PerformScheduleVO scheduleVo = performService.getPerformScheduleByIdx(ticketVo.getPerformScheduleIdx());

		model.addAttribute("ticketVo", ticketVo);
		model.addAttribute("performVo", performVo);
		model.addAttribute("scheduleVo", scheduleVo);
		return "main/ticketInfo";
	}
		
}
