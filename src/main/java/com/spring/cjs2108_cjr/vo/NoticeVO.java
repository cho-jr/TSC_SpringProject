package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class NoticeVO {
	private int idx;
	private String title;
	private String content;
	private String wDate;
	private int views;
	private int important;
	
	// 수정용
	private String oriContent;
}
