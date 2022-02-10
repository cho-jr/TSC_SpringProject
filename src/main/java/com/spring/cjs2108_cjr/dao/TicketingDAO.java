package com.spring.cjs2108_cjr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_cjr.vo.TicketingVO;

public interface TicketingDAO {

	public void registTicketing(@Param("vo") TicketingVO vo);

	public void printTicket(@Param("idx") int idx);

	public int getTicketNum(@Param("nick") String nick);

	public List<TicketingVO> getTicketsList(@Param("nick") String nick, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public TicketingVO getTicketInfo(@Param("idx") int idx);

	public void ticketCancle(@Param("idx") int idx);

	public int getTicketsListCnt(@Param("nick") String nick);

	public List<TicketingVO> getMyPerformTicketsList(@Param("idx") int idx);

	public Integer getTicketIdx(@Param("nick") String nick);

	public void setQRTicket(@Param("ticketIdx") int ticketIdx, @Param("img") String img);

	public String getQR(@Param("idx") int idx);

}
