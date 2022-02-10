package com.spring.cjs2108_cjr;

import java.util.Arrays;
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
import com.spring.cjs2108_cjr.service.AdminService;
import com.spring.cjs2108_cjr.service.MemberService;
import com.spring.cjs2108_cjr.service.PerformService;
import com.spring.cjs2108_cjr.service.PlazaService;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.BoardReplyVO;
import com.spring.cjs2108_cjr.vo.FreeBoardVO;
import com.spring.cjs2108_cjr.vo.RecommendVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;

@Controller
@RequestMapping("/plaza")
public class PlazaController {
	
	@Autowired
	PlazaService plazaService;

	@Autowired
	AdminService adminService;

	@Autowired
	MemberService memberService;
	
	@Autowired
	PerformService performService;
	
	@RequestMapping(value="/plaza")
	public String freeBoardGet(Model model, 
			@RequestParam(name = "keyWord", defaultValue = "", required = false) String keyWord,
			@RequestParam(name = "tab", defaultValue = "freeBoard", required = false) String tab,
			@RequestParam(name = "orderBy", defaultValue = "idx", required = false) String orderBy,
			@RequestParam(name="pag", defaultValue="1", required=false) int pag, 
			@RequestParam(name="pageSize", defaultValue="5", required=false) int pageSize
			) {
		int reviewsTotRecCnt = 0;
		int freeBoardTotRecCnt = 0;
		PagingVO reviewPagingVO = null;
		PagingVO freeBoardPagingVO = null;
		List<ReviewVO> reviewVos = null;
		List<FreeBoardVO> boardVos = null;
		
		reviewsTotRecCnt = adminService.getTotReviewCnt(keyWord)==null?0:adminService.getTotReviewCnt(keyWord);
		reviewPagingVO = new PagingVO(pag, pageSize, reviewsTotRecCnt);
		reviewVos = adminService.getAllReview(keyWord, orderBy, reviewPagingVO.getStartIndexNo(), pageSize);
		for(ReviewVO vo : reviewVos) {
			vo.setPerformTitle(performService.getPerformInfo(vo.getPerformIdx()).getTitle());
		}

		freeBoardTotRecCnt = plazaService.getFreeBoardCnt(keyWord)==null?0:plazaService.getFreeBoardCnt(keyWord);
		freeBoardPagingVO = new PagingVO(pag, pageSize, freeBoardTotRecCnt);
		boardVos = plazaService.getFreeBoardList(keyWord, freeBoardPagingVO.getStartIndexNo(), pageSize);
		for(FreeBoardVO vo : boardVos) {
			vo.setTitle(vo.getTitle().replace("<", "&lt;"));
			vo.setTitle(vo.getTitle().replace(">", "&gt;"));
			vo.setReplyCnt(plazaService.getreplyCnt(vo.getIdx())==null?0:plazaService.getreplyCnt(vo.getIdx()));
			int recommendCnt = plazaService.getBoardRecommendCnt(vo.getIdx())==null?0:plazaService.getBoardRecommendCnt(vo.getIdx());
			vo.setRecommendCnt(recommendCnt);
		}
		
		
		// 인기글
		int inssafreeBoardTotRecCnt = plazaService.getFreeBoardCnt("")==null?0:plazaService.getFreeBoardCnt("");
		List<FreeBoardVO> inssaVos = plazaService.getFreeBoardList("", 0, inssafreeBoardTotRecCnt);
		for(FreeBoardVO vo : inssaVos) {
			vo.setTitle(vo.getTitle().replace("<", "&lt;"));
			vo.setTitle(vo.getTitle().replace(">", "&gt;"));
			vo.setReplyCnt(plazaService.getreplyCnt(vo.getIdx())==null?0:plazaService.getreplyCnt(vo.getIdx()));
			vo.setRecentReplyCnt(plazaService.getRecentReplyCnt(vo.getIdx())==null?0:plazaService.getRecentReplyCnt(vo.getIdx()));
			int recommendCnt = plazaService.getBoardRecommendCnt(vo.getIdx())==null?0:plazaService.getBoardRecommendCnt(vo.getIdx());
			vo.setRecommendCnt(recommendCnt);
		}
		FreeBoardVO tempVo = null;
		for(int i=1; i<inssaVos.size(); i++) {
			for(int j=0; j<inssaVos.size()-i; j++) {
				int jscore = inssaVos.get(j).getRecentReplyCnt()*30 
						+ inssaVos.get(j).getReplyCnt()*10 
						+ inssaVos.get(j).getRecommendCnt()*20 
						+ inssaVos.get(j).getViews();
				inssaVos.get(j).setScore(jscore);
				int j2score = inssaVos.get(j+1).getRecentReplyCnt()*30 
						+ inssaVos.get(j+1).getReplyCnt()*10 
						+ inssaVos.get(j+1).getRecommendCnt()*20 
						+ inssaVos.get(j+1).getViews();
				if(jscore<j2score) {
					tempVo = inssaVos.get(j);
					inssaVos.set(j, inssaVos.get(j+1));
					inssaVos.set(j+1, tempVo);
				}
			}
		}                
		inssaVos = inssaVos.subList(0, 5);
		
		model.addAttribute("reviewVos", reviewVos);
		model.addAttribute("boardVos", boardVos);
		model.addAttribute("inssaVos", inssaVos);
		
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		AdvertiseVO SAVo2 = performService.getSlimAdv();
		
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("SAVo2", SAVo2);
		
		model.addAttribute("keyWord", keyWord);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("reviewPagingVO", reviewPagingVO);
		model.addAttribute("freeBoardPagingVO", freeBoardPagingVO);
		model.addAttribute("tab", tab);
		
		return "plaza/plaza";
	}
	
