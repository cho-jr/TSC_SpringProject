package com.spring.cjs2108_cjr.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_cjr.dao.PerformDAO;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.PerformInfoViewsVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.ReportVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;
import com.spring.cjs2108_cjr.vo.TheaterVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

@Service
public class PerformServiceImpl implements PerformService{
	@Autowired
	PerformDAO performDAO;

	@Override
	public List<PerformVO> getPerformList(String keyWord, String condition, String orderBy, int startIndexNo, int pageSize) {
		return performDAO.getPerformList(keyWord, condition, orderBy, startIndexNo, pageSize);
	}

	@Override
	public List<PerformVO> getPerformListAll(String orderBy) {
		return performDAO.getPerformListAll(orderBy);
	}

	@Override
	public PerformVO getPerformInfo(int idx) {
		return performDAO.getPerformInfo(idx);
	}

	@Override
	public List<PerformScheduleVO> getPerformScheduleList(int idx) {
		
		return performDAO.getPerformScheduleList(idx);
	}

	@Override
	public void registPerformSchedule(PerformScheduleVO vo) {
		performDAO.registPerformSchedule(vo);
	}

	@Override
	public PerformScheduleVO getPerformSchedule(String schedule, int performIdx) {
		return performDAO.getPerformSchedule(schedule, performIdx);
	}

	@Override
	public void deletePerformSchedule(int idx) {
		performDAO.deletePerformSchedule(idx);
	}

	@Override
	public List<PerformScheduleVO> getPerformTime(String schedule, int performIdx) {
		return performDAO.getPerformTime(schedule, performIdx);
	}

	@Override
	public PerformScheduleVO getPerformScheduleByIdx(int idx) {
		return performDAO.getPerformScheduleByIdx(idx);
	}

	@Override
	public void increaseTicketSales(int idx) {
		performDAO.increaseTicketSales(idx);
	}

	@Override
	public void addReview(ReviewVO vo) {
		performDAO.addReview(vo);
	}

	@Override
	public Integer getTotalReviewCnt(int idx) {
		return performDAO.getTotalReviewCnt(idx);
	}

	@Override
	public List<ReviewVO> getReviewList(int idx, int startIndexNo, int pageSize) {
		return performDAO.getReviewList(idx, startIndexNo, pageSize);
	}

	@Override
	public void deleteReview(int idx) {
		performDAO.deleteReview(idx);
	}

	@Override
	public Integer getReviewIdx(ReviewVO vo) {
		return performDAO.getReviewIdx(vo);
	}

	@Override
	public void updateReview(ReviewVO vo) {
		performDAO.updateReview(vo);
	}

	@Override
	public Double getReviewAvg(int idx) {
		return performDAO.getReviewAvg(idx);
	}

	@Override
	public void addReport(ReportVO vo) {
		performDAO.addReport(vo);
	}

	@Override
	public TheaterVO getTheaterVO(String theater) {
		return performDAO.getTheaterVO(theater);
	}

	@Override
	public void addViews(PerformInfoViewsVO pivVo) {
		performDAO.addViews(pivVo);
	}

	@Override
	public int getPerformCnt(String keyWord, String condition) {
		return performDAO.getPerformCnt(keyWord, condition);
	}

	@Override
	public List<String> getSelectedTheme() {
		return performDAO.getSelectedTheme();
	}

	@Override
	public List<String> getShowThemes() {
		return performDAO.getShowThemes();
	}

	@Override
	public List<Integer> getPerformsInTheme(String theme) {
		return performDAO.getPerformsInTheme(theme);
	}

	@Override
	public List<PerformVO> getPerformListByTheater(String theater) {
		return performDAO.getPerformListByTheater(theater);
	}

	@Override
	public TicketingVO getWatchCert(String nick, int idx) {
		return performDAO.getWatchCert(nick, idx);
	}

	@Override
	public List<PerformVO> getMyPerform(String email, int startIndexNo, int pageSize) {
		return performDAO.getMyPerform(email, startIndexNo, pageSize);
	}

	@Override
	public Integer getMyPerformCnt(String email) {
		return performDAO.getMyPerformCnt(email);
	}

	@Override
	public Integer getPerformInfoViews(int idx) {
		return performDAO.getPerformInfoViews(idx);
	}

	@Override
	public String posterUpload(MultipartFile fName) {
		String saveFileName = "";
		try {
			UUID uid = UUID.randomUUID();
			String oFileName = fName.getOriginalFilename();
			saveFileName = uid + "_" + oFileName;
			writeFile(fName, saveFileName);
		} catch (IOException e) {
			e.printStackTrace();
		}	
		return saveFileName;
	}
	
