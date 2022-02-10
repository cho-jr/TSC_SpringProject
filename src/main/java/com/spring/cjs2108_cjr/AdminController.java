package com.spring.cjs2108_cjr;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_cjr.pagination.PagingVO;
import com.spring.cjs2108_cjr.service.AdminService;
import com.spring.cjs2108_cjr.service.MemberService;
import com.spring.cjs2108_cjr.service.PerformService;
import com.spring.cjs2108_cjr.service.PlazaService;
import com.spring.cjs2108_cjr.service.SupportService;
import com.spring.cjs2108_cjr.service.TicketingService;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.BoardReplyVO;
import com.spring.cjs2108_cjr.vo.FAQVO;
import com.spring.cjs2108_cjr.vo.FreeBoardVO;
import com.spring.cjs2108_cjr.vo.MemberVO;
import com.spring.cjs2108_cjr.vo.NoticeVO;
import com.spring.cjs2108_cjr.vo.OfficialVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.RegionTicketSalesVO;
import com.spring.cjs2108_cjr.vo.ReportVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;
import com.spring.cjs2108_cjr.vo.SuggestionVO;
import com.spring.cjs2108_cjr.vo.TheaterVO;
import com.spring.cjs2108_cjr.vo.ThemePerformVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;
import com.spring.cjs2108_cjr.vo.VisitDataVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	String msgFlag = "";

	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	PerformService performService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	TicketingService ticketingService;
	
	@Autowired
	SupportService supportService;

	@Autowired
	PlazaService plazaService;
	
	@RequestMapping(value="/adminMain", method = RequestMethod.GET)
	public String adMenuGet() {
		return "admin/adminMain";
	}
	
	@RequestMapping(value="/adLeft", method = RequestMethod.GET)
	public String adLeftGet() {
		return "admin/adLeft";
	}
	@ResponseBody
	@RequestMapping(value="/visitChartCalendar", method = RequestMethod.POST)
	public List<VisitDataVO> visitChartCalendarGet() {
		return adminService.getVisitCnt("calendar");
	}
	@ResponseBody
	@RequestMapping(value="/visitChart", method = RequestMethod.POST)
	public List<VisitDataVO> visitChartGet(String range) {
		List<VisitDataVO> vos = adminService.getVisitCnt(range);
		List<VisitDataVO> data = new ArrayList<VisitDataVO>();
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		switch (range) {
			case "date":
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				for(int i=0; i<31;i++) {
					cal.add(Calendar.DATE, -1);
					VisitDataVO date = new VisitDataVO();
					date.setVDate(df.format(cal.getTime()));
					data.add(date);
				}
				for(VisitDataVO date : data) {
					for(VisitDataVO vo : vos) {
						if(vo.getVDate().equals(date.getVDate())) date.setCount(vo.getCount());
					}
				}
//				vos.clear();
//				vos.addAll(data);
				break;
			case "month":
				for(int i=1; i<=12;i++) {
					VisitDataVO vo = new VisitDataVO();
					String str = ("00"+ String.valueOf(i));

					vo.setVDate(str.substring(str.length()-2));
					for(VisitDataVO tvo : vos) {
						if(tvo.getVDate().equals(str.substring(str.length()-2))){
							vo.setCount(tvo.getCount());
						}
					}
					data.add(vo);
				}
//				vos.clear();
//				vos.addAll(data);
				break;
			case "day":
				for(DayOfWeek day : DayOfWeek.values()) {
					VisitDataVO vo = new VisitDataVO();
					vo.setDay(day.toString().substring(0, 3));
					for(VisitDataVO tvo : vos) {
						if(tvo.getDay().toUpperCase().equals(day.toString().substring(0, 3))) {
							vo.setCount(tvo.getCount());
						}
					}
					data.add(vo);
				}
//				vos.clear();
//				vos.addAll(data);
				break;
				
			case "year":
				DateFormat df1 = new SimpleDateFormat("yyyy");
				int nowYear = Integer.parseInt(df1.format(cal.getTime()));
				for(int i=0; i<5; i++) {
					VisitDataVO vo = new VisitDataVO();
					vo.setVDate(String.valueOf(nowYear-i));
					for(VisitDataVO tvo : vos) {
						if(tvo.getVDate().equals(vo.getVDate())) {
							vo.setCount(tvo.getCount());
						}
					}
					data.add(vo);
				}
				break;
				
			case "time":
				for(int i=0; i<24; i++) {
					VisitDataVO vo = new VisitDataVO();
					vo.setVDate(String.valueOf(i));
					for(VisitDataVO tvo : vos) {
						if(tvo.getVDate().equals(vo.getVDate())) {
							vo.setCount(tvo.getCount());
						}
					}
					data.add(vo);
				}
				break;

			default:
				break;
		}
		vos.clear();
		vos.addAll(data);
		return vos;
	}
	
	@RequestMapping(value="/adContent", method = RequestMethod.GET)
	public String adContentGet(Model model) {
		int todayVisit = adminService.getTodayVisit();
		int totalVisit = adminService.getTotalVisit();
		int newReportCnt = adminService.getTotReportCnt()==null?0:adminService.getTotReportCnt();
		int newQnaCnt = adminService.getAllQnaCnt("", "noAnswer")==null?0:adminService.getAllQnaCnt("", "noAnswer");
		int newApplyOfficial = adminService.getNewOffialApplyCnt()==null ? 0 : adminService.getNewOffialApplyCnt();
		int noAccessPerform = adminService.getNoAccessPerformCnt()==null? 0:adminService.getNoAccessPerformCnt();
		int newBoardNum = adminService.getNewBoardCnt()==null? 0:adminService.getNewBoardCnt();
		int newReplyNum = adminService.getNewReplyCnt()==null? 0:adminService.getNewReplyCnt();
		
		model.addAttribute("todayVisit", todayVisit);
		model.addAttribute("totalVisit", totalVisit);
		model.addAttribute("newReportCnt", newReportCnt);
		model.addAttribute("newQnaCnt", newQnaCnt);
		model.addAttribute("newApplyOfficial", newApplyOfficial);
		model.addAttribute("noAccessPerform", noAccessPerform);
		model.addAttribute("newBoardNum", newBoardNum);
		model.addAttribute("newReplyNum", newReplyNum);
		return "admin/adContent";
	}
	
	@RequestMapping(value="/setMain/setMainAd", method = RequestMethod.GET)
	public String setMainAdGet(Model model) {
		// 현재 광고 정보 보내
		List<AdvertiseVO> vos = adminService.getAdvertiseList();
		model.addAttribute("vos", vos);
		return "admin/setMain/setMainAd";
	}

	@RequestMapping(value="/setMain/setThemePerform", method = RequestMethod.GET)
	public String setThemePerformGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "ticketSales", required = false) String orderBy,
			@RequestParam(name = "condition", defaultValue = "all", required = false) String condition,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = performService.getPerformCnt(keyWord, condition);
		
		// 테마, 테마별 작품, 테마 추가
		List<ThemePerformVO> themeVos = adminService.getThemeList();
		// 테마 리스트,  작품리스트, 테마별 작품
		List<PerformVO> performVos = performService.getPerformList(keyWord, "proceeding", orderBy, 0, totRecCnt);
		List<PerformVO> prePerformVos = performService.getPerformList(keyWord, "comingsoon", orderBy, 0, totRecCnt);
		List<String> selectedTheme = performService.getSelectedTheme();
		
		model.addAttribute("themeVos", themeVos);
		model.addAttribute("performVos", performVos);
		model.addAttribute("prePerformVos", prePerformVos);
		model.addAttribute("selectedTheme", selectedTheme);
		
		return "admin/setMain/setThemePerform";
	}
	
	// 선택한 테마 작품
	@ResponseBody
	@RequestMapping(value="/setMain/getPerforms", method = RequestMethod.POST)
	public List<PerformVO> getPerformsPost(String theme) {
		List<ThemePerformVO> vos = adminService.getPerformsInTheme(theme);
		List<PerformVO> performVos = new ArrayList<PerformVO>();
		for(ThemePerformVO vo : vos) {
			PerformVO pvo = performService.getPerformInfo(vo.getPerformIdx());
			performVos.add(pvo);
		}
		
		return performVos;
	}
	
	// 새로운 테마 추가
	@ResponseBody
	@RequestMapping(value="/setMain/addThemeName", method = RequestMethod.POST)
	public void addThemeNamePost(String theme) {
		// 중복확인
		int sw = 0;
		List<ThemePerformVO> vos = adminService.getThemeList();
		for(ThemePerformVO vo : vos) {
			if(vo.getTheme().equals(theme)) sw = 1;
		}
		if(sw == 0) adminService.addThemeName(theme);
	}
	// 테마에 작품 추가
	@ResponseBody
	@RequestMapping(value="/setMain/addPerformInTheme", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String addPerformInThemePost(ThemePerformVO vo) {
		// 해당 테마에 작품 수 4개 이하면 추가
		int cnt = adminService.getPerformsCntInTheme(vo.getTheme())==null?0:adminService.getPerformsCntInTheme(vo.getTheme());
		if(cnt<4) {
			adminService.addPerformInTheme(vo);			
			return performService.getPerformInfo(vo.getPerformIdx()).getTitle();
		} else {
			return "";
		}
	}
	// 테마에 작품 삭제
	@ResponseBody
	@RequestMapping(value="/setMain/deletePerformInTheme", method = RequestMethod.POST)
	public void deletePerformInThemePost(ThemePerformVO vo) {
		adminService.deletePerformInTheme(vo);
	}
	
	// 선택한 테마 메인에 노출
	@ResponseBody
	@RequestMapping(value="/setMain/addShowTheme", method = RequestMethod.POST)
	public String addShowThemePost(String theme) {
		// 선택한 테마에 포함된 작품이 3이상인 경우만
		if(adminService.getPerformsCntInTheme(theme) < 3) return "fail";
		//orderInt 마지막번호 가져와 + 1
		int maxOrder = adminService.getShowThemeMaxOrder()==null?0:adminService.getShowThemeMaxOrder();
		int order = maxOrder +1;
		
		adminService.addShowTheme(theme, order);
		return "";
	}
	// 선택한 테마 메인에서 숨기기
	@ResponseBody
	@RequestMapping(value="/setMain/delShowTheme", method = RequestMethod.POST)
	public void delShowThemePost(String theme) {
		adminService.delShowTheme(theme);
	}
	// 선택한 테마 삭제
	@ResponseBody
	@RequestMapping(value="/setMain/delTheme", method = RequestMethod.POST)
	public void delThemePost(String theme) {
		adminService.delTheme(theme);
	}
	
	// 공연등록
	@RequestMapping(value="/setPerform/newPerform", method = RequestMethod.GET)
	public String newPerformGet(Model model) {
		// 극장 목록 불러오기
		int totRecCnt = adminService.getTheaterCnt("")==null ? 0 : adminService.getTheaterCnt("");
		List<TheaterVO> vos = adminService.getTheaterList("", "name", 0, totRecCnt);
		model.addAttribute("vos", vos);
		return "admin/setPerform/newPerform";
	}
	
	// 공연 등록처리
	@RequestMapping(value="/setPerform/newPerform", method = RequestMethod.POST)
	public String newPerformPost(PerformVO vo, MultipartFile fName) {
		String theater = vo.getTheater();
		if(vo.getTheater().indexOf('/')!=-1) {
			theater = vo.getTheater().substring(0, vo.getTheater().indexOf('/'));
			vo.setTheater(theater);
		}
		
		// 포스터 파일 업로드 처리
		String posterFileServerName = adminService.posterUpload(fName);
		if(posterFileServerName.equals("")) {
			msgFlag = "posterUploadFail";
			return "redirect:/msg/"+msgFlag;
		}
		vo.setPosterOGN(fName.getOriginalFilename());
		vo.setPosterFSN("/images/perform/poster/" + posterFileServerName);
		// 상세 정보에서 존재하는 파일만 info 폴더에 저장
		adminService.uploadFileManage(vo.getContent(), "performInfo");
		
		// content 내 img 경로를 이동시킨 폴더로 변경
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/perform/info/"));
		
		vo.setTitle(vo.getTitle().replace("<", "&lt;"));
		vo.setTitle(vo.getTitle().replace(">", "&gt;"));
		// DB에 vo 저장
		adminService.registPerform(vo);
		
		// 신규theater 등록
		if(adminService.getTheater(theater)==null && (vo.getAddress1()==null || !vo.getAddress1().equals(""))) {
			TheaterVO theaterVo = new TheaterVO();
			theaterVo.setName(theater);
			theaterVo.setAddress1(vo.getAddress1());
			theaterVo.setAddress2(vo.getAddress2());
			theaterVo.setAddress3(vo.getAddress3());
			adminService.registTheater(theaterVo);
		}
		
		msgFlag = "performRegistOk";
		return "redirect:/msg/"+msgFlag;
	}
	
	// 관리자메뉴 작품 조회
	@RequestMapping(value="/setPerform/adminPerformList", method = RequestMethod.GET)
	public String performListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "ticketSales", required = false) String orderBy,
			@RequestParam(name = "condition", defaultValue = "all", required = false) String condition,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getPerformCnt(keyWord, condition)==null?0:adminService.getPerformCnt(keyWord, condition);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<PerformVO> vos = null;
		//
		if(orderBy.equals("star")) {
			List<PerformVO> tempVos = adminService.getPerformList(keyWord, condition, orderBy, 0, totRecCnt);
			for(PerformVO vo : tempVos) {
				double avg = performService.getReviewAvg(vo.getIdx())==null? 0.0: performService.getReviewAvg(vo.getIdx());
				vo.setStar(avg);
			}
			PerformVO tempVO = null;
			for(int i = 0; i < tempVos.size(); i++) {
				for(int j = i+1; j < tempVos.size(); j++) {
					if(tempVos.get(i).getStar()<tempVos.get(j).getStar()) {
						tempVO = tempVos.get(i);
						tempVos.set(i, tempVos.get(j));
						tempVos.set(j, tempVO);
					}
				}
			}
			
			vos = tempVos.subList(pagingVO.getStartIndexNo(), (pagingVO.getStartIndexNo()+pageSize)>=tempVos.size()?tempVos.size():pagingVO.getStartIndexNo()+pageSize);
		} else {
			vos = adminService.getPerformList(keyWord, condition, orderBy, pagingVO.getStartIndexNo(), pageSize);
			for(PerformVO vo : vos) {
				double avg = performService.getReviewAvg(vo.getIdx())==null? 0.0: performService.getReviewAvg(vo.getIdx());
				vo.setStar(avg);
			}
		}
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("condition", condition);
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("orderBy", orderBy);
		
		return "/admin/setPerform/adminPerformList";
	}
	
	// 공연 정보 상세보기
	@RequestMapping(value="setPerform/detailPerform", method = RequestMethod.GET)
	public String detailPerformGet(int idx, Model model) {
		PerformVO vo = performService.getAllPerformInfo(idx);
		vo.setTitle(vo.getTitle().replace("<", "&lt;"));
		vo.setTitle(vo.getTitle().replace(">", "&gt;"));
		model.addAttribute("vo", vo);
		return "/admin/setPerform/detailPerform";
	}
	
	// 공연 정보 수정 폼 띄우기
	@RequestMapping(value="/setPerform/updatePerform", method = RequestMethod.GET)
	public String updatePerformGet(String idx, Model model) {
		int intIdx = Integer.parseInt(idx);
		PerformVO vo = performService.getAllPerformInfo(intIdx);
		
		// 임시 폴더에 복사해둠	'/images/ckeditor' 폴더에!
		if(vo.getContent().indexOf("src=\"/") != -1) adminService.imgCopyTempFolder(vo.getContent(), "performInfo");
		
		int totRecCnt = adminService.getTheaterCnt("")==null ? 0 : adminService.getTheaterCnt("");
		List<TheaterVO> vos = adminService.getTheaterList("", "name", 0, totRecCnt);
		model.addAttribute("vo", vo);
		model.addAttribute("vos", vos);
		
		return "/admin/setPerform/updatePerform";
	}
	
	// 공연 정보 수정 내용 등록
	@RequestMapping(value="/setPerform/updatePerform", method = RequestMethod.POST)
	public String updatePerformPost(PerformVO vo, MultipartFile fName) {
		String theater = vo.getTheater();
		if(vo.getTheater().indexOf('/')!=-1) {
			theater = vo.getTheater().substring(0, vo.getTheater().indexOf('/'));
			vo.setTheater(theater);
		}
		
		// ckediter 파일 수정 처리, 새 파일 서버에 업로드
		if(vo.getOriContent().indexOf("src=\"/") != -1) adminService.imgDelete(vo.getOriContent(), "performInfo");
		vo.setContent(vo.getContent().replace("/images/perform/info/", "/images/ckeditor/"));
		adminService.uploadFileManage(vo.getContent(), "performInfo");
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/perform/info/"));

		//포스터 수정여부에 따라 다른 service 사용하여 DB에 저장
		if(fName.getOriginalFilename().equals("")) {
			adminService.updatePerformExceptPoster(vo);
		} else {
			String posterFileServerName = adminService.posterUpload(fName);
			if(posterFileServerName.equals("")) {
				msgFlag = "posterUploadFail";
				return "redirect:/msg/"+msgFlag;
			}
			vo.setPosterOGN(fName.getOriginalFilename());
			vo.setPosterFSN("/images/perform/poster/" + posterFileServerName);
			adminService.deletePoster(vo.getOriPosterFSN());
			
			adminService.updatePerformAll(vo);
		}
		
		// 신규theater 등록
		if(adminService.getTheater(theater)==null && (vo.getAddress1()==null || !vo.getAddress1().equals(""))) {
			TheaterVO theaterVo = new TheaterVO();
			theaterVo.setName(theater);
			theaterVo.setAddress1(vo.getAddress1());
			theaterVo.setAddress2(vo.getAddress2());
			theaterVo.setAddress3(vo.getAddress3());
			adminService.registTheater(theaterVo);
		}
		return "redirect:/msg/updatePerformOK";
	}
	
	@RequestMapping(value="/setTheater/newTheater", method = RequestMethod.GET)
	public String newTheaterGet(Model model) {
		int totRecCnt = adminService.getTheaterCnt("")==null ? 0 : adminService.getTheaterCnt("");
		List<TheaterVO> vos = adminService.getTheaterList("", "name", 0, totRecCnt);
		model.addAttribute("vos", vos);
		return "/admin/setTheater/newTheater";
	}
	
	@ResponseBody
	@RequestMapping(value="/setTheater/newTheater", method = RequestMethod.POST)
	public String newTheaterPost(TheaterVO vo) {
		String res = "";
		TheaterVO  searchedVo = adminService.getTheater(vo.getName());
		if(searchedVo!=null) res = "NO";
		else {
			adminService.registTheater(vo);		
			res = "OK";
		}
		return res;
	}
	
	@RequestMapping(value="/setPerform/updatePerformSchedule", method = RequestMethod.GET)
	public String updatePerformScheduleGet(String idx, Model model) {
		int intIdx = Integer.parseInt(idx);
		PerformVO performVo = performService.getAllPerformInfo(intIdx);
		
		performService.getSchedule(intIdx);
		model.addAttribute("performVo", performVo);
		return "/admin/setPerform/updatePerformSchedule";
	}
	
	@ResponseBody
	@RequestMapping(value="/setPerform/updatePerformSchedule", method = RequestMethod.POST)
	public String updatePerformSchedulePost(PerformScheduleVO vo, Model model) {
		// 중복 등록 안되게 하기
		PerformScheduleVO ogVo = performService.getPerformSchedule(vo.getSchedule(), vo.getPerformIdx());
		if(ogVo!=null) return "fail";
		
		performService.registPerformSchedule(vo);
		return String.valueOf(performService.getPerformSchedule(vo.getSchedule(), vo.getPerformIdx()).getIdx());
	}
	
	@ResponseBody
	@RequestMapping(value="/setPerform/deletePerformSchedule", method = RequestMethod.POST)
	public void deletePerformSchedulePost(int idx) {
		performService.deletePerformSchedule(idx);
	}
	
	@RequestMapping(value="/tickets/ticketsList", method = RequestMethod.GET)
	public String ticketsListGet(Model model, 
			@RequestParam(name="keyWord", defaultValue="", required=false) String keyWord, 
			@RequestParam(name="orderBy", defaultValue="idx", required=false) String orderBy, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize, 
			@RequestParam(name="date", defaultValue="", required=false) String date	
			) {
		// 페이징 처리
		int totRecCnt = adminService.getTicketsListCnt(keyWord, date)==null? 0:adminService.getTicketsListCnt(keyWord, date);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<TicketingVO> vos = adminService.getTicketsList(orderBy, keyWord, pagingVO.getStartIndexNo(), pageSize, date);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("date", date);
		return "admin/tickets/ticketsList";
	}
	
	@ResponseBody
	@RequestMapping(value="/setPerform/searchManager", method = RequestMethod.POST)
	public String searchManagerPost(String manager) {
		MemberVO vo = memberService.getMemberVO(manager);
		if(vo== null) return "no";

		String res = "";
		OfficialVO ovo = adminService.getOfficialVO(vo.getNick());
		if(ovo!=null) res = vo.getEmail();
		else res = "no";
	
		return res;
	}
	
	@RequestMapping(value="/setTheater/theaterList", method = RequestMethod.GET)
	public String theaterListGet(Model model, 
			@RequestParam(name="keyWord", defaultValue="", required=false) String keyWord, 
			@RequestParam(name="orderBy", defaultValue="name", required=false) String orderBy, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize 
			) {
		int totRecCnt = adminService.getTheaterCnt(keyWord)==null ? 0 : adminService.getTheaterCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<TheaterVO> vos = adminService.getTheaterList(keyWord, orderBy, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("orderBy", orderBy);
		return "admin/setTheater/theaterList";
	}
	
	@ResponseBody
	@RequestMapping(value="/tickets/printTicket", method = RequestMethod.POST)
	public void printTicketPost(int idx) {
		ticketingService.printTicket(idx);
	}
	
	@ResponseBody
	@RequestMapping(value="/setTheater/deleteTheater", method = RequestMethod.POST)
	public void deleteTheater(int idx) {
		adminService.deleteTheater(idx);
	}
	
	@ResponseBody
	@RequestMapping(value="/setTheater/updateTheaterAddress", method = RequestMethod.POST)
	public void updateTheaterAddressPost(int idx, String address2) {
		adminService.updateTheaterAddress(idx, address2);
	}
	
	// 회원 관리
	// 회원 목록 조회
	@RequestMapping(value="/member/memberList", method = RequestMethod.GET)
	public String memberListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "joinDate", required = false) String orderBy, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getMemberCnt(keyWord)==null?0:adminService.getMemberCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<MemberVO> vos = adminService.getMemberSearch(orderBy, keyWord, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("vos", vos);
		model.addAttribute("orderBy", orderBy);
		return "admin/member/memberList";
	}
	
	// 회원 등급 변경
	@ResponseBody
	@RequestMapping(value = "/member/changeLevel", method = RequestMethod.POST)
	public void changeLevelPost(String nick, int level) {
		adminService.changeMemberLevel(nick, level);
	}
	// 회원 경고
	@ResponseBody
	@RequestMapping(value = "/member/addWarn", method = RequestMethod.POST)
	public void addWarnPost(String nick) {
		adminService.addWarn(nick);
	}

	// 예매 취소 및 포인트 환불
	@ResponseBody
	@RequestMapping(value="/tickets/ticketCancle", method = RequestMethod.POST)
	public void ticketCanclePost(int idx) {
		ticketingService.ticketCancle(idx);
		// 사용 포인트 주고 적립 포인트 회수
		int plusPoint = (int) (ticketingService.getTicketInfo(idx).getUsePoint()-ticketingService.getTicketInfo(idx).getFinalPrice()*0.01);
		memberService.earnPoints(ticketingService.getTicketInfo(idx).getMemberNick(), plusPoint);
	}

	// qna 목록 조회
	@RequestMapping(value="/support/qna/qnaList", method = RequestMethod.GET)
	public String qnaListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "condition", defaultValue = "all", required = false) String condition,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getAllQnaCnt(keyWord, condition)==null?0:adminService.getAllQnaCnt(keyWord, condition);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		
		//
		List<QnaVO> vos = adminService.getQnaList(keyWord, condition, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("condition", condition);
		model.addAttribute("keyWord", keyWord);
		return "admin/support/qna/qnaList";
	}
	
	// qna 답변 등록
	@ResponseBody
	@RequestMapping(value="/support/qna/registAnswer", method = RequestMethod.POST)
	public void registAnswerPost(int idx, String answer) {
		// DB에 저장
		adminService.registAnswer(answer, idx);
		QnaVO vo = adminService.getQnaVo(idx);
		//메일 보내기
		if(vo.isAlert()) {
			try {
				// 메일 보내기
				String title = ">>>[연극]TSC에 문의하신 글에 답변이 등록되었습니다. ";
				String content = ""
						+ "        <div style='border: 3px solid #d35;padding:30px;margin:0 auto;width:600px;'>"
						+ "			   <h1 style='text-align: center;letter-spacing: 1em;'>TSC</h1>"
						+ "			   <h3 style='text-align: center;'>1:1 문의 답변</h3>"
						+ "            안녕하십니까? 저희 서비스를 찾아주셔서 감사합니다. <br/>"
						+ "            회원님께서 남기신 문의글에 답변이 등록되었습니다. <br/>"
						+ "            <a href='http://localhost:9090/cjs2108_cjr/member/mypage/qna/qnaList'>[마이페이지]-[1:1문의]</a>를 확인해주시기 바랍니다. <br/>"
						+ "            감사합니다. 좋은 하루 보내세요."
						+ "			   <p><img src='cid:mail.png' width='600px'></p>"
						+ "			   <h3>예술과 삶 사이의 문화, 현재의 예술 TSC</h3><hr>"	
										+ " <div class=\"footer\" style=\"background-color: #ddd; padding: 20px 40px;\">"
										+ "	<div style=\"width:100%; margin:0 auto;\">"
											+ "	<a>이용약관</a>"
											+ "	<a>개인정보처리방침</a>"
											+ "	<a href=\"${ctp}/support/home\">고객센터</a>"
											+ "	<a>의견수렴</a>"
											+ "	<hr/>"
											+ "	고객센터 1588-2188 (09:20 ~ 17:50 평일)<br/>"
											+ "	Copyright &copy; The Scesent. All Rights reserved.<br/>"
										+ "	</div>"
									+ "</div>"
						+ "        </div>";
				
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
				
				messageHelper.setTo(vo.getEmail());
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
	}
	
	// 공연 인증해제처리(checked -> false)
	@ResponseBody
	@RequestMapping(value="/setPerform/checkedFalse", method = RequestMethod.POST)
	public String checkedFalsePost(int idx) {
		adminService.checkedFalse(idx);
		return "";
	}
	// 공연 인증처리 (checked -> true)
	@ResponseBody
	@RequestMapping(value="/setPerform/checkedTrue", method = RequestMethod.POST)
	public void checkedTruePost(int idx) {
		adminService.checkedTrue(idx);
	}
	// 공연 정보 삭제처리
	@ResponseBody
	@RequestMapping(value="/setPerform/performDelete", method = RequestMethod.POST)
	public void performDeletePost(int idx) {
		adminService.performDelete(idx);
	}
	
	// 리뷰 목록 띄우기
	@RequestMapping(value="/review/reviewList", method = RequestMethod.GET)
	public String reviewListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getTotReviewCnt(keyWord)==null?0:adminService.getTotReviewCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<ReviewVO> vos = adminService.getAllReview(keyWord, orderBy, pagingVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("vos", vos);
		return "admin/review/reviewList";
	}
	
	//리뷰 신고
	@ResponseBody
	@RequestMapping(value="/review/reportReview", method = RequestMethod.POST)
	public void reportReviewPost(ReportVO vo) {
		vo.setReason("관리자 신고");
		performService.addReport(vo);
	}
	//리뷰 삭제
	@ResponseBody
	@RequestMapping(value="/review/deleteReview", method = RequestMethod.POST)
	public void deleteReviewPost(int idx) {
		performService.deleteReview(idx);
	}
	
	// 신고리뷰관리 띄우기
	@RequestMapping(value="/review/reportedReview", method = RequestMethod.GET)
	public String reportedReviewGet(Model model, 
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getTotReportCnt()==null?0:adminService.getTotReportCnt();
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<ReportVO> vos = adminService.getAllReport(orderBy, pagingVO.getStartIndexNo(), pageSize);
		List<ReviewVO> reviewVos = new ArrayList<ReviewVO>();
		for(ReportVO vo : vos) {
			reviewVos.add(adminService.getReviewByIdx(vo.getReviewIdx()));
		}
		
		
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("vos", vos);
		model.addAttribute("reviewVos", reviewVos);
		return "admin/review/reportedReview";
	}
	// 리뷰 내용 숨기기
	@ResponseBody
	@RequestMapping(value="/review/hideContent", method = RequestMethod.POST)
	public void hideContentPost(int idx) {
		adminService.hideReviewContent(idx);
	}
	// 신고 삭제
	@ResponseBody
	@RequestMapping(value="/review/deleteReport", method = RequestMethod.POST)
	public void deleteReportPost(int idx) {
		adminService.deleteReport(idx);
	}
	
	// 공지사항
	@RequestMapping(value="/support/notice/noticeList", method = RequestMethod.GET)
	public String noticeListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "important", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		//서비스 DB에서 공지 목록 가져와
		int totRecCnt = supportService.getNoticeCnt(keyWord)==null?0:supportService.getNoticeCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<NoticeVO> vos = supportService.getNoticeList(orderBy, keyWord, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("orderBy", orderBy);
		
		return "admin/support/notice/noticeList";
	}
	
	// 새 공지 등록 폼 띄움
	@RequestMapping(value="/support/notice/newNotice", method = RequestMethod.GET)
	public String newNoticeGet() {
		return "admin/support/notice/newNotice";
	}
	
	// 새 공지 등록 
	@RequestMapping(value="/support/notice/newNotice", method = RequestMethod.POST)
	public String newNoticePost(NoticeVO vo) {
		adminService.uploadFileManage(vo.getContent(), "notice");
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/support/notice/"));
		adminService.registNotice(vo);
		return "redirect:/msg/registNoticeOK";
	}
	
	// 공지 수정 폼 띄움
	@RequestMapping(value="/support/notice/updateNotice", method = RequestMethod.GET)
	public String updateNoticeGet(Model model, int idx) {
		NoticeVO vo = supportService.getNoticeVO(idx);
		
		if(vo.getContent().indexOf("src=\"/") != -1) adminService.imgCopyTempFolder(vo.getContent(), "notice");
		
		model.addAttribute("vo", vo);
		return "admin/support/notice/updateNotice";
	}

	// 공지수정 등록 
	@RequestMapping(value="/support/notice/updateNotice", method = RequestMethod.POST)
	public String updateNoticePost(NoticeVO vo) {
		
		if(vo.getOriContent().indexOf("src=\"/") != -1) adminService.imgDelete(vo.getOriContent(), "notice");
		vo.setContent(vo.getContent().replace("/images/support/notice/", "/images/ckeditor/"));
		adminService.uploadFileManage(vo.getContent(), "notice");
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/support/notice/"));
		
		adminService.updateNotice(vo);
		return "redirect:/msg/updateNoticeOK";
	}
	
	// 공지 삭제
	@ResponseBody
	@RequestMapping(value="/support/notice/deleteNotice", method = RequestMethod.POST)
	public void deleteNoticePost(int idx) {
		adminService.imgDelete(supportService.getNoticeVO(idx).getContent(), "notice");
		adminService.deleteNotice(idx);
	}
	
	
	// FAQ
	@RequestMapping(value="/support/FAQ/FAQList", method = RequestMethod.GET)
	public String FAQListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		//서비스 DB에서 공지 목록 가져와
		int totRecCnt = supportService.getFAQCnt(keyWord)==null?0:supportService.getFAQCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<FAQVO> vos = supportService.getFAQList(orderBy, keyWord, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("orderBy", orderBy);
		
		return "admin/support/FAQ/FAQList";
	}
	
	// 새 FAQ 등록 폼 띄움
	@RequestMapping(value="/support/FAQ/newFAQ", method = RequestMethod.GET)
	public String newFAQGet() {
		return "admin/support/FAQ/newFAQ";
	}
	
	// 새 FAQ 등록 
	@RequestMapping(value="/support/FAQ/newFAQ", method = RequestMethod.POST)
	public String newFAQPost(FAQVO vo) {
		adminService.uploadFileManage(vo.getAnswer(), "FAQ");
		vo.setAnswer(vo.getAnswer().replace("/images/ckeditor/", "/images/support/FAQ/"));
		adminService.registFAQ(vo);
		return "redirect:/msg/registFAQOK";
	}
	
	// FAQ 수정 폼 띄움
	@RequestMapping(value="/support/FAQ/updateFAQ", method = RequestMethod.GET)
	public String updateFAQGet(Model model, int idx) {
		FAQVO vo = supportService.getFAQVO(idx);
		
		if(vo.getAnswer().indexOf("src=\"/") != -1) adminService.imgCopyTempFolder(vo.getAnswer(), "FAQ");
		
		model.addAttribute("vo", vo);
		return "admin/support/FAQ/updateFAQ";
	}
	
	// FAQ수정 등록 
	@RequestMapping(value="/support/FAQ/updateFAQ", method = RequestMethod.POST)
	public String updateFAQPost(FAQVO vo) {
		
		// 기존 이미지 삭제/ 새 이미지 복사 저장
		if(vo.getOriAnswer().indexOf("src=\"/") != -1) adminService.imgDelete(vo.getOriAnswer(), "FAQ");
		vo.setAnswer(vo.getAnswer().replace("/images/support/FAQ/", "/images/ckeditor/"));
		adminService.uploadFileManage(vo.getAnswer(), "FAQ");
		vo.setAnswer(vo.getAnswer().replace("/images/ckeditor/", "/images/support/FAQ/"));
		
		adminService.updateFAQ(vo);
		return "redirect:/msg/updateFAQOK";
	}
	
	// FAQ 삭제
	@ResponseBody
	@RequestMapping(value="/support/FAQ/deleteFAQ", method = RequestMethod.POST)
	public void deleteFAQPost(int idx) {
		adminService.imgDelete(supportService.getFAQVO(idx).getAnswer(), "FAQ");
		adminService.deleteFAQ(idx);
	}
	
	// 건의사항 목록 가져오기
	@RequestMapping(value="/support/suggestion/suggestionList", method = RequestMethod.GET)
	public String suggestionListGet(Model model ,
			@RequestParam(name = "condition", defaultValue = "4", required = false) int condition,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getSuggestionCnt(condition)==null? 0:adminService.getSuggestionCnt(condition);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<SuggestionVO> vos = adminService.getSuggestionList(condition, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("condition", condition);
		
		return "admin/support/suggestion/suggestionList";
	}
	
	@ResponseBody
	@RequestMapping(value="/support/suggestion/changeCondition", method = RequestMethod.POST)
	public void changeConditionPost(int idx, int condition) {
		adminService.suggestionChangeCondition(idx, condition);
	}
	
	// 공지사항 중요도 0으로 변경
	@RequestMapping(value="/support/notice/updateNoticeImportant", method = RequestMethod.POST)
	public void updateNoticeImportantPost(int idx) {
		adminService.updateNoticeImportantZero(idx);
	}
	
	@RequestMapping(value="/plaza/freeBoard", method = RequestMethod.GET)
	public String freeBoardGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="2", required=false) int pageSize
			) {
		int totRecCnt = plazaService.getFreeBoardCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt); 
		List<FreeBoardVO> vos = adminService.getFreeBoardList(keyWord, orderBy, pagingVO.getStartIndexNo(), pageSize);
		List<List<BoardReplyVO>> replyList = new ArrayList<List<BoardReplyVO>>();
		for(FreeBoardVO vo : vos) {
			vo.setReplyCnt(plazaService.getreplyCnt(vo.getIdx())==null?0:plazaService.getreplyCnt(vo.getIdx()));

			List<BoardReplyVO> replyVos = plazaService.getReplyList(vo.getIdx());
			for(BoardReplyVO revo : replyVos) {
				int rereplyCnt = plazaService.getrereplyCnt(revo.getIdx())==null ? 0 : plazaService.getrereplyCnt(revo.getIdx());
				revo.setRereplyCnt(rereplyCnt);
				revo.setContent(revo.getContent().replace("<", "&lt;"));
				revo.setContent(revo.getContent().replace(">", "&gt;"));
			}
			replyList.add(replyVos);
		}
		
		model.addAttribute("vos", vos);
		model.addAttribute("replyList", replyList);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("orderBy", orderBy);
		return "admin/plaza/freeBoard";
	}
	
	@ResponseBody
	@RequestMapping(value="/member/deleteMember", method = RequestMethod.POST)
	public void deleteMemberPost(String nick) {
		adminService.deleteMember(nick);
	}
	@ResponseBody
	@RequestMapping(value="/member/goodByeMember", method = RequestMethod.POST)
	public void goodByeMemberPost(String nick) {
		memberService.goodByeMember(nick);
	}
	
	@RequestMapping(value="/member/memberDetail", method = RequestMethod.GET)
	public String memberDetailGet(Model model, String nick) {
		MemberVO vo = memberService.getMemberVOByNickName(nick);
		model.addAttribute("vo", vo);
		return "admin/member/memberDetail";
	}
	
	@RequestMapping(value="/member/sendMail", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String sendMailPost(String to, String title, String content, String nick) {
		
		try {
			// 메일 보내기
			title = ">>>[TSC]"+nick+"님, "+title;
			content = ""
					+ "        <div style='border: 3px solid #d35;padding:30px;margin:0 auto;width:600px;'>"
					+ "			    <h1 style='text-align: center;letter-spacing: 1em;'>TSC</h1>"
					+ "				<p style='background-color:#eee;padding:30px;'>" +content
					+ "			   </p><p><img src='cid:mail.png' width='600px'></p>"
					+ "			   <h3>예술과 삶 사이의 문화, 현재의 예술 TSC</h3><hr>"	
									+ " <div class=\"footer\" style=\"background-color: #ddd; padding: 20px 40px;\">"
									+ "	<div style=\"width:100%; margin:0 auto;\">"
										+ "	<a>이용약관</a>"
										+ "	<a>개인정보처리방침</a>"
										+ "	<a href=\"${ctp}/support/home\">고객센터</a>"
										+ "	<a>의견수렴</a>"
										+ "	<hr/>"
										+ "	고객센터 1588-2188 (09:20 ~ 17:50 평일)<br/>"
										+ "	Copyright &copy; The Scesent. All Rights reserved.<br/>"
									+ "	</div>"
								+ "</div>"
					+ "        </div>";
			
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			messageHelper.setTo(to);
			messageHelper.setSubject(title);
			
			content = content.replace("\n", "<br>");
			messageHelper.setText(content, true);
			FileSystemResource file = new FileSystemResource("C:\\JavaCourse\\SpringProject\\cjs2108_cjr\\src\\main\\webapp\\resources\\images\\mail\\mail.png");
			messageHelper.addInline("mail.png", file);
			
			mailSender.send(message);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
		return "redirect:/msg/sendMailOk";
	}
	@RequestMapping(value="/setPerform/sendMail", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String sendMailToManagerPost(String to, String title, String content, String nick) {
		
		try {
			// 메일 보내기
			title = ">>>[TSC]"+nick+"님, "+title;
			content = ""
					+ "        <div style='border: 3px solid #d35;padding:30px;margin:0 auto;width:600px;'>"
					+ "			    <h1 style='text-align: center;letter-spacing: 1em;'>TSC</h1>"
					+ "				<p style='background-color:#eee;padding:30px;'>" +content
					+ "			   </p><p><img src='cid:mail.png' width='600px'></p>"
					+ "			   <h3>예술과 삶 사이의 문화, 현재의 예술 TSC</h3><hr>"	
					+ " <div class=\"footer\" style=\"background-color: #ddd; padding: 20px 40px;\">"
					+ "	<div style=\"width:100%; margin:0 auto;\">"
					+ "	<a>이용약관</a>"
					+ "	<a>개인정보처리방침</a>"
					+ "	<a href=\"${ctp}/support/home\">고객센터</a>"
					+ "	<a>의견수렴</a>"
					+ "	<hr/>"
					+ "	고객센터 1588-2188 (09:20 ~ 17:50 평일)<br/>"
					+ "	Copyright &copy; The Scesent. All Rights reserved.<br/>"
					+ "	</div>"
					+ "</div>"
					+ "        </div>";
			
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			messageHelper.setTo(to);
			messageHelper.setSubject(title);
			
			content = content.replace("\n", "<br>");
			messageHelper.setText(content, true);
			FileSystemResource file = new FileSystemResource("C:\\JavaCourse\\SpringProject\\cjs2108_cjr\\src\\main\\webapp\\resources\\images\\mail\\mail.png");
			messageHelper.addInline("mail.png", file);
			
			mailSender.send(message);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
		return "redirect:/msg/sendMailOkreturntoperformList";
	}
	
	@ResponseBody
	@RequestMapping(value="/support/notice/changeImportant", method = RequestMethod.POST)
	public void changeImportantPost(int idx, String pm) {
		adminService.changeImportant(idx, pm);
	}
	
	@RequestMapping(value="/member/official", method = RequestMethod.GET)
	public String official(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getNewOffialApplyCnt()==null?0:adminService.getNewOffialApplyCnt();
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<OfficialVO> vos = adminService.getNewOffialApply(pagingVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		return "admin/member/official";
	}
	
	@RequestMapping(value="/member/officialList", method = RequestMethod.GET)
	public String officialList(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getOffialCnt(keyWord)==null?0:adminService.getOffialCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<OfficialVO> vos = adminService.getOffialList(keyWord, orderBy, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		return "admin/member/officialList";
	}
	
	@RequestMapping(value="/member/officialDetail", method = RequestMethod.GET)
	public String officialDetailGet(String nick, Model model) {
		OfficialVO vo = supportService.getOfficialVO(nick);
		model.addAttribute("vo", vo);
		return "admin/member/officialDetail";
	}
	
	@RequestMapping(value="/member/officialDelete", method = RequestMethod.GET)
	public String officialDeleteGet(String nick) {
		adminService.deleteOfficialVO(nick);
		return "redirect:/msg/officialDeleteOk";
	}
	
	@RequestMapping(value="/member/officialLevelUp", method = RequestMethod.GET)
	public String officialLevelUpGet(String nick) {
		adminService.officialLevelUp(nick);
		adminService.changeMemberLevel(nick, 1);
		return "redirect:/msg/officialLevelUpOk";
	}
	
	@RequestMapping(value="/setMain/addMainVideo", method = RequestMethod.POST)
	public String addMainVideoPost(MultipartFile file, String title, String subMent) {
		AdvertiseVO vo = new AdvertiseVO();
		vo.setAdtype("main");
		vo.setTitle(title);
		vo.setSubMent(subMent);
		adminService.inputAdv(file, vo);
		return "redirect:/admin/setMain/setMainAd";
	}
	
	@ResponseBody
	@RequestMapping(value="/setMain/advCheckFalse", method = RequestMethod.POST)
	public String advCheckFalsePost(int idx) {
		AdvertiseVO vo = adminService.getAdvertise(idx);
		int cnt = adminService.getAdvertiseCnt(vo.getAdtype())==null?0:adminService.getAdvertiseCnt(vo.getAdtype());
		if(cnt>1) {
			adminService.advertiseCheckFalse(idx);			
			return "true";
		} else {		
			return "false";
		}
	}
	@ResponseBody
	@RequestMapping(value="/setMain/advCheckTrue", method = RequestMethod.POST)
	public void advCheckTruePost(int idx) {
		adminService.advertiseCheckTrue(idx);
	}
	@ResponseBody
	@RequestMapping(value="/setMain/deleteAdv", method = RequestMethod.POST)
	public String deleteAdvPost(int idx) {
		AdvertiseVO vo = adminService.getAdvertise(idx);
		int cnt = adminService.getAdvertiseCnt(vo.getAdtype())==null?0:adminService.getAdvertiseCnt(vo.getAdtype());
		if(cnt>1) {
			adminService.deleteAdvertise(idx);
			return "true";
		} else {		
			return "false";
		}
	}
	
	@RequestMapping(value="/setMain/addBanner", method = RequestMethod.POST)
	public String addBannerPost(MultipartFile file) {
		AdvertiseVO vo = new AdvertiseVO();
		vo.setAdtype("banner");
		vo.setTitle("");
		vo.setSubMent("");
		adminService.inputAdv(file, vo);
		return "redirect:/admin/setMain/setMainAd";
	}
	@RequestMapping(value="/setMain/addSlim", method = RequestMethod.POST)
	public String addSlimPost(MultipartFile file) {
		AdvertiseVO vo = new AdvertiseVO();
		vo.setAdtype("slim");
		vo.setTitle("");
		vo.setSubMent("");
		adminService.inputAdv(file, vo);
		return "redirect:/admin/setMain/setMainAd";
	}
	@RequestMapping(value="/setMain/addCard", method = RequestMethod.POST)
	public String addCardPost(MultipartFile file) {
		AdvertiseVO vo = new AdvertiseVO();
		vo.setAdtype("card");
		vo.setTitle("");
		vo.setSubMent("");
		adminService.inputAdv(file, vo);
		return "redirect:/admin/setMain/setMainAd";
	}
	
	@ResponseBody
	@RequestMapping(value="/ticketingdata", method = RequestMethod.POST)
	public List<TicketingVO> ticketingdataPost() {
		List<TicketingVO> vos = adminService.getTicketsSalesData();
		
		return vos;
	}
	
	@ResponseBody
	@RequestMapping(value="/getRegionTicketSales", method = RequestMethod.POST)
	public List<RegionTicketSalesVO> getRegionTicketSalesPost() {
		List<RegionTicketSalesVO> vos = adminService.getRegionTicketSales();
		return vos;
	}
	
	@ResponseBody
	@RequestMapping(value="/member/deleteOfficialApply", method = RequestMethod.POST)
	public String deleteOfficialApplyPost(String nick) {
		adminService.deleteOfficialApply(nick);
		return "";
	}
	
	@ResponseBody
	@RequestMapping(value="/setPerform/batchDeletePerformSchedule", method = RequestMethod.POST)
	public String batchDeletePerformSchedulePost(int performIdx, String date) {
		
		performService.deletePerformScheduleInDate(performIdx, date);
		return "";
	}
	
	@RequestMapping(value="/plaza/replies", method = RequestMethod.GET)
	public String repliesGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = adminService.getTotReplyCnt(keyWord)==null ? 0 : adminService.getTotReplyCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<BoardReplyVO> vos = adminService.getRepliesList(keyWord, pagingVO.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("keyWord", keyWord);
		return "admin/plaza/replies";
	}
	
	@ResponseBody
	@RequestMapping(value="/plaza/getEmail", method = RequestMethod.POST)
	public String getEmail(String nick) {
		return adminService.getEmailByNick(nick);
	}
	
	@RequestMapping(value="/setplaza/sendMail", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String sendMailToReplierPost(String to, String title, String content, String nick) {
		
		try {
			// 메일 보내기
			title = ">>>[TSC]"+nick+"님, "+title;
			content = ""
					+ "        <div style='border: 3px solid #d35;padding:30px;margin:0 auto;width:600px;'>"
					+ "			    <h1 style='text-align: center;letter-spacing: 1em;'>TSC</h1>"
					+ "				<p style='background-color:#eee;padding:30px;'>" +content
					+ "			   </p><p><img src='cid:mail.png' width='600px'></p>"
					+ "			   <h3>예술과 삶 사이의 문화, 현재의 예술 TSC</h3><hr>"	
					+ " <div class=\"footer\" style=\"background-color: #ddd; padding: 20px 40px;\">"
					+ "	<div style=\"width:100%; margin:0 auto;\">"
					+ "	<a>이용약관</a>"
					+ "	<a>개인정보처리방침</a>"
					+ "	<a href=\"${ctp}/support/home\">고객센터</a>"
					+ "	<a>의견수렴</a>"
					+ "	<hr/>"
					+ "	고객센터 1588-2188 (09:20 ~ 17:50 평일)<br/>"
					+ "	Copyright &copy; The Scesent. All Rights reserved.<br/>"
					+ "	</div>"
					+ "</div>"
					+ "        </div>";
			
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			messageHelper.setTo(to);
			messageHelper.setSubject(title);
			
			content = content.replace("\n", "<br>");
			messageHelper.setText(content, true);
			FileSystemResource file = new FileSystemResource("C:\\JavaCourse\\SpringProject\\cjs2108_cjr\\src\\main\\webapp\\resources\\images\\mail\\mail.png");
			messageHelper.addInline("mail.png", file);
			
			mailSender.send(message);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
		return "redirect:/msg/sendMailOkreturntoreplies";
	}
	
	@ResponseBody
	@RequestMapping(value="/plaza/deleteReply", method = RequestMethod.POST)
	public String deleteReplyPost(int idx) {
		adminService.deleteReply(idx);
		return "";
	}
	
	@ResponseBody
	@RequestMapping(value = "/plaza/deleteBoard", method = RequestMethod.POST)
	public String deleteBoardPost(int idx) {
		plazaService.deleteBoard(idx);
		return "";
	}
}

