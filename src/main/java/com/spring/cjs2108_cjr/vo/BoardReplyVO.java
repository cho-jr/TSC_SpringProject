package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class BoardReplyVO {
	private int idx;
	private int boardIdx;
	private String nick;
	private String content;
	private String wDate;
	private int replyIdx;
	
	// 대댓 개수
	private int rereplyCnt;
	
	private String rewdate;
}
