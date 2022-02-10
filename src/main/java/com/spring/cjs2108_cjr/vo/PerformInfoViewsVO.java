package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class PerformInfoViewsVO {
	private int idx;
	private String nick;
	private int performIdx;
	private String vDate;
	
	public PerformInfoViewsVO(String nick, int performIdx) {
		this.nick = nick;
		this.performIdx = performIdx;
	}
}


