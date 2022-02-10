package com.spring.cjs2108_cjr;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.cjs2108_cjr.pagination.PagingVO;
import com.spring.cjs2108_cjr.service.MemberService;
import com.spring.cjs2108_cjr.service.PerformService;
import com.spring.cjs2108_cjr.service.SupportService;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.FAQVO;
import com.spring.cjs2108_cjr.vo.NoticeVO;
import com.spring.cjs2108_cjr.vo.OfficialVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.SuggestionVO;

@Controller
@RequestMapping("/support")
public class SupportController {
	@Autowired
	MemberService memberService;
	
	@Autowired
	SupportService supportService;
		
	@Autowired
	PerformService performService;
	
	@RequestMapping("/home")
	public String homeGet(Model model) {
		List<NoticeVO> noticeVos = supportService.getNoticeList("important", "", 0, 6);
		List<FAQVO> FAQVos = supportService.getFAQList("idx", "", 0, 6);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("noticeVos", noticeVos);
		model.addAttribute("FAQVos", FAQVos);
		return "support/home";
	}

	@RequestMapping(value="/qna", method = RequestMethod.GET)
	public String qnaGet(HttpSession session, Model model) {
		String nick = (String) session.getAttribute("sNick");
		String email = memberService.getMemberVOByNickName(nick).getEmail();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("email", email);
		return "support/qna";
	}

	@RequestMapping(value="/qna", method = RequestMethod.POST)
	public String qnaPost(QnaVO vo) {
		supportService.addQna(vo);
		return "redirect:/member/mypage/qna/qnaList"; 	
	}
	
	@RequestMapping(value="/notice/noticeList", method = RequestMethod.GET)
	public String noticeListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "important", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = supportService.getNoticeCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<NoticeVO> vos = supportService.getNoticeList(orderBy, keyWord, pagingVO.getStartIndexNo(), pageSize);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("keyWord", keyWord);
		return "support/notice/noticeList";
	}
	
	@RequestMapping(value="/notice/noticeDetail")
	public String noticeDetailGet(int idx, Model model) {
		// 선택한 공지사항 조회수 증가
		supportService.addNoticeView(idx);
		// 공지 상세보기로 이동
		NoticeVO vo = supportService.getNoticeVO(idx);
		NoticeVO prevVo = supportService.getPrevNoticeVO(idx);
		NoticeVO nextVo = supportService.getNextNoticeVO(idx);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vo", vo);
		model.addAttribute("prevVo", prevVo);
		model.addAttribute("nextVo", nextVo);
		
		return "support/notice/noticeDetail";
	}

	@RequestMapping(value="/FAQ/FAQList", method = RequestMethod.GET)
	public String FAQListGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int totRecCnt = supportService.getFAQCnt(keyWord)==null?0:supportService.getFAQCnt(keyWord);
		PagingVO pagingVO = new PagingVO(pag, pageSize, totRecCnt);
		List<FAQVO> vos = supportService.getFAQList(orderBy, keyWord, pagingVO.getStartIndexNo(), pageSize);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vos", vos);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("keyWord", keyWord);
		return "support/FAQ/FAQList";
	}
	
	@RequestMapping(value="/FAQ/FAQDetail")
	public String FAQDetailGet(int idx, Model model) {
		// 선택한 공지사항 조회수 증가
		supportService.addFAQView(idx);
		// 공지 상세보기로 이동
		FAQVO vo = supportService.getFAQVO(idx);
		FAQVO prevVo = supportService.getPrevFAQVO(idx);
		FAQVO nextVo = supportService.getNextFAQVO(idx);
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vo", vo);
		model.addAttribute("prevVo", prevVo);
		model.addAttribute("nextVo", nextVo);
		
		return "support/FAQ/FAQDetail";
	}
	

	@RequestMapping(value="/suggestion", method = RequestMethod.GET)
	public String suggestionGet(HttpSession session, Model model) {
		String nick = (String) session.getAttribute("sNick");
		String email = memberService.getMemberVOByNickName(nick).getEmail();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("email", email);
		return "support/suggestion";
	}
	

	@RequestMapping(value="/suggestion", method = RequestMethod.POST)
	public String suggestionPost(SuggestionVO vo) {
		supportService.addSuggestion(vo);
		return "redirect:/support/home"; 	
	}
	
	@RequestMapping(value="/memberLevel/info", method = RequestMethod.GET)
	public String memberLevelInfoGet() {
		return "support/memberLevel/info";
	}
	
	@RequestMapping(value="/ticketCancleInfo", method = RequestMethod.GET)
	public String ticketCancleInfoGet() {
		return "support/ticketCancleInfo";
	}

	@RequestMapping(value="/memberLevel/levelUpForm", method = RequestMethod.GET)
	public String levelUpFormGet(Model model, HttpSession session) {
		OfficialVO vo = supportService.getOfficialVO((String)session.getAttribute("sNick"));
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("vo", vo);
		return "support/memberLevel/levelUpForm";
	}
	
	@RequestMapping(value="/memberLevel/levelUpForm", method = RequestMethod.POST)
	public String levelUpFormPost(OfficialVO vo) {
		OfficialVO ovo = supportService.getOfficialVO(vo.getNick());
		if(ovo==null) {
			supportService.submitOfficialLevelUp(vo);			
		} else {
			// 기존 정보 업데이트
			supportService.updateOfficialInfo(vo);
		}
		return "redirect:/support/memberLevel/levelUpForm";
	}
	
	
}
