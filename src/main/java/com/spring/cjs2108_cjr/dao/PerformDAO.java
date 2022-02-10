package com.spring.cjs2108_cjr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.PerformInfoViewsVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.ReportVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;
import com.spring.cjs2108_cjr.vo.TheaterVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

public interface PerformDAO {

	public List<PerformVO> getPerformList(
			@Param("keyWord") String keyWord, @Param("condition") String condition, @Param("orderBy") String orderBy, 
			@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);
	
	public List<PerformVO> getPerformListAll(@Param("orderBy") String orderBy);

	public PerformVO getPerformInfo(@Param("idx") int idx);

	public List<PerformScheduleVO> getPerformScheduleList(@Param("idx") int idx);

	public void registPerformSchedule(@Param("vo") PerformScheduleVO vo);

	public PerformScheduleVO getPerformSchedule(@Param("schedule") String schedule, @Param("performIdx") int performIdx);

	public void deletePerformSchedule(@Param("idx") int idx);

	public List<PerformScheduleVO> getPerformTime(@Param("schedule") String schedule, @Param("performIdx") int performIdx);

	public PerformScheduleVO getPerformScheduleByIdx(@Param("idx") int idx);

	public void decreaseSeat(@Param("idx") int performScheduleIdx, @Param("remainSeatNum") String remainSeatNum);

	public void increaseTicketSales(@Param("idx") int idx);

	public void addReview(@Param("vo") ReviewVO vo);

	public Integer getTotalReviewCnt(@Param("idx") int idx);

	public List<ReviewVO> getReviewList(@Param("idx") int idx, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void deleteReview(@Param("idx") int idx);

	public Integer getReviewIdx(@Param("vo") ReviewVO vo);

	public void updateReview(@Param("vo") ReviewVO vo);

	public Double getReviewAvg(@Param("idx") int idx);

	public void addReport(@Param("vo") ReportVO vo);

	public TheaterVO getTheaterVO(@Param("theater") String theater);

	public void addViews(@Param("vo") PerformInfoViewsVO pivVo);

	public int getPerformCnt(@Param("keyWord") String keyWord, @Param("condition") String condition);

	public List<String> getSelectedTheme();

	public List<String> getShowThemes();

	public List<Integer> getPerformsInTheme(@Param("theme") String theme);

	public List<PerformVO> getPerformListByTheater(@Param("theater") String theater);

	public TicketingVO getWatchCert(@Param("nick") String nick, @Param("idx") int idx);

	public List<PerformVO> getMyPerform(@Param("email") String email, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public Integer getMyPerformCnt(@Param("email") String email);

	public Integer getPerformInfoViews(@Param("idx") int idx);

	public void registPerform(@Param("vo") PerformVO vo);

	public Object getTheater(@Param("name") String theater);

	public void registTheater(@Param("vo") TheaterVO theaterVo);

	public PerformVO getAllPerformInfo(@Param("idx") int idx);

	public List<TheaterVO> getTheaterList();

	public void updatePerformExceptPoster(@Param("vo") PerformVO vo);

	public void updatePerformAll(@Param("vo") PerformVO vo);

	public List<PerformScheduleVO> getPerformScheduleListInThisMonth(@Param("idx") int idx, @Param("ym") String ym);

	public List<Integer> getAdvertiseIdxList(@Param("adtype") String adtype);

	public AdvertiseVO getOneAdvertise(@Param("idx") Integer idx);

	public List<AdvertiseVO> getBannerAdvList();

	public void deletePerformScheduleInDate(@Param("performIdx") int performIdx, @Param("date") String date);


}
