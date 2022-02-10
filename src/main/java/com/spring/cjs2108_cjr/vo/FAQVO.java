package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class FAQVO {
	private int idx;
	private String question;
	private String answer;
	private int views;
	
	
	// 수정용
	private String oriAnswer;
}