	@RequestMapping(value = "/newFreeBoard", method = RequestMethod.GET)
	public String newFreeBoardGet(HttpSession session, Model model) {
		String nick = (String) session.getAttribute("sNick");
		if(nick!=null) {
			int warn = memberService.getWarn(nick);
			if(warn > 5) return "redirect:/msg/warn";			
		}
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		AdvertiseVO SAVo2 = performService.getSlimAdv();
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("SAVo2", SAVo2);
		return "plaza/newFreeBoard";
	}
	@RequestMapping(value = "/newFreeBoard", method = RequestMethod.POST)
	public String newFreeBoardPost(FreeBoardVO vo) {
		if(vo.getNick().equals("") || vo.getNick()==null) {
			return "redirect:/msg/pleaseLogin";
		}
		int warn = memberService.getWarn(vo.getNick());
		if(warn > 5) return "redirect:/msg/warn";
		vo.setTitle(vo.getTitle().trim());
		vo.setTitle(vo.getTitle().replace("<", "&lt;"));
		vo.setTitle(vo.getTitle().replace(">", "&gt;"));
		
		plazaService.uploadFileManage(vo.getContent());
		
		// content 내 img 경로를 이동시킨 폴더로 변경
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/plaza/"));
		
		
		plazaService.registFreeBoard(vo);
		return "redirect:/msg/registFreeBoardOK";
	}
	
	@RequestMapping(value="/freeBoardDetail")
	public String freeBoardDetailGet(HttpSession session, Model model, int idx) {
		// 조회수 증가
		String resdBoardStr = (String) session.getAttribute("readBoard");
		String[] readBoard = resdBoardStr==null ? new String[1] :resdBoardStr.split("/");
		if(!Arrays.stream(readBoard).anyMatch(String.valueOf(idx)::equals)) {
			plazaService.addFreeBoardViews(idx);
			resdBoardStr = resdBoardStr==null?String.valueOf(idx):resdBoardStr+"/"+String.valueOf(idx);
			session.setAttribute("readBoard", resdBoardStr);
		}
		// 현재글, 이전글, 다음글
		FreeBoardVO vo = plazaService.getFreeBoardVO(idx);
		FreeBoardVO prevVo = plazaService.getPrevFreeBoardVO(idx);
		FreeBoardVO nextVo = plazaService.getNextFreeBoardVO(idx);
		
		vo.setTitle(vo.getTitle().replace("<", "&lt;"));
		vo.setTitle(vo.getTitle().replace(">", "&gt;"));
		if(prevVo!=null) {
			prevVo.setTitle(prevVo.getTitle().replace("<", "&lt;"));
			prevVo.setTitle(prevVo.getTitle().replace(">", "&gt;"));
		}
		if(nextVo!=null) {
			nextVo.setTitle(nextVo.getTitle().replace("<", "&lt;"));
			nextVo.setTitle(nextVo.getTitle().replace(">", "&gt;"));
		}
		// 댓글
		List<BoardReplyVO> replyVos = plazaService.getReplyList(idx);
		for(BoardReplyVO revo : replyVos) {
			int rereplyCnt = plazaService.getrereplyCnt(revo.getIdx())==null ? 0 : plazaService.getrereplyCnt(revo.getIdx());
			revo.setRereplyCnt(rereplyCnt);
			revo.setContent(revo.getContent().replace("<", "&lt;"));
			revo.setContent(revo.getContent().replace(">", "&gt;"));
		}
		
		// 게시글 추천수
		int recommendCnt = plazaService.getBoardRecommendCnt(idx)==null?0:plazaService.getBoardRecommendCnt(idx);
		vo.setRecommendCnt(recommendCnt);
		
		// 로그인 한 회원의 선택한 글 추천 여부
		String nick = (String)session.getAttribute("sNick");
		RecommendVO recoVo = null;
		if(nick != null) {
			recoVo = plazaService.getRecommendVo(idx, nick);
		}
		
		
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		AdvertiseVO SAVo2 = performService.getSlimAdv();
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("SAVo2", SAVo2);
		
		model.addAttribute("vo", vo);
		model.addAttribute("prevVo", prevVo);
		model.addAttribute("nextVo", nextVo);
		model.addAttribute("replyVos", replyVos);
		model.addAttribute("recoVo", recoVo);
		
		return "/plaza/freeBoardDetail";
	}
	
