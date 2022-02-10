package com.spring.cjs2108_cjr.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.cjs2108_cjr.vo.AdvertiseVO;
import com.spring.cjs2108_cjr.vo.PerformInfoViewsVO;
import com.spring.cjs2108_cjr.vo.PerformScheduleVO;
import com.spring.cjs2108_cjr.vo.PerformVO;
import com.spring.cjs2108_cjr.vo.ReportVO;
import com.spring.cjs2108_cjr.vo.ReviewVO;
import com.spring.cjs2108_cjr.vo.TheaterVO;
import com.spring.cjs2108_cjr.vo.TicketingVO;

public interface PerformService {

	public List<PerformVO> getPerformList(String keyWord, String condition, String orderBy, int startIndexNo, int pageSize);

	public List<PerformVO> getPerformListAll(String orderBy);

	public PerformVO getPerformInfo(int idx);

	public List<PerformScheduleVO> getPerformScheduleList(int idx);

	public void registPerformSchedule(PerformScheduleVO vo);

	public PerformScheduleVO getPerformSchedule(String schedule, int performIdx);

	public void deletePerformSchedule(int idx);

	public List<PerformScheduleVO> getPerformTime(String schedule, int performIdx);

	public PerformScheduleVO getPerformScheduleByIdx(int idx);

	public void increaseTicketSales(int idx);

	public void addReview(ReviewVO vo);

	public Integer getTotalReviewCnt(int idx);

	public List<ReviewVO> getReviewList(int idx, int startIndexNo, int pageSize);

	public void deleteReview(int idx);

	public Integer getReviewIdx(ReviewVO vo);

	public void updateReview(ReviewVO vo);

	public Double getReviewAvg(int idx);

	public void addReport(ReportVO vo);

	public TheaterVO getTheaterVO(String theater);

	public void addViews(PerformInfoViewsVO pivVo);

	public int getPerformCnt(String keyWord, String condition);

	public List<String> getSelectedTheme();

	public List<String> getShowThemes();

	public List<Integer> getPerformsInTheme(String theme);

	public List<PerformVO> getPerformListByTheater(String theater);

	public TicketingVO getWatchCert(String nick, int idx);

	public List<PerformVO> getMyPerform(String email, int startIndexNo, int pageSize);

	public Integer getMyPerformCnt(String email);

	public Integer getPerformInfoViews(int idx);

	public String posterUpload(MultipartFile fName);

	public void uploadFileManage(String content);

	public void registPerform(PerformVO vo);

	public Object getTheater(String theater);

	public void registTheater(TheaterVO theaterVo);

	public PerformVO getAllPerformInfo(int idx);

	public void imgCopyTempFolder(String content);

	void imgDelete(String content);

	public List<TheaterVO> getTheaterList();

	public void updatePerformExceptPoster(PerformVO vo);

	public void deletePoster(String oriPosterFSN);

	public void updatePerformAll(PerformVO vo);

	public void getSchedule(int idx);

	public AdvertiseVO getMainAdvertise();

	public List<AdvertiseVO> getBannerAdvList();

	public AdvertiseVO getSlimAdv();

	public AdvertiseVO getCardAdv();

	public void deletePerformScheduleInDate(int performIdx, String date);

}
