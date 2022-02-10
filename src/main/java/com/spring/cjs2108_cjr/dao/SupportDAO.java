package com.spring.cjs2108_cjr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_cjr.vo.FAQVO;
import com.spring.cjs2108_cjr.vo.NoticeVO;
import com.spring.cjs2108_cjr.vo.OfficialVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.SuggestionVO;

public interface SupportDAO {

	public void addQna(@Param("vo") QnaVO vo);

	public List<QnaVO> getQnaList(@Param("nick") String nick, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public Integer getQnaListCnt(@Param("nick") String nick);

	public List<NoticeVO> getNoticeList(@Param("orderBy") String orderBy, @Param("keyWord") String keyWord, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public Integer getNoticeCnt(@Param("keyWord") String keyWord);

	public NoticeVO getNoticeVO(@Param("idx") int idx);

	public void addNoticeView(@Param("idx") int idx);

	public NoticeVO getPrevNoticeVO(@Param("idx") int idx);

	public NoticeVO getNextNoticeVO(@Param("idx") int idx);

	public Integer getFAQCnt(@Param("keyWord") String keyWord);

	public List<FAQVO> getFAQList(@Param("orderBy") String orderBy, @Param("keyWord") String keyWord, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void addFAQView(@Param("idx") int idx);

	public FAQVO getFAQVO(@Param("idx") int idx);

	public FAQVO getPrevFAQVO(@Param("idx") int idx);

	public FAQVO getNextFAQVO(@Param("idx") int idx);

	public void addSuggestion(@Param("vo") SuggestionVO vo);

	public void submitOfficialLevelUp(@Param("vo") OfficialVO vo);

	public OfficialVO getOfficialVO(@Param("nick") String nick);

	public void updateOfficialInfo(@Param("vo") OfficialVO vo);

}

