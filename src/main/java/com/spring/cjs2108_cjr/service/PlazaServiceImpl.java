package com.spring.cjs2108_cjr.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.spring.cjs2108_cjr.dao.PlazaDAO;
import com.spring.cjs2108_cjr.vo.BoardReplyVO;
import com.spring.cjs2108_cjr.vo.FreeBoardVO;
import com.spring.cjs2108_cjr.vo.RecommendVO;

@Service
public class PlazaServiceImpl implements PlazaService {
	
	@Autowired
	PlazaDAO plazaDAO;

	@Override
	public void registFreeBoard(FreeBoardVO vo) {
		plazaDAO.registFreeBoard(vo);
		
	}

	@Override
	public Integer getFreeBoardCnt(String keyWord) {
		return plazaDAO.getFreeBoardCnt(keyWord);
	}

	@Override
	public List<FreeBoardVO> getFreeBoardList(String keyWord, int startIndexNo, int pageSize) {
		return plazaDAO.getFreeBoardList(keyWord, startIndexNo, pageSize);
	}

	@Override
	public FreeBoardVO getFreeBoardVO(int idx) {
		return plazaDAO.getFreeBoardVO(idx);
	}

	@Override
	public FreeBoardVO getPrevFreeBoardVO(int idx) {
		return plazaDAO.getPrevFreeBoardVO(idx);
	}

	@Override
	public FreeBoardVO getNextFreeBoardVO(int idx) {
		return plazaDAO.getNextFreeBoardVO(idx);
	}

	@Override
	public void addFreeBoardViews(int idx) {
		plazaDAO.addFreeBoardViews(idx);
	}

	@Override
	public void addReply(BoardReplyVO vo) {
		plazaDAO.addReply(vo);
	}

	@Override
	public List<BoardReplyVO> getReplyList(int idx) {
		return plazaDAO.getReplyList(idx);
	}

	@Override
	public Integer getrereplyCnt(int idx) {
		return plazaDAO.getrereplyCnt(idx);
	}

	@Override
	public List<BoardReplyVO> getReReply(int idx) {
		return plazaDAO.getReReply(idx);
	}

	@Override
	public void deleteReReply(int idx) {
		plazaDAO.deleteReReply(idx);
	}

	@Override
	public void resetReReply(int idx) {
		plazaDAO.resetReply(idx);
	}

	@Override
	public void updateReply(int idx, String content) {
		plazaDAO.updateReply(idx, content);
	}

	@Override
	public Integer getreplyCnt(int idx) {
		return plazaDAO.getreplyCnt(idx);
	}

	@Override
	public void deleteBoard(int idx) {
		plazaDAO.deleteBoard(idx);
	}
	
	@Override
	public void uploadFileManage(String content) {
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
			copyFilePath = request.getSession().getServletContext().getRealPath("/resources/images/plaza/") + imgFile;
			
			fileCopyCheck(oriFilePath, copyFilePath);	
			
			if(nextImg.indexOf("src=\"/") == -1) {sw = false;}
			else {nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);}
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
			fos.flush();fos.close();fis.close();
		} catch (IOException e ) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void imgCopyTempFolder(String content) {
		if(content.indexOf("src=\"/") == -1) return;
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String originPath = "";
		int position = 31;																	
		originPath = request.getSession().getServletContext().getRealPath("/resources/images/plaza/");
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
	public void imgDelete(String content) {
		if(content.indexOf("src=\"/") == -1) return;
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String originPath = "";
		int position = 31;
		originPath = request.getSession().getServletContext().getRealPath("/resources/images/plaza/");
		
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		while(sw) {
			String imgFile = nextImg.substring(0,nextImg.indexOf("\""));
			String oriFilePath = originPath + imgFile;	
			
			fileDelete(oriFilePath);	
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}
	
	private void fileDelete(String oriFilePath) {
		File delFile = new File(oriFilePath);
		if(delFile.exists()) delFile.delete();
	}

	@Override
	public void updateFreeBoard(FreeBoardVO vo) {
		plazaDAO.updateFreeBoard(vo);
	}

	@Override
	public void addRecommend(RecommendVO vo) {
		plazaDAO.addRecommend(vo);
	}

	@Override
	public RecommendVO getRecommendVo(int idx, String nick) {
		return plazaDAO.getRecommendVo(idx, nick);
	}

	@Override
	public void cancleRecommend(RecommendVO vo) {
		plazaDAO.cancleRecommend(vo);
	}

	@Override
	public Integer getBoardRecommendCnt(int idx) {
		return plazaDAO.getBoardRecommendCnt(idx);
	}

	@Override
	public Integer getRecentReplyCnt(int idx) {
		return plazaDAO.getRecentReplyCnt(idx);
	}
}
