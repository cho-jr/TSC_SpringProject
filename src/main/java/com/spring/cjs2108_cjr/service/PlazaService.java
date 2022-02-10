package com.spring.cjs2108_cjr.service;

import java.util.List;

import com.spring.cjs2108_cjr.vo.BoardReplyVO;
import com.spring.cjs2108_cjr.vo.FreeBoardVO;
import com.spring.cjs2108_cjr.vo.RecommendVO;

public interface PlazaService {

	public void registFreeBoard(FreeBoardVO vo);

	public Integer getFreeBoardCnt(String keyWord);

	public List<FreeBoardVO> getFreeBoardList(String keyWord, int startIndexNo, int pageSize);

	public FreeBoardVO getFreeBoardVO(int idx);

	public FreeBoardVO getPrevFreeBoardVO(int idx);

	public FreeBoardVO getNextFreeBoardVO(int idx);

	public void addFreeBoardViews(int idx);

	public void addReply(BoardReplyVO vo);

	public List<BoardReplyVO> getReplyList(int idx);

	public Integer getrereplyCnt(int idx);

	public List<BoardReplyVO> getReReply(int idx);

	public void deleteReReply(int idx);

	public void resetReReply(int idx);

	public void updateReply(int idx, String content);

	public Integer getreplyCnt(int idx);

	public void deleteBoard(int idx);

	public void uploadFileManage(String content);

	public void imgCopyTempFolder(String content);

	public void imgDelete(String content);

	public void updateFreeBoard(FreeBoardVO vo);

	public void addRecommend(RecommendVO vo);

	public RecommendVO getRecommendVo(int idx, String nick);

	public void cancleRecommend(RecommendVO vo);

	public Integer getBoardRecommendCnt(int idx);

	public Integer getRecentReplyCnt(int idx);

}
