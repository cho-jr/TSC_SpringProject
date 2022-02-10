package com.spring.cjs2108_cjr.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

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

public interface AdminService {

	public String posterUpload(MultipartFile fName);

	public void uploadFileManage(String content, String place);

	public void registPerform(PerformVO vo);

	public TheaterVO getTheater(String name);

	public void registTheater(TheaterVO theaterVo);

	public List<TheaterVO> getTheaterList(String keyWord, String orderBy, int startIndexNo, int pageSize);

	public void imgCopyTempFolder(String content, String place);

	public void imgDelete(String content, String place);

	public void updatePerformExceptPoster(PerformVO vo);

	public void deletePoster(String oriPosterFSN);

	public void updatePerformAll(PerformVO vo);

	public List<TicketingVO> getTicketsList(String orderBy, String keyWord, int startIndexNo, int pageSize, String date);

	public void deleteTheater(int idx);

	public void updateTheaterAddress(int idx, String address2);

	public List<MemberVO> getMemberList(String orderBy);

	public void changeMemberLevel(String nick, int level);

	public List<MemberVO> getMemberSearch(String orderBy, String keyWord, int startIndexNo, int pageSize);

	public Integer getMemberCnt(String keyWord);

	public Integer getTicketsListCnt(String keyWord, String date);

	public Integer getAllQnaCnt(String keyWord, String condition);

	public List<QnaVO> getQnaList(String keyWord, String condition, int startIndexNo, int pageSize);

	public void registAnswer(String answer, int idx);

	public QnaVO getQnaVo(int idx);

	public int getTodayVisit();

	public int getTotalVisit();

	public Integer getPerformCnt(String keyWord, String condition);

	public List<PerformVO> getPerformList(String keyWord, String condition, String orderBy, int startIndexNo,
			int pageSize);

	public void checkedFalse(int idx);

	public void checkedTrue(int idx);

	public void performDelete(int idx);

	public List<ThemePerformVO> getThemeList();

	public List<ThemePerformVO> getPerformsInTheme(String theme);

	public void addThemeName(String theme);

	public void addPerformInTheme(ThemePerformVO vo);

	public void deletePerformInTheme(ThemePerformVO vo);

	public Integer getShowThemeMaxOrder();

	public void addShowTheme(String theme, int order);

	public void delShowTheme(String theme);

	public void delTheme(String theme);

	public Integer getTotReviewCnt(String keyWord);

	public List<ReviewVO> getAllReview(String keyWord, String orderBy, int startIndexNo, int pageSize);

	public Integer getTotReportCnt();

	public List<ReportVO> getAllReport(String orderBy, int startIndexNo, int pageSize);

	public ReviewVO getReviewByIdx(int reviewIdx);

	public void addWarn(String nick);

	public void hideReviewContent(int idx);

	public void deleteReport(int idx);

	public void registNotice(NoticeVO vo);

	public void updateNotice(NoticeVO vo);

	public void deleteNotice(int idx);

	public void registFAQ(FAQVO vo);

	public void updateFAQ(FAQVO vo);

	public void deleteFAQ(int idx);

	public Integer getSuggestionCnt(int condition);

	public List<SuggestionVO> getSuggestionList(int condition, int startIndexNo, int pageSize);

	public void suggestionChangeCondition(int idx, int condition);

	public void updateNoticeImportantZero(int idx);

	public List<FreeBoardVO> getFreeBoardList(String keyWord, String orderBy, int startIndexNo, int pageSize);

	public void deleteMember(String nick);

	public void changeImportant(int idx, String pm);

	public List<OfficialVO> getNewOffialApply(int startIndexNo, int pageSize);

	public Integer getNewOffialApplyCnt();

	public void deleteOfficialVO(String nick);

	public void officialLevelUp(String nick);

	public OfficialVO getOfficialVO(String nick);

	public Integer getOffialCnt(String keyWord);

	public List<OfficialVO> getOffialList(String keyWord, String orderBy, int startIndexNo, int pageSize);

	public Integer getNoAccessPerformCnt();

	public void inputAdv(MultipartFile file, AdvertiseVO vo);

	public List<AdvertiseVO> getAdvertiseList();

	public void advertiseCheckFalse(int idx);
	
	public void advertiseCheckTrue(int idx);

	public void deleteAdvertise(int idx);

	public List<VisitDataVO> getVisitCnt(String range);

	public List<TicketingVO> getTicketsSalesData();

	public AdvertiseVO getAdvertise(int idx);

	public Integer getAdvertiseCnt(String adtype);

	public Integer getPerformsCntInTheme(String theme);

	public List<RegionTicketSalesVO> getRegionTicketSales();

	public Integer getTheaterCnt(String keyWord);

	public void deleteOfficialApply(String nick);

	public Integer getNewBoardCnt();

	public Integer getNewReplyCnt();

	public Integer getTotReplyCnt(String keyWord);

	public List<BoardReplyVO> getRepliesList(String keyWord, int startIndexNo, int pageSize);

	public String getEmailByNick(String nick);

	public void deleteReply(int idx);
	
}
