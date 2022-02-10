package com.spring.cjs2108_cjr.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.cjs2108_cjr.dao.MemberDAO;
import com.spring.cjs2108_cjr.dao.SupportDAO;
import com.spring.cjs2108_cjr.vo.MemberVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;

@Service
public class MemberServiceImpl implements MemberService {
	@Autowired
	MemberDAO memberDAO;
	
	@Autowired
	SupportDAO supportDAO;

	@Override
	public MemberVO getMemberVO(String email) {
		return memberDAO.getMemberVO(email);
	}

	@Override
	public void updateLastDate(String email) {
		memberDAO.updateLastDate(email);
	}

	@Override
	public MemberVO getMemberVOByNickName(String nick) {
		return memberDAO.getMemberVOByNickName(nick);
	}

	@Override
	public void joinMember(MemberVO vo) {
		memberDAO.joinMember(vo);
	}

	@Override
	public void changePwd(String email, String pwd) {
		memberDAO.changePwd(email, pwd);
	}

	@Override
	public void earnPoints(String nick, int points) {
		memberDAO.earnPoints(nick, points);
	}

	@Override
	public void changeNick(String nick, String sNick) {
		memberDAO.changeNick(nick, sNick);
	}

	@Override
	public void changePhone(String phone, String nick) {
		memberDAO.changePhone(phone, nick);
	}

	@Override
	public void changeAddress(String addrCode, String addr1, String addr2, String addr3, String nick) {
		memberDAO.changeAddress(addrCode, addr1, addr2, addr3, nick);
	}

	@Override
	public List<QnaVO> getQnaList(String nick, int startIndexNo, int pageSize) {
		return supportDAO.getQnaList(nick, startIndexNo, pageSize);
	}

	@Override
	public int getQnaListCnt(String nick) {
		return supportDAO.getQnaListCnt(nick);
	}

	@Override
	public void addVisit(String sessionId, String hostIp) {
		memberDAO.addVisit(sessionId, hostIp);
	}

	@Override
	public void setVisitNick(String nick, String sessionId) {
		memberDAO.setVisitNick(nick, sessionId);
	}

	@Override
	public Integer getMyReviewCnt(String nick) {
		return memberDAO.getMyReviewCnt(nick);
	}

	@Override
	public List<ReviewVO> getMyReviewList(String nick, int startIndexNo, int pageSize) {
		return memberDAO.getMyReviewList(nick, startIndexNo, pageSize);
	}

	@Override
	public ReviewVO getReviewByIdx(int idx) {
		return memberDAO.getReviewByIdx(idx);
	}

	@Override
	public void goodByeMember(String nick) {
		memberDAO.goodByeMember(nick);
	}

	@Override
	public void deletePerform(int idx) {
		memberDAO.deletePerform(idx);
	}

	@Override
	public void updateRemainSeatNum(int scheduleIdx, String remainSeatNum) {
		memberDAO.updateRemainSeatNum(scheduleIdx, remainSeatNum);
	}

	@Override
	public Integer getWarn(String nick) {
		return memberDAO.getWarn(nick);
	}
}
