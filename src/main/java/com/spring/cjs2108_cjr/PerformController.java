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

import com.spring.cjs2108_cjr.pagination.PagingVO;
import com.spring.cjs2108_cjr.service.MemberService;
import com.spring.cjs2108_cjr.service.PerformService;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.PerformInfoViewsVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.ReportVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;
import com.spring.cjs2108_cjr.vo.TheaterVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

@Controller
@RequestMapping("/perform")
public class PerformController {
	@Autowired
	PerformService performService;
	
	@Autowired
	MemberService memberService;
	
	@RequestMapping(value="/performList", method = RequestMethod.GET)
	public String performListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "ticketSales", required = false) String orderBy,
			@RequestParam(name = "condition", defaultValue = "proceeding", required = false) String condition
			) {
		int totRecCnt = performService.getPerformCnt(keyWord, condition);
		List<PerformVO> vos = performService.getPerformList(keyWord, condition, orderBy, 0, totRecCnt);
		for(PerformVO vo : vos) {
			double avg = performService.getReviewAvg(vo.getIdx())==null? 0.0: performService.getReviewAvg(vo.getIdx());
			vo.setStar(avg);
		}
		if(orderBy.equals("star")) {
			PerformVO tempVO = null;
			for(int i = 0; i < vos.size(); i++) {
				for(int j = i+1; j < vos.size(); j++) {
					if(vos.get(i).getStar()<vos.get(j).getStar()) {
						tempVO = vos.get(i);
						vos.set(i, vos.get(j));
						vos.set(j, tempVO);
					}
				}
			}
		}
		if(vos.size()<=3) {
			List<PerformVO> moreVos = performService.getPerformList("", "proceeding" , "ticketSales", 0, 6);
			model.addAttribute("moreVos", moreVos);
		}
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		AdvertiseVO CAVo1 = performService.getCardAdv();
		AdvertiseVO CAVo2 = performService.getCardAdv();
		model.addAttribute("vos", vos);
		model.addAttribute("condition", condition);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("CAVo1", CAVo1);
		model.addAttribute("CAVo2", CAVo2);
		model.addAttribute("SAVo1", SAVo1);
		return "perform/performList";
	}
	
	@RequestMapping(value="/performInfo")
	public String performInfoGet(int idx, Model model, HttpSession session, 
			@RequestParam(name="pag", defaultValue="1", required=false) int pag,
			@RequestParam(name="tab", defaultValue="", required=false) String tab
			) {
		// 공연 상세 페이지 방문수 증가
		String nick = (String) session.getAttribute("sNick");
		PerformInfoViewsVO pivVo = new PerformInfoViewsVO(nick, idx);
		performService.addViews(pivVo);
		
		String email = nick==null?"":memberService.getMemberVOByNickName(nick).getEmail();
		
		PerformVO vo = performService.getPerformInfo(idx);
		List<PerformScheduleVO> scheduleVos = performService.getPerformScheduleList(idx);
		
		TheaterVO theaterVo = performService.getTheaterVO(vo.getTheater());
		List<PerformVO> performVos = performService.getPerformListByTheater(vo.getTheater());
		
		int totReviewCnt = performService.getTotalReviewCnt(idx);
		PagingVO pagingVO = new PagingVO(pag, 5, totReviewCnt);
		// 리뷰페이징처리
		List<ReviewVO> reviewVos = performService.getReviewList(idx, pagingVO.getStartIndexNo(), 5);
		for(ReviewVO rvo : reviewVos) {
			TicketingVO watchedticket = performService.getWatchCert(rvo.getNick(), idx);
			if(watchedticket!=null) {
				rvo.setWatched(true);
			} else {
				rvo.setWatched(false);				
			}
		}
		// 리뷰 평점
		Double reviewAvg = performService.getReviewAvg(idx);
		if(reviewAvg==null) reviewAvg = 0.0;
		
		AdvertiseVO CAVo1 = performService.getCardAdv();
		AdvertiseVO CAVo2 = performService.getCardAdv();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("CAVo1", CAVo1);
		model.addAttribute("CAVo2", CAVo2);
		model.addAttribute("vo", vo);
		model.addAttribute("email", email);
		model.addAttribute("theaterVo", theaterVo);
		model.addAttribute("scheduleVos", scheduleVos);
		model.addAttribute("performVos", performVos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("reviewVos", reviewVos);
		model.addAttribute("reviewAvg", reviewAvg);
		model.addAttribute("tab", tab);
		return "perform/performInfo";
	}
	
	@ResponseBody
	@RequestMapping(value="/getPerformTime")
	public List<PerformScheduleVO> getPerformTimePost(String schedule, int performIdx) {
		return performService.getPerformTime(schedule, performIdx);
	}
	
	// 리뷰 추가
	@ResponseBody
	@RequestMapping(value="/addReview", method = RequestMethod.POST)
	public String addReviewPost(ReviewVO vo) { 
		if(vo.getNick().equals("")) return "fail";
		int warn = memberService.getWarn(vo.getNick());
		if(warn > 5) return "warn";
		
		performService.addReview(vo);
		int idx = performService.getReviewIdx(vo) == null?0:performService.getReviewIdx(vo);
		String res = String.valueOf(idx);
		if(performService.getWatchCert(vo.getNick(), vo.getPerformIdx())!=null) {
			res = res + "/ok";
		} else {
			res = res + "/no";
		}
		return res;
	}
	
	// 리뷰 삭제
	@ResponseBody
	@RequestMapping(value="/reviewDelete", method = RequestMethod.POST)
	public void reviewDeletePost(int idx) {
		performService.deleteReview(idx);
	}
	
	// 리뷰 신고
	@ResponseBody
	@RequestMapping(value="/reportReview", method = RequestMethod.POST)
	public void reportReviewPost(ReportVO vo) {
		performService.addReport(vo);
	}
	
}
