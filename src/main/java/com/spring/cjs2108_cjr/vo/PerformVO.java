package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class PerformVO {
	private int idx;
	private String manager;
	private String title;
	private String theater;
	private String startDate;
	private String endDate;
	
	private String rating;
	private int runningTime;	
	private String seat;
	private String price;
	private String sale;
	private String salePrice;
	private String saleMethod;
	private String posterOGN;
	private String posterFSN;
	private String content;
	private boolean checked;
	private int ticketSales;
	
	// 극장 등록용
	private String address1;
	private String address2;
	private String address3;
	
	// 원본 content 저장용
	private String oriContent;
	
	// 원본 포스터 경로 저장용
	private String oriPosterFSN;

	// 별점
	private double star;
}
