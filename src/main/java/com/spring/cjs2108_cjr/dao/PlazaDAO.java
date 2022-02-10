package com.spring.cjs2108_cjr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.cjs2108_cjr.vo.BoardReplyVO;
import com.spring.cjs2108_cjr.vo.FreeBoardVO;
import com.spring.cjs2108_cjr.vo.RecommendVO;

public interface PlazaDAO {

	public void registFreeBoard(@Param("vo") FreeBoardVO vo);

	public Integer getFreeBoardCnt(@Param("keyWord") String keyWord);

	public List<FreeBoardVO> getFreeBoardList(@Param("keyWord") String keyWord, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public FreeBoardVO getFreeBoardVO(@Param("idx") int idx);

	public FreeBoardVO getPrevFreeBoardVO(@Param("idx") int idx);

	public FreeBoardVO getNextFreeBoardVO(@Param("idx") int idx);

	public void addFreeBoardViews(@Param("idx") int idx);

	public void addReply(@Param("vo") BoardReplyVO vo);

	public List<BoardReplyVO> getReplyList(@Param("idx") int idx);

	public Integer getrereplyCnt(@Param("idx") int idx);

	public List<BoardReplyVO> getReReply(@Param("idx") int idx);

	public void deleteReReply(@Param("idx") int idx);

	public void resetReply(@Param("idx") int idx);

	public void updateReply(@Param("idx") int idx, @Param("content") String content);

	public Integer getreplyCnt(@Param("idx") int idx);

	public void deleteBoard(@Param("idx") int idx);

	public void updateFreeBoard(@Param("vo") FreeBoardVO vo);

	public void addRecommend(@Param("vo") RecommendVO vo);

	public RecommendVO getRecommendVo(@Param("idx") int idx, @Param("nick") String nick);

	public void cancleRecommend(@Param("vo") RecommendVO vo);

	public Integer getBoardRecommendCnt(@Param("idx") int idx);

	public Integer getRecentReplyCnt(@Param("idx") int idx);

}
