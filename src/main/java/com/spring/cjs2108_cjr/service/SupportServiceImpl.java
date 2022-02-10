package com.spring.cjs2108_cjr.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.cjs2108_cjr.dao.SupportDAO;
import com.spring.cjs2108_cjr.vo.FAQVO;
import com.spring.cjs2108_cjr.vo.NoticeVO;
import com.spring.cjs2108_cjr.vo.OfficialVO;
import com.spring.cjs2108_cjr.vo.QnaVO;
import com.spring.cjs2108_cjr.vo.SuggestionVO;

@Service
public class SupportServiceImpl implements SupportService {
	@Autowired
	SupportDAO supportDAO;

	@Override
	public void addQna(QnaVO vo) {
		supportDAO.addQna(vo);
	}

	@Override
	public List<NoticeVO> getNoticeList(String orderBy, String keyWord, int startIndexNo, int pageSize) {
		return supportDAO.getNoticeList(orderBy, keyWord, startIndexNo, pageSize);
	}

	@Override
	public Integer getNoticeCnt(String keyWord) {
		return supportDAO.getNoticeCnt(keyWord);
	}

	@Override
	public NoticeVO getNoticeVO(int idx) {
		return supportDAO.getNoticeVO(idx);
	}

	@Override
	public void addNoticeView(int idx) {
		supportDAO.addNoticeView(idx);
	}

	@Override
	public NoticeVO getPrevNoticeVO(int idx) {
		return supportDAO.getPrevNoticeVO(idx);
	}

	@Override
	public NoticeVO getNextNoticeVO(int idx) {
		return supportDAO.getNextNoticeVO(idx);
	}

	@Override
	public Integer getFAQCnt(String keyWord) {
		return supportDAO.getFAQCnt(keyWord);
	}

	@Override
	public List<FAQVO> getFAQList(String orderBy, String keyWord, int startIndexNo, int pageSize) {
		return supportDAO.getFAQList(orderBy, keyWord, startIndexNo, pageSize);
	}

	@Override
	public void addFAQView(int idx) {
		supportDAO.addFAQView(idx);
	}

	@Override
	public FAQVO getFAQVO(int idx) {
		return supportDAO.getFAQVO(idx);
	}

	@Override
	public FAQVO getPrevFAQVO(int idx) {
		return supportDAO.getPrevFAQVO(idx);
	}

	@Override
	public FAQVO getNextFAQVO(int idx) {
		return supportDAO.getNextFAQVO(idx);
	}

	@Override
	public void addSuggestion(SuggestionVO vo) {
		supportDAO.addSuggestion(vo);
	}

	@Override
	public void submitOfficialLevelUp(OfficialVO vo) {
		supportDAO.submitOfficialLevelUp(vo);
	}

	@Override
	public OfficialVO getOfficialVO(String nick) {
		return supportDAO.getOfficialVO(nick);
	}

	@Override
	public void updateOfficialInfo(OfficialVO vo) {
		supportDAO.updateOfficialInfo(vo);
	}
}
