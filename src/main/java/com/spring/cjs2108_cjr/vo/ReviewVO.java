package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class ReviewVO {
	private int idx;
	private int performIdx;
	private String nick;
	private int star;
	private String reviewContent;
	private String wDate;
	
	//
	private String performTitle;
	private boolean watched;
}
