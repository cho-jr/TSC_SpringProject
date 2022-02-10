package com.spring.cjs2108_cjr;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MessageController {
	@RequestMapping(value="/msg/{msgFlag}", method = RequestMethod.GET)
	public String msgGet(@PathVariable String msgFlag, Model model, HttpSession session) {
		String nick = session.getAttribute("sNick")==null ? "" : (String) session.getAttribute("sNick");
		
		if(msgFlag.equals("loginOk")) {
			model.addAttribute("msg", nick + "님, 로그인 되었습니다. ");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("loginNo")) {
			model.addAttribute("msg", "일치하는 회원 정보가 없습니다. ");
			model.addAttribute("url", "member/login");
		}
		else if(msgFlag.equals("joinFail")) {
			model.addAttribute("msg", "회원 가입에 실패했습니다. 정보 확인 바랍니다. ");
			model.addAttribute("url", "member/login");
		}
		else if(msgFlag.equals("joinSuccess")) {
			model.addAttribute("msg", "회원 가입되었습니다. 환영합니다!");
			model.addAttribute("url", "member/login");
		}
		else if(msgFlag.equals("logout")) {
			model.addAttribute("msg", "로그아웃 되었습니다. ");
			model.addAttribute("url", "member/login");
		}
		else if(msgFlag.equals("changePwdOk")) {
			model.addAttribute("msg", "비밀번호가 변경되었습니다. ");
			model.addAttribute("url", "member/login");
		}
		else if(msgFlag.equals("performRegistOk")) {
			model.addAttribute("msg", "새로운 작품이 등록되었습니다. 일정을 입력하세요");
			model.addAttribute("url", "admin/adContent");	
		}
		else if(msgFlag.equals("posterUploadFail")) {
			model.addAttribute("msg", "등록 실패.(포스터 파일 업로드 실패)");
			model.addAttribute("url", "admin/setPerform/newPerform");	
		}
		else if(msgFlag.equals("updatePerformOK")) {
			model.addAttribute("msg", "작품 정보가 업데이트 되었습니다. ");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("ticketingOk")) {
			model.addAttribute("msg", "정상적으로 예매되었습니다. 자세한 사항은 예매 내역에서 확인해주세요. ");
			model.addAttribute("url", "/member/mypage/myTickets/myTickets");	
		}
		else if(msgFlag.equals("updatePOK")) {
			model.addAttribute("msg", "공연 정보를 수정했습니다. ");
			model.addAttribute("url", "/member/mypage/myPerform/performList");	
		}
		else if(msgFlag.equals("pleaseLogin")) {
			model.addAttribute("msg", "로그인이 필요한 서비스 입니다. ");
			model.addAttribute("url", "member/login");	
		}
		else if(msgFlag.equals("registNoticeOK")) {
			model.addAttribute("msg", "공지사항이 등록되었습니다. ");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("updateNoticeOK")) {
			model.addAttribute("msg", "공지사항이 수정되었습니다. ");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("registFAQOK")) {
			model.addAttribute("msg", "FAQ가 등록되었습니다. ");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("updateFAQOK")) {
			model.addAttribute("msg", "FAQ가 수정되었습니다. ");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("registFreeBoardOK")) {
			model.addAttribute("msg", "게시글이 등록되었습니다. ");
			model.addAttribute("url", "plaza/plaza");	
		}
		else if(msgFlag.equals("boardDeleteOk")) {
			model.addAttribute("msg", "게시글을 삭제했습니다. ");
			model.addAttribute("url", "plaza/plaza");	
		}
		else if(msgFlag.equals("unauthorizedAccess")) {
			model.addAttribute("msg", "허용되지 않은 접근입니다. ");
			model.addAttribute("url", "plaza/plaza");	
		}
		else if(msgFlag.equals("GoodBye")) {
			model.addAttribute("msg", "그동안 TSC 서비스를 이용해 주셔서 감사합니다.");
			model.addAttribute("url", "/");	
		}
		else if(msgFlag.equals("sendMailOk")) {
			model.addAttribute("msg", "메일 전송 완료.");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("officialDeleteOk")) {
			model.addAttribute("msg", "관계자 신청 기록이 삭제되었습니다. ");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("officialLevelUpOk")) {
			model.addAttribute("msg", "관계자로 등업되었습니다. ");
			model.addAttribute("url", "close");	
		}
		else if(msgFlag.equals("performRegistApplyOk")) {
			model.addAttribute("msg", "작품 등록 신청되었습니다. 관리자 승인 후 메인 페이지에 노출됩니다. ");
			model.addAttribute("url", "member/mypage/myPerform/performList");	
		}
		else if(msgFlag.equals("sendMailOkreturntoperformList")) {
			model.addAttribute("msg", "담당자에게 메일 전송했습니다. ");
			model.addAttribute("url", "admin/setPerform/adminPerformList");	
		}
		else if(msgFlag.equals("sendMailOkreturntoreplies")) {
			model.addAttribute("msg", "작성자에게 메일 전송했습니다. ");
			model.addAttribute("url", "admin/plaza/replies");	
		}
		else if(msgFlag.equals("deletePerformOk")) {
			model.addAttribute("msg", "공연 정보를 모두 삭제했습니다. ");
			model.addAttribute("url", "member/mypage/myPerform/performList");	
		}
		else if(msgFlag.equals("warn")) {
			model.addAttribute("msg", "작성 권한이 없습니다. ");
			model.addAttribute("url", "plaza/plaza");	
		}
		

		return "include/message";
	}
}
