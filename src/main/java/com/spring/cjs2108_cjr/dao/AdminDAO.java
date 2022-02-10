package com.spring.cjs2108_cjr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

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

public interface AdminDAO {

	public void registPerform(@Param("vo") PerformVO vo);

	public TheaterVO getTheater(@Param("name") String name);

	public void registTheater(@Param("vo") TheaterVO theaterVo);

	public List<TheaterVO> getTheaterList(@Param("keyWord") String keyWord, @Param("orderBy") String orderBy, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void updatePerformExceptPoster(@Param("vo") PerformVO vo);

	public void updatePerformAll(@Param("vo") PerformVO vo);

	public List<TicketingVO> getTicketsList(@Param("orderBy") String orderBy, @Param("keyWord") String keyWord, 
			@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("date") String date);

	public void deleteTheater(@Param("idx") int idx);

	public void updateTheaterAddress(@Param("idx") int idx, @Param("address2") String address2);

	public List<MemberVO> getMemberList(@Param("orderBy") String orderBy);

	public void changeMemberLevel(@Param("nick") String nick, @Param("level") int level);

	public List<MemberVO> getMemberSearch(@Param("orderBy") String orderBy, @Param("keyWord") String keyWord, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public Integer getMemberCnt(@Param("keyWord") String keyWord);

	public Integer getTicketListCnt(@Param("keyWord") String keyWord, @Param("date") String date);

	public Integer getAllQnaCnt(@Param("keyWord") String keyWord, @Param("condition") String condition);

	public List<QnaVO> getQnaList(@Param("keyWord") String keyWord, @Param("condition") String condition, 
			@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void registAnswer(@Param("answer") String answer, @Param("idx") int idx);

	public QnaVO getQnaVo(@Param("idx") int idx);

	public int getTodayVisit();

	public int getTotalVisit();

	public Integer getPerformCnt(@Param("keyWord") String keyWord, @Param("condition") String condition);

	public List<PerformVO> getPerformList(@Param("keyWord") String keyWord, @Param("condition") String condition, 
			@Param("orderBy") String orderBy, @Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

	public void checkedFalse(@Param("idx") int idx);

	public void checkedTrue(@Param("idx") int idx);

	public void performDelete(@Param("idx") int idx);

	public List<ThemePerformVO> getThemeList();

	public List<ThemePerformVO> getPerformsInTheme(@Param("theme") String theme);

	public void addThemeName(@Param("theme") String theme);

	public void addPerformInTheme(@Param("vo") ThemePerformVO vo);

	public void deletePerformInTheme(@Param("vo") ThemePerformVO vo);

	public Integer getShowThemeMaxOrder();

	public void addShowTheme(@Param("theme") String theme, @Param("order") int order);

	public Integer getShowThemeOrder(@Param("theme") String theme);

	public void deleteShowTheme(@Param("order") int order);

	public void minusShowThemeOrder(@Param("order") int order);

	public void delTheme(@Param("theme") String theme);

	public Integer getTotReviewCnt(@Param("keyWord") String keyWord);

	public List<ReviewVO> getAllReview(@Param("keyWord") String keyWord, @Param("orderBy") String orderBy,
			@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

	public Integer getTotReportCnt();

	public List<ReportVO> getAllReport(@Param("orderBy") String orderBy, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public ReviewVO getReviewByIdx(@Param("reviewIdx") int reviewIdx);

	public void addWarn(@Param("nick") String nick);

	public void hideReviewContent(@Param("idx") int idx);

	public void deleteReport(@Param("idx") int idx);

	public void registNotice(@Param("vo") NoticeVO vo);

	public void updateNotice(@Param("vo") NoticeVO vo);

	public void deleteNotice(@Param("idx") int idx);

	public void registFAQ(@Param("vo") FAQVO vo);

	public void updateFAQ(@Param("vo") FAQVO vo);

	public void deleteFAQ(@Param("idx") int idx);

	public Integer getSuggestionCnt(@Param("condition") int condition);

	public List<SuggestionVO> getSuggestionList(@Param("condition") int condition, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void suggestionChangeCondition(@Param("idx") int idx, @Param("condition") int condition);

	public void updateNoticeImportantZero(@Param("idx") int idx);

	public List<FreeBoardVO> getFreeBoardList(@Param("keyWord") String keyWord, @Param("orderBy") String orderBy, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void deleteMember(@Param("nick") String nick);

	public void changeImportant(@Param("idx") int idx, @Param("pm") String pm);

	public List<OfficialVO> getNewOffialApply(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public Integer getNewOffialApplyCnt();

	public void deleteOfficialVO(@Param("nick") String nick);

	public void officialLevelUp(@Param("nick") String nick);

	public OfficialVO getOfficialVO(@Param("nick") String nick);

	public Integer getOfficialCnt(@Param("keyWord") String keyWord);

	public List<OfficialVO> getOffialList(@Param("keyWord") String keyWord, @Param("orderBy") String orderBy, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public Integer getNoAccessPerformCnt();

	public void inputAdv(@Param("vo") AdvertiseVO vo);

	public List<AdvertiseVO> getAdvertiseList();

	public void advertiseCheckFalse(@Param("idx") int idx);
	
	public void advertiseCheckTrue(@Param("idx") int idx);

	public void deleteAdvertise(@Param("idx") int idx);

	public List<VisitDataVO> getVisitCnt(@Param("range") String range);

	public List<TicketingVO> getTicketsSalesData();

	public AdvertiseVO getAdvertise(@Param("idx") int idx);

	public Integer getAdvertiseCnt(@Param("adtype") String adtype);

	public Integer getPerformsCntInTheme(@Param("theme") String theme);

	public List<RegionTicketSalesVO> getRegionTicketSales();

	public Integer getTheaterCnt(@Param("keyWord") String keyWord);

	public void deleteOfficialApply(@Param("nick") String nick);

	public Integer getNewBoardCnt();

	public Integer getNewReplyCnt();

	public Integer getTotReplyCnt(@Param("keyWord") String keyWord);

	public List<BoardReplyVO> getRepliesList(@Param("keyWord") String keyWord, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public String getEmailByNick(@Param("nick") String nick);

	public void deleteReply(@Param("idx") int idx);
	
}