	@ResponseBody
	@RequestMapping(value="/freeBoard/addReply")
	public String addReplyPost(BoardReplyVO vo) {
		int warn = memberService.getWarn(vo.getNick());
		if(warn > 5) return "fail";
		vo.setReplyIdx(0);
		plazaService.addReply(vo);
		return "";
	}
	
	@ResponseBody
	@RequestMapping(value="/freeBoard/addReReply")
	public String addReReplyPost(BoardReplyVO vo) {
		int warn = memberService.getWarn(vo.getNick());
		if(warn > 5) return "fail";
		vo.setContent(vo.getContent().replace("<", "&lt;"));
		vo.setContent(vo.getContent().replace(">", "&gt;"));
		plazaService.addReply(vo);
		return "";
	}
	
	@ResponseBody
	@RequestMapping(value="/freeBoard/getReReply")
	public List<BoardReplyVO> getReReplyPost(int idx) {
		List<BoardReplyVO> vos = plazaService.getReReply(idx);
		for(BoardReplyVO vo : vos) {
			vo.setRewdate(vo.getWDate());
			vo.setContent(vo.getContent().replace("<", "&lt;"));
			vo.setContent(vo.getContent().replace(">", "&gt;"));
		}
		return vos;
	}
	
	@ResponseBody
	@RequestMapping(value="/freeBoard/deleteReReply")
	public void deleteReReplyPost(int idx) {
		int rereplyCnt = plazaService.getrereplyCnt(idx)==null ? 0 : plazaService.getrereplyCnt(idx);
		if(rereplyCnt==0) {
			plazaService.deleteReReply(idx);			
		} else {
			plazaService.resetReReply(idx);
		}
	}
	
	// 댓글 수정 등록
	@ResponseBody
	@RequestMapping(value="/freeBoard/updateReply", method = RequestMethod.POST)
	public void updateReplyPost(int idx, String content) {
		content.replace("<", "&lt;");
		content.replace(">", "&gt;");
		plazaService.updateReply(idx, content);
	}
	
	// 게시판 글 삭제
	@RequestMapping(value="/freeBoard/deleteBoard", method = RequestMethod.GET)
	public String deleteBoardGet(int idx) {
		// 이미지도 삭제해야함
		plazaService.imgDelete(plazaService.getFreeBoardVO(idx).getContent());
		plazaService.deleteBoard(idx);
		return "redirect:/msg/boardDeleteOk";
	}
	
	// 게시판 글 수정 폼 띄우기
	@RequestMapping(value = "/freeBoard/updateFreeBoard", method = RequestMethod.GET)
	public String updateFreeBoardGet(HttpSession session, Model model, int idx) {
		
		FreeBoardVO vo = plazaService.getFreeBoardVO(idx);
		if(!vo.getNick().equals( (String) session.getAttribute("sNick") )) {
			return "redirect:/msg/unauthorizedAccess";
		}

		// 임시 폴더에 복사해둠	'/images/ckeditor' 폴더에!
		if(vo.getContent().indexOf("src=\"/") != -1) plazaService.imgCopyTempFolder(vo.getContent());
		
		List<AdvertiseVO> BAVos = performService.getBannerAdvList();
		AdvertiseVO SAVo1 = performService.getSlimAdv();
		AdvertiseVO SAVo2 = performService.getSlimAdv();
		model.addAttribute("BAVos", BAVos);
		model.addAttribute("SAVo1", SAVo1);
		model.addAttribute("SAVo2", SAVo2);
		
		
		model.addAttribute("vo", vo);
		return "plaza/updateFreeBoard";
	}
	// 게시글 수정 등록
	@RequestMapping(value = "/freeBoard/updateFreeBoard", method = RequestMethod.POST)
	public String updateFreeBoardPost(FreeBoardVO vo) {
		if(vo.getOriContent().indexOf("src=\"/") != -1) plazaService.imgDelete(vo.getOriContent());
		vo.setContent(vo.getContent().replace("/images/plaza/", "/images/ckeditor/"));
		plazaService.uploadFileManage(vo.getContent());
		vo.setContent(vo.getContent().replace("/images/ckeditor/", "/images/plaza/"));	
		
		plazaService.updateFreeBoard(vo);
		return "redirect:/plaza/freeBoardDetail?idx="+vo.getIdx();
	}
	
	@ResponseBody
	@RequestMapping(value="/freeBoard/boardRecommend", method = RequestMethod.POST)
	public String boardRecommendPost(RecommendVO vo) {
		plazaService.addRecommend(vo);
		return "";
	}
	@ResponseBody
	@RequestMapping(value="/freeBoard/boardRecommendCancle", method = RequestMethod.POST)
	public String boardRecommendCanclePost(RecommendVO vo) {
		plazaService.cancleRecommend(vo);
		return "";
	}
	
}
