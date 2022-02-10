package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class TicketingVO {
	private int idx;
	private String memberNick;
	private int performIdx;
	private int performScheduleIdx;
	private String selectSeatNum;
	private int ticketNum;
	private int price;
	private boolean cancle;
	
	//결제창
	private int usePoint;
	private int finalPrice;
	private String payBy;
	private String payDate;
	private boolean print;
	
	// 공연 정보용 
	private String performTitle;
	private String performTheater;
	private String performSeat;
	private String performSchedule;
	private String posterFSN;
	
	
	
}
