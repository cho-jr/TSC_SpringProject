package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class FreeBoardVO {
	private int idx;
	private String nick;
	private String title;
	private String content;
	private String wDate;
	private int views;
	
	private int replyCnt;
	private String oriContent;
	private int recommendCnt;
	private int score;
	private int recentReplyCnt;
	
}
