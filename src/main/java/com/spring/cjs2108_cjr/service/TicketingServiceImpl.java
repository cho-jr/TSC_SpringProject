package com.spring.cjs2108_cjr.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.awt.image.BufferedImage;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.spring.cjs2108_cjr.dao.PerformDAO;
import com.spring.cjs2108_cjr.dao.TicketingDAO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

@Service
public class TicketingServiceImpl implements TicketingService {
	@Autowired
	TicketingDAO ticketingDAO;
	
	@Autowired
	PerformDAO performDAO;

	@Override
	public void registTicketing(TicketingVO vo) {
		ticketingDAO.registTicketing(vo);
		
		//performSchedule 가져와서 remainSeatNum 수정 후 다시 가져가서 저장!
		PerformScheduleVO scheduleVo = performDAO.getPerformScheduleByIdx(vo.getPerformScheduleIdx());
		
		String[] selectSeatArr = vo.getSelectSeatNum().split(",");
		String[] remainSeatArr = scheduleVo.getRemainSeatNum().split(",");
		String changeRemainSeat = "";
		for(int i = 0; i < remainSeatArr.length; i++) {
			changeRemainSeat += String.valueOf(Integer.parseInt(remainSeatArr[i])-Integer.parseInt(selectSeatArr[i])) + ",";
		}
		changeRemainSeat = changeRemainSeat.substring(0,changeRemainSeat.length()-1);
		performDAO.decreaseSeat(vo.getPerformScheduleIdx(), changeRemainSeat);
	}

	@Override
	public void printTicket(int idx) {
		ticketingDAO.printTicket(idx);
	}

	@Override
	public int getTicketNum(String nick) {
		return ticketingDAO.getTicketNum(nick);
	}

	@Override
	public List<TicketingVO> getTicketsList(String nick, int startIndexNo, int pageSize) {
		return ticketingDAO.getTicketsList(nick, startIndexNo, pageSize);
	}

	@Override
	public TicketingVO getTicketInfo(int idx) {
		return ticketingDAO.getTicketInfo(idx);
	}

	@Override
	public void ticketCancle(int idx) {
		ticketingDAO.ticketCancle(idx);
	}

	@Override
	public int getTicketsListCnt(String nick) {
		return ticketingDAO.getTicketsListCnt(nick);
	}

	@Override
	public List<TicketingVO> getMyPerformTicketsList(int idx) {
		return ticketingDAO.getMyPerformTicketsList(idx);
	}

	@Override
	public Integer getTicketIdx(String nick) {
		return ticketingDAO.getTicketIdx(nick);
	}

	@Override
	public String createQRCode(String nick, int ticketIdx, String uploadPath, String url) {
		UUID uid = UUID.randomUUID();
		String strUid = uid.toString().substring(0,8);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String barCodeName = strUid + nick + sdf.format(new Date());
		try {
		    File file = new File(uploadPath);		// qr코드 이미지를 저장할 디렉토리 지정
			if(!file.exists()) {
			    file.mkdirs();
			}
			String codeurl = new String(url.getBytes("UTF-8"), "ISO-8859-1");	// qr코드 인식시 이동할 url 주소
			int qrcodeColor = 0xFF000000;			// qr코드 바코드 생성값(전경색) - 뒤의 6자리가 색상코드임
			int backgroundColor = 0xFFFFFFFF;	// qr코드 배경색상값
		
			QRCodeWriter qrCodeWriter = new QRCodeWriter();
			BitMatrix bitMatrix = qrCodeWriter.encode(codeurl, BarcodeFormat.QR_CODE,200, 200);
			
			MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrcodeColor,backgroundColor);
			BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix,matrixToImageConfig);
			
			ImageIO.write(bufferedImage, "png", new File(uploadPath + barCodeName + ".png"));		// ImageIO를 사용한 바코드 파일쓰기
			
			// DB에 qr코드 이미지 이름 저장
			ticketingDAO.setQRTicket(ticketIdx, barCodeName + ".png");
			
		} catch (Exception e) {
		    e.printStackTrace();
		}
		return barCodeName + ".png";
	}

	@Override
	public String getQR(int idx) {
		return ticketingDAO.getQR(idx);
	}
}
