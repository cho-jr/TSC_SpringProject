package com.spring.cjs2108_cjr.service;

import java.util.List;

import com.spring.cjs2108_cjr.vo.MemberVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;

public interface MemberService {

	public MemberVO getMemberVO(String email);

	public void updateLastDate(String email);

	public MemberVO getMemberVOByNickName(String nick);

	public void joinMember(MemberVO vo);

	public void changePwd(String email, String pwd);

	public void earnPoints(String nick, int points);

	public void changeNick(String nick, String sNick);

	public void changePhone(String phone, String nick);

	public void changeAddress(String addrCode, String addr1, String addr2, String addr3, String nick);

	public List<QnaVO> getQnaList(String nick, int startIndexNo, int pageSize);

	public int getQnaListCnt(String nick);

	public void addVisit(String sessionId, String hostIp);

	public void setVisitNick(String nick, String sessionId);

	public Integer getMyReviewCnt(String nick);

	public List<ReviewVO> getMyReviewList(String nick, int startIndexNo, int pageSize);

	public ReviewVO getReviewByIdx(int idx);

	public void goodByeMember(String email);

	public void deletePerform(int idx);

	public void updateRemainSeatNum(int scheduleIdx, String remainSeatNum);

	public Integer getWarn(String nick);
}