	private void writeFile(MultipartFile fName, String saveFileName) throws IOException {
		byte[] data = fName.getBytes();
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/perform/poster/");
		
		FileOutputStream fos = new FileOutputStream(uploadPath + saveFileName);
		fos.write(data);
		fos.close();
	}

	@Override
	public void uploadFileManage(String content) {
		
		if(content.indexOf("src=\"/") == -1) return;
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/ckeditor/");
		
		int position = 34;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
			String oriFilePath = uploadPath + imgFile;	// 원본 그림이 들어있는 '경로명+파일명'
			String copyFilePath = "";
				copyFilePath = request.getSession().getServletContext().getRealPath("/resources/images/perform/info/") + imgFile;
			
			fileCopyCheck(oriFilePath, copyFilePath);	// 원본그림이 복사될 위치로 복사작업처리하는 메소드
			
			if(nextImg.indexOf("src=\"/") == -1) {
				sw = false;
			}
			else {
				nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
			}
		}
	}
	
	// 실제 파일(ckeditor폴더)을 board폴더로 복사처리하는곳 
	private void fileCopyCheck(String oriFilePath, String copyFilePath) {
		File oriFile = new File(oriFilePath);
		File copyFile = new File(copyFilePath);
		
		try {
			FileInputStream  fis = new FileInputStream(oriFile);
			FileOutputStream fos = new FileOutputStream(copyFile);
			
			byte[] buffer = new byte[2048];
			int count = 0;
			while((count = fis.read(buffer)) != -1) {
				fos.write(buffer, 0, count);
			}
			fos.flush();
			fos.close();
			fis.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void registPerform(PerformVO vo) {
		performDAO.registPerform(vo);
	}

	@Override
	public Object getTheater(String theater) {
		return performDAO.getTheater(theater);
	}

	@Override
	public void registTheater(TheaterVO theaterVo) {
		performDAO.registTheater(theaterVo);
	}

	@Override
	public PerformVO getAllPerformInfo(int idx) {
		return performDAO.getAllPerformInfo(idx);
	}

	@Override
	public void imgCopyTempFolder(String content) {
		if(content.indexOf("src=\"/") == -1) return;
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		int position = 38;
		String originPath = request.getSession().getServletContext().getRealPath("/resources/images/perform/info/");
		String copyPath = request.getSession().getServletContext().getRealPath("/resources/images/ckeditor/");
		
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0, nextImg.indexOf("\""));
			String originFilePath = originPath + imgFile;
			String copyFilePath = copyPath + imgFile;
			
			fileCopyCheck(originFilePath, copyFilePath);
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}

	@Override
	public void imgDelete(String content) {
		if(content.indexOf("src=\"/") == -1) return;
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String originPath = request.getSession().getServletContext().getRealPath("/resources/images/perform/info/");
		int position = 38;
		
		
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		while(sw) {
			String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
			String oriFilePath = originPath + imgFile;	// 원본 그림이 들어있는 '경로명+파일명'
			
			fileDelete(oriFilePath);	// 원본그림을 삭제처리하는 메소드
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}
	
	private void fileDelete(String oriFilePath) {
		File delFile = new File(oriFilePath);
		if(delFile.exists()) delFile.delete();
	}

	@Override
	public List<TheaterVO> getTheaterList() {
		return performDAO.getTheaterList();
	}

	@Override
	public void updatePerformExceptPoster(PerformVO vo) {
		performDAO.updatePerformExceptPoster(vo);
	}

	@Override
	public void deletePoster(String oriPosterFSN) {
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String originPath = request.getSession().getServletContext().getRealPath("/resources/");
		String oriFilePath = originPath + oriPosterFSN;
		fileDelete(oriFilePath);
	}

	@Override
	public void updatePerformAll(PerformVO vo) {
		performDAO.updatePerformAll(vo);
	}

	@Override
	public void getSchedule(int idx) {
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		
		// 오늘 날짜 저장
		Calendar calToday = Calendar.getInstance();
		int toYear = calToday.get(Calendar.YEAR);
		int toMonth = calToday.get(Calendar.MONTH);
		int toDay = calToday.get(Calendar.DATE);
				
		// 화면에 보여줄 해당년월을 셋팅하는 부분
		Calendar calView = Calendar.getInstance();
		int yy = request.getParameter("yy")==null ? calView.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("yy"));
		int mm = request.getParameter("mm")==null ? calView.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("mm"));
	  
		if(mm < 0) { // 1월에서 전월 버튼을 클릭시에 실행
			yy--;
			mm = 11;
		}
		if(mm > 11) { // 12월에서 다음월 버튼을 클릭시에 실행
			yy++;
			mm = 0;
		}
		calView.set(yy, mm, 1);
	  
		int startWeek = calView.get(Calendar.DAY_OF_WEEK);  // 해당 '년/월'의 1일에 해당하는 요일값을 가져온다.
		int lastDay = calView.getActualMaximum(Calendar.DAY_OF_MONTH);  // 해당월의 마지막일자를 구한다.
		
		// 화면에 보여줄 년월기준 전년도/다음년도를 구하기 위한 부분
		int prevYear = yy;  			// 전년도
		int prevMonth = (mm) - 1; // 이전월
		int nextYear = yy;  			// 다음년도
		int nextMonth = (mm) + 1; // 다음월
		
		if(prevMonth == -1) {  // 1월에서 전월 버튼을 클릭시에 실행..
			prevYear--;
			prevMonth = 11;
		}
		
		if(nextMonth == 12) {  // 12월에서 다음월 버튼을 클릭시에 실행..
			nextYear++;
			nextMonth = 0;
		}
	  
		// 이전달력과 다음달력처리부분
		Calendar calPre = Calendar.getInstance();  // 이전달력
		calPre.set(prevYear, prevMonth, 1);  // 이전 달력 셋팅
		int preLastDay = calPre.getActualMaximum(Calendar.DAY_OF_MONTH);  // 해당월의 마지막일자를 구한다.
		
		Calendar calNext = Calendar.getInstance();  // 다음달력
		calNext.set(nextYear, nextMonth, 1);  // 다음 달력 셋팅
		int nextStartWeek = calNext.get(Calendar.DAY_OF_WEEK);  // 다음달의 1일에 해당하는 요일값을 가져온다.
		
		// 아래는 sql 쿼리작업에서 dataformat의 비교형식을 맞춰주기위해 날짜형식을 변환하였다.
		// 해당월의 일자를 처리시에 값이 2021-1  -> 2021-01   , 2021-10 은 변환 불필요.
		String ym = "";
		int tmpMM = (mm + 1);
		if(tmpMM >= 1 && tmpMM <= 9) {
			ym = yy + "-0" + (mm + 1);
		}
		else {
			ym = yy + "-" + (mm + 1);
		}
		
		// 스케줄에 등록되어 있는 일정들을 가져오기
		List<PerformScheduleVO> vos = performDAO.getPerformScheduleListInThisMonth(idx, ym);
	  
		/* ---------  아래는  앞에서 처리된 값들을 모두 request객체에 담는다.  -----------------  */
		
		// 오늘기준 달력...
		request.setAttribute("toYear", toYear);
		request.setAttribute("toMonth", toMonth);
		request.setAttribute("toDay", toDay);
		
		// 화면에 보여줄 해당 달력...
		request.setAttribute("yy", yy);
		request.setAttribute("mm", mm);
		request.setAttribute("startWeek", startWeek);
		request.setAttribute("lastDay", lastDay);
		
		// 화면에 보여줄 해당 달력 기준의 전년도, 전월, 다음년도, 다음월 ...
		request.setAttribute("preYear", prevYear);
		request.setAttribute("preMonth", prevMonth);
		request.setAttribute("preLastDay", preLastDay);
		request.setAttribute("nextYear", nextYear);
		request.setAttribute("nextMonth", nextMonth);
		request.setAttribute("nextStartWeek", nextStartWeek);
		
		// 해당월에 자료들을 vos에 담는다.
		request.setAttribute("vos", vos);
		
	}

	@Override
	public AdvertiseVO getMainAdvertise() {
		List<Integer> idxList = performDAO.getAdvertiseIdxList("main");
		int rand = (int)(Math.random()*idxList.size());
		return performDAO.getOneAdvertise(idxList.get(rand));
	}

	@Override
	public List<AdvertiseVO> getBannerAdvList() {
		return performDAO.getBannerAdvList();
	}

	@Override
	public AdvertiseVO getSlimAdv() {
		List<Integer> idxList = performDAO.getAdvertiseIdxList("slim");
		int rand = (int)(Math.random()*idxList.size());
		return performDAO.getOneAdvertise(idxList.get(rand));
	}

	@Override
	public AdvertiseVO getCardAdv() {
		List<Integer> idxList = performDAO.getAdvertiseIdxList("card");
		int rand = (int)(Math.random()*idxList.size());
		return performDAO.getOneAdvertise(idxList.get(rand));
	}

	@Override
	public void deletePerformScheduleInDate(int performIdx, String date) {
		performDAO.deletePerformScheduleInDate(performIdx, date);
	}
}
