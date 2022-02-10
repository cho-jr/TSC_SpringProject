package com.spring.cjs2108_cjr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_cjr.vo.MemberVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;

public interface MemberDAO {

	public MemberVO getMemberVO(@Param("email") String email);

	public void updateLastDate(@Param("email") String email);

	public MemberVO getMemberVOByNickName(@Param("nick") String nick);

	public void joinMember(@Param("vo") MemberVO vo);

	public void changePwd(@Param("email") String email, @Param("pwd") String pwd);

	public void earnPoints(@Param("nick") String nick, @Param("points") int points);

	public void changeNick(@Param("nick") String nick, @Param("sNick") String sNick);

	public void changePhone(@Param("phone") String phone, @Param("nick") String nick);

	public void changeAddress(@Param("addrCode") String addrCode, @Param("addr1") String addr1, @Param("addr2") String addr2, @Param("addr3") String addr3, @Param("nick") String nick);

	public void addVisit(@Param("sessionId") String sessionId, @Param("hostIp") String hostIp);

	public void setVisitNick(@Param("nick") String nick, @Param("sessionId") String sessionId);

	public Integer getMyReviewCnt(@Param("nick") String nick);

	public List<ReviewVO> getMyReviewList(@Param("nick") String nick, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public ReviewVO getReviewByIdx(@Param("idx") int idx);

	public void goodByeMember(@Param("nick") String nick);

	public void deletePerform(@Param("idx") int idx);

	public void updateRemainSeatNum(@Param("idx") int scheduleIdx, @Param("remainSeatNum") String remainSeatNum);

	public Integer getWarn(@Param("nick") String nick);

}
