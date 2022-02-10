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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.cjs2108_cjr.dao.AdminDAO;
import com.spring.cjs2108_cjr.dao.PerformDAO;
import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.BoardReplyVO;
import com.spring.cjs2108_cjr.vo.FAQVO;
import com.spring.cjs2108_cjr.vo.FreeBoardVO;
import com.spring.cjs2108_cjr.vo.MemberVO;
import com.spring.cjs2108_cjr.vo.NoticeVO;
import com.spring.cjs2108_cjr.vo.OfficialVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.RegionTicketSalesVO;
import com.spring.cjs2108_cjr.vo.ReportVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;
import com.spring.cjs2108_cjr.vo.SuggestionVO;
import com.spring.cjs2108_cjr.vo.TheaterVO;
import com.spring.cjs2108_cjr.vo.ThemePerformVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;
import com.spring.cjs2108_cjr.vo.VisitDataVO;

@Service
public class AdminServiceImpl implements AdminService {
	@Autowired
	AdminDAO adminDAO;

	@Autowired
	PerformDAO performDAO;

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
	
	private void writeAdvFile(MultipartFile fName, String saveFileName) throws IOException {
		byte[] data = fName.getBytes();
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String uploadPath = request.getSession().getServletContext().getRealPath("/resources/images/advertise/");
		
		FileOutputStream fos = new FileOutputStream(uploadPath + saveFileName);
		fos.write(data);
		fos.close();
	}

	@Override
	public void uploadFileManage(String content, String place) {
		//     	 	   0         1         2       2 3   3     4         5
		//             012345678901234567890123456789012345678901234567890
		// <img alt="" src="/cjs2108_cjr/images/ckeditor/211229124318_4.jpg"
		// <img src="/cjs2108_cjr/images/perform/info/220103094244_환상동화1.jpg" style="height:794px; width:700px" />
		// <img alt="" src="/cjs2108_cjr/images/perform/info/220103094025_@culture_banner.jpg" style="height:56px; width:700px" />
		
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
			if(place.equals("performInfo")) {
				copyFilePath = request.getSession().getServletContext().getRealPath("/resources/images/perform/info/") + imgFile;
			} else if(place.equals("notice")) {
				copyFilePath = request.getSession().getServletContext().getRealPath("/resources/images/support/notice/") + imgFile;
			} else if(place.equals("FAQ")) {
				copyFilePath = request.getSession().getServletContext().getRealPath("/resources/images/support/FAQ/") + imgFile;
			}
			
			
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
		adminDAO.registPerform(vo);
	}

	@Override
	public TheaterVO getTheater(String name) {
		return adminDAO.getTheater(name);
	}

	@Override
	public void registTheater(TheaterVO theaterVo) {
		adminDAO.registTheater(theaterVo);
	}

	@Override
	public List<TheaterVO> getTheaterList(String keyWord, String orderBy, int startIndexNo, int pageSize) {
		return adminDAO.getTheaterList(keyWord, orderBy, startIndexNo, pageSize);
	}

