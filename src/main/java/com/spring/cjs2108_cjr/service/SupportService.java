package com.spring.cjs2108_cjr.service;

import java.util.List;

import com.spring.cjs2108_cjr.vo.FAQVO;
import com.spring.cjs2108_cjr.vo.NoticeVO;
import com.spring.cjs2108_cjr.vo.OfficialVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.SuggestionVO;

public interface SupportService {

	public void addQna(QnaVO vo);

	public List<NoticeVO> getNoticeList(String orderBy, String keyWord, int startIndexNo, int pageSize);

	public Integer getNoticeCnt(String keyWord);

	public NoticeVO getNoticeVO(int idx);

	public void addNoticeView(int idx);

	public NoticeVO getPrevNoticeVO(int idx);

	public NoticeVO getNextNoticeVO(int idx);

	public Integer getFAQCnt(String keyWord);

	public List<FAQVO> getFAQList(String orderBy, String keyWord, int startIndexNo, int pageSize);

	public void addFAQView(int idx);

	public FAQVO getFAQVO(int idx);

	public FAQVO getPrevFAQVO(int idx);

	public FAQVO getNextFAQVO(int idx);

	public void addSuggestion(SuggestionVO vo);

	public void submitOfficialLevelUp(OfficialVO vo);

	public OfficialVO getOfficialVO(String nick);

	public void updateOfficialInfo(OfficialVO vo);

}
