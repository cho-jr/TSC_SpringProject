package com.spring.cjs2108_cjr.service;

import java.util.List;

import com.spring.cjs2108_cjr.vo.TicketingVO;

public interface TicketingService {

	public void registTicketing(TicketingVO vo);

	public void printTicket(int idx);

	public int getTicketNum(String nick);

	public List<TicketingVO> getTicketsList(String nick, int startIndexNo, int pageSize);

	public TicketingVO getTicketInfo(int idx);

	public void ticketCancle(int idx);

	public int getTicketsListCnt(String nick);

	public List<TicketingVO> getMyPerformTicketsList(int idx);

	public Integer getTicketIdx(String nick);

	public String createQRCode(String nick, int ticketIdx, String uploadPath, String url);

	public String getQR(int idx);


}