	@Override
	public void imgCopyTempFolder(String content, String place) {
		if(content.indexOf("src=\"/") == -1) return;
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String originPath = "";
		int position = 0;
		if(place.equals("performInfo")) {
			originPath = request.getSession().getServletContext().getRealPath("/resources/images/perform/info/");
			position = 38;
		} else if(place.equals("notice")) {
			originPath = request.getSession().getServletContext().getRealPath("/resources/images/support/notice/");
			position = 40;
		} else if(place.equals("FAQ")) {
			originPath = request.getSession().getServletContext().getRealPath("/resources/images/support/FAQ/");
			position = 37;
		}
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
	public void imgDelete(String content, String place) {
		if(content.indexOf("src=\"/") == -1) return;
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String originPath = "";
		int position = 0;
		if(place.equals("performInfo")) {
			originPath = request.getSession().getServletContext().getRealPath("/resources/images/perform/info/");
			position = 38;
		} else if(place.equals("notice")) {
			originPath = request.getSession().getServletContext().getRealPath("/resources/images/support/notice/");
			position = 40;
		} else if(place.equals("FAQ")) {
			originPath = request.getSession().getServletContext().getRealPath("/resources/images/support/FAQ/");
			position = 37;
		}
		
		
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
	public void updatePerformExceptPoster(PerformVO vo) {
		adminDAO.updatePerformExceptPoster(vo);
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
		adminDAO.updatePerformAll(vo);
	}

	@Override
	public List<TicketingVO> getTicketsList(String orderBy, String keyWord, int startIndexNo, int pageSize, String date) {
		return adminDAO.getTicketsList(orderBy, keyWord,startIndexNo, pageSize, date);
	}

	@Override
	public void deleteTheater(int idx) {
		adminDAO.deleteTheater(idx);
	}

	@Override
	public void updateTheaterAddress(int idx, String address2) {
		adminDAO.updateTheaterAddress(idx, address2);
	}

	@Override
	public List<MemberVO> getMemberList(String orderBy) {
		return adminDAO.getMemberList(orderBy);
	}

	@Override
	public void changeMemberLevel(String nick, int level) {
		adminDAO.changeMemberLevel(nick, level);
	}

	@Override
	public List<MemberVO> getMemberSearch(String orderBy, String keyWord, int startIndexNo, int pageSize) {
		return adminDAO.getMemberSearch(orderBy, keyWord, startIndexNo, pageSize);
	}

	@Override
	public Integer getMemberCnt(String keyWord) {
		return adminDAO.getMemberCnt(keyWord);
	}

	@Override
	public Integer getTicketsListCnt(String keyWord, String date) {
		return adminDAO.getTicketListCnt(keyWord, date);
	}

	@Override
	public List<QnaVO> getQnaList(String keyWord, String condition, int startIndexNo, int pageSize) {
		return adminDAO.getQnaList(keyWord, condition, startIndexNo, pageSize);
	}

	@Override
	public void registAnswer(String answer, int idx) {
		adminDAO.registAnswer(answer, idx);
	}

	@Override
	public QnaVO getQnaVo(int idx) {
		return adminDAO.getQnaVo(idx);
	}

	@Override
	public int getTodayVisit() {
		return adminDAO.getTodayVisit();
	}

	@Override
	public int getTotalVisit() {
		return adminDAO.getTotalVisit();
	}

	@Override
	public Integer getAllQnaCnt(String keyWord, String condition) {
		return adminDAO.getAllQnaCnt(keyWord, condition);
	}

	@Override
	public Integer getPerformCnt(String keyWord, String condition) {
		return adminDAO.getPerformCnt(keyWord, condition);
	}

	@Override
	public List<PerformVO> getPerformList(String keyWord, String condition, String orderBy, int startIndexNo,
			int pageSize) {
		return adminDAO.getPerformList(keyWord, condition, orderBy, startIndexNo, pageSize);
	}

	@Override
	public void checkedFalse(int idx) {
		adminDAO.checkedFalse(idx);
	}

	@Override
	public void checkedTrue(int idx) {
		adminDAO.checkedTrue(idx);
	}

	@Override
	public void performDelete(int idx) {
		adminDAO.performDelete(idx);
	}

	@Override
	public List<ThemePerformVO> getThemeList() {
		return adminDAO.getThemeList();
	}

	@Override
	public List<ThemePerformVO> getPerformsInTheme(String theme) {
		return adminDAO.getPerformsInTheme(theme);
	}

	@Override
	public void addThemeName(String theme) {
		adminDAO.addThemeName(theme);
	}

	@Override
	public void addPerformInTheme(ThemePerformVO vo) {
		adminDAO.addPerformInTheme(vo);
	}

	@Override
	public void deletePerformInTheme(ThemePerformVO vo) {
		adminDAO.deletePerformInTheme(vo);
	}

	@Override
	public Integer getShowThemeMaxOrder() {
		return adminDAO.getShowThemeMaxOrder();
	}

	@Override
	public void addShowTheme(String theme, int order) {
		adminDAO.addShowTheme(theme, order);
	}

	@Override
	public void delShowTheme(String theme) {
		//order 번호 가져와 
		int order = adminDAO.getShowThemeOrder(theme)==null?0:adminDAO.getShowThemeOrder(theme);
		System.out.println("order : " + order);
		// 해당 theme  행 지우기
		adminDAO.deleteShowTheme(order);
		// order보다 큰 행의 order 1 빼기
		adminDAO.minusShowThemeOrder(order);
		//adminService.addShowTheme(theme, order);
	}

	@Override
	public void delTheme(String theme) {
		adminDAO.delTheme(theme);
	}

	@Override
	public Integer getTotReviewCnt(String keyWord) {
		return adminDAO.getTotReviewCnt(keyWord);
	}

	@Override
	public List<ReviewVO> getAllReview(String keyWord, String orderBy, int startIndexNo, int pageSize) {
		return adminDAO.getAllReview(keyWord, orderBy, startIndexNo, pageSize);
	}

	@Override
	public Integer getTotReportCnt() {
		return adminDAO.getTotReportCnt();
	}

	@Override
	public List<ReportVO> getAllReport(String orderBy, int startIndexNo, int pageSize) {
		return adminDAO.getAllReport(orderBy, startIndexNo, pageSize);
	}

	@Override
	public ReviewVO getReviewByIdx(int reviewIdx) {
		return adminDAO.getReviewByIdx(reviewIdx);
	}

	@Override
	public void addWarn(String nick) {
		adminDAO.addWarn(nick);
	}

	@Override
	public void hideReviewContent(int idx) {
		adminDAO.hideReviewContent(idx);
	}

	@Override
	public void deleteReport(int idx) {
		adminDAO.deleteReport(idx);
	}

	@Override
	public void registNotice(NoticeVO vo) {
		adminDAO.registNotice(vo);
	}

	@Override
	public void updateNotice(NoticeVO vo) {
		adminDAO.updateNotice(vo);
	}

	@Override
	public void deleteNotice(int idx) {
		adminDAO.deleteNotice(idx);
	}

	@Override
	public void registFAQ(FAQVO vo) {
		adminDAO.registFAQ(vo);
	}

	@Override
	public void updateFAQ(FAQVO vo) {
		adminDAO.updateFAQ(vo);
	}

	@Override
	public void deleteFAQ(int idx) {
		adminDAO.deleteFAQ(idx);
	}

	@Override
	public Integer getSuggestionCnt(int condition) {
		return adminDAO.getSuggestionCnt(condition);
	}

	@Override
	public List<SuggestionVO> getSuggestionList(int condition, int startIndexNo, int pageSize) {
		return adminDAO.getSuggestionList(condition, startIndexNo, pageSize);
	}

	@Override
	public void suggestionChangeCondition(int idx, int condition) {
		adminDAO.suggestionChangeCondition(idx, condition);
	}

	@Override
	public void updateNoticeImportantZero(int idx) {
		adminDAO.updateNoticeImportantZero(idx);
	}

	@Override
	public List<FreeBoardVO> getFreeBoardList(String keyWord, String orderBy, int startIndexNo, int pageSize) {
		return adminDAO.getFreeBoardList(keyWord, orderBy, startIndexNo, pageSize);
	}

	@Override
	public void deleteMember(String nick) {
		adminDAO.deleteMember(nick);
	}

	@Override
	public void changeImportant(int idx, String pm) {
		adminDAO.changeImportant(idx, pm);
	}

	@Override
	public List<OfficialVO> getNewOffialApply(int startIndexNo, int pageSize) {
		return adminDAO.getNewOffialApply(startIndexNo, pageSize);
	}

	@Override
	public Integer getNewOffialApplyCnt() {
		return adminDAO.getNewOffialApplyCnt();
	}

	@Override
	public void deleteOfficialVO(String nick) {
		adminDAO.deleteOfficialVO(nick);
	}

	@Override
	public void officialLevelUp(String nick) {
		adminDAO.officialLevelUp(nick);
	}

	@Override
	public OfficialVO getOfficialVO(String nick) {
		return adminDAO.getOfficialVO(nick);
	}

	@Override
	public Integer getOffialCnt(String keyWord) {
		return adminDAO.getOfficialCnt(keyWord);
	}

	@Override
	public List<OfficialVO> getOffialList(String keyWord, String orderBy, int startIndexNo, int pageSize) {
		return adminDAO.getOffialList(keyWord, orderBy, startIndexNo, pageSize);
	}

	@Override
	public Integer getNoAccessPerformCnt() {
		return adminDAO.getNoAccessPerformCnt();
	}

	@Override
	public void inputAdv(MultipartFile file, AdvertiseVO vo) {
		try {
			String oFileNames = "";     
			String saveFileNames = "";  
			
			String oFileName = file.getOriginalFilename();
			
			// 서버에 저장될 파일명 작업(파일명을 날짜를 사용하여 중복을 방지처리했다)
			String saveFileName = saveFileName(oFileName);
			
			// 실제로 서버 파일시스템에 업로드한 파일을 저장한다.
			writeAdvFile(file, saveFileName);
			
			// DB에는 업로드 파일명과 실제 저장된 파일명을 저장시켜야 하기에, 여러개의 파일을 '/'와 같이 누적처리했다. 
			oFileNames += oFileName + "/";
			saveFileNames += saveFileName + "/";
			
			vo.setOFName(oFileNames);
			vo.setFSName(saveFileNames);
			vo.setSubMent(vo.getSubMent().replace("\n", "<br/>"));
			adminDAO.inputAdv(vo);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private String saveFileName(String oFileName) {
		String fileName = "";
		
		Calendar calendar = Calendar.getInstance();
		fileName += calendar.get(Calendar.YEAR);
		fileName += calendar.get(Calendar.MONTH);
		fileName += calendar.get(Calendar.DATE);
		fileName += calendar.get(Calendar.HOUR);
		fileName += calendar.get(Calendar.MINUTE);
		fileName += calendar.get(Calendar.SECOND);
		fileName += calendar.get(Calendar.MILLISECOND);
		fileName += "_" + oFileName;
		
		return fileName;
	}

	@Override
	public List<AdvertiseVO> getAdvertiseList() {
		return adminDAO.getAdvertiseList();
	}

	@Override
	public void advertiseCheckFalse(int idx) {
		adminDAO.advertiseCheckFalse(idx);
	}

	@Override
	public void advertiseCheckTrue(int idx) {
		adminDAO.advertiseCheckTrue(idx);
	}

	@Override
	public void deleteAdvertise(int idx) {
		adminDAO.deleteAdvertise(idx);
	}

	@Override
	public List<VisitDataVO> getVisitCnt(String range) {
		return adminDAO.getVisitCnt(range);
	}

	@Override
	public List<TicketingVO> getTicketsSalesData() {
		return adminDAO.getTicketsSalesData();
	}

	@Override
	public AdvertiseVO getAdvertise(int idx) {
		return adminDAO.getAdvertise(idx);
	}

	@Override
	public Integer getAdvertiseCnt(String adtype) {
		return adminDAO.getAdvertiseCnt(adtype);
	}

	@Override
	public Integer getPerformsCntInTheme(String theme) {
		return adminDAO.getPerformsCntInTheme(theme);
	}

	@Override
	public List<RegionTicketSalesVO> getRegionTicketSales() {
		return adminDAO.getRegionTicketSales();
	}

	@Override
	public Integer getTheaterCnt(String keyWord) {
		return adminDAO.getTheaterCnt(keyWord);
	}

	@Override
	public void deleteOfficialApply(String nick) {
		adminDAO.deleteOfficialApply(nick);
	}

	@Override
	public Integer getNewBoardCnt() {
		return adminDAO.getNewBoardCnt();
	}

	@Override
	public Integer getNewReplyCnt() {
		return adminDAO.getNewReplyCnt();
	}

	@Override
	public Integer getTotReplyCnt(String keyWord) {
		return adminDAO.getTotReplyCnt(keyWord);
	}

	@Override
	public List<BoardReplyVO> getRepliesList(String keyWord, int startIndexNo, int pageSize) {
		return adminDAO.getRepliesList(keyWord, startIndexNo, pageSize);
	}

	@Override
	public String getEmailByNick(String nick) {
		return adminDAO.getEmailByNick(nick);
	}

	@Override
	public void deleteReply(int idx) {
		adminDAO.deleteReply(idx);
	}
}
