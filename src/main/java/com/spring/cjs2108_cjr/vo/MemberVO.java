package com.spring.cjs2108_cjr.vo;

import lombok.Data;

@Data
public class MemberVO {
	private String nick;
	private String email;
	private String pwd;
	private String name;
	private String phone;
	private String birth;
	private String addrCode;
	private String addr1;
	private String addr2;
	private String addr3;
	private int level;
	private String joinDate;
	private String lastDate;
	private int point;
	private int warn;
}
