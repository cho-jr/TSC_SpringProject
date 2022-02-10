package com.spring.cjs2108_cjr.pagination;

import lombok.Data;

@Data
public class PagingVO {
	private int pag;
	private int pageSize;
	private int totRecCnt;		// 전체자료 갯수 검색
	
	private int totPage;
	private int startIndexNo;
	private int curScrStartNo;
	private int blockSize;
	private int curBlock;
	private int lastBlock;
	
	public PagingVO(int pag, int pageSize, int totRecCnt) {
		this.pag = pag;
		this.pageSize = pageSize;
		this.totRecCnt = totRecCnt;
		
		this.totPage = (totRecCnt % pageSize)==0 ? totRecCnt/pageSize : (totRecCnt/pageSize) + 1;
		this.startIndexNo = (pag - 1) * pageSize;
		this.curScrStartNo = totRecCnt - startIndexNo;
		this.blockSize = 3;		// 한블록의 크기를 3개의 Page로 본다.(사용자가 지정한다.)
		this.curBlock = (pag - 1) / blockSize;		// 현재페이지의 블록위치
		this.lastBlock = (totPage % blockSize)==0 ? ((totPage / blockSize) - 1) : (totPage / blockSize);
	}

	public int getPag() {
		return pag;
	}

	public void setPag(int pag) {
		this.pag = pag;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotRecCnt() {
		return totRecCnt;
	}

	public void setTotRecCnt(int totRecCnt) {
		this.totRecCnt = totRecCnt;
	}

	public int getTotPage() {
		return totPage;
	}

	public void setTotPage(int totPage) {
		this.totPage = totPage;
	}

	public int getStartIndexNo() {
		return startIndexNo;
	}

	public void setStartIndexNo(int startIndexNo) {
		this.startIndexNo = startIndexNo;
	}

	public int getCurScrStartNo() {
		return curScrStartNo;
	}

	public void setCurScrStartNo(int curScrStartNo) {
		this.curScrStartNo = curScrStartNo;
	}

	public int getBlockSize() {
		return blockSize;
	}

	public void setBlockSize(int blockSize) {
		this.blockSize = blockSize;
	}

	public int getCurBlock() {
		return curBlock;
	}

	public void setCurBlock(int curBlock) {
		this.curBlock = curBlock;
	}

	public int getLastBlock() {
		return lastBlock;
	}

	public void setLastBlock(int lastBlock) {
		this.lastBlock = lastBlock;
	}

	@Override
	public String toString() {
		return "PagingVO [pag=" + pag + ", pageSize=" + pageSize + ", totRecCnt=" + totRecCnt + ", totPage=" + totPage
				+ ", startIndexNo=" + startIndexNo + ", curScrStartNo=" + curScrStartNo + ", blockSize=" + blockSize
				+ ", curBlock=" + curBlock + ", lastBlock=" + lastBlock + "]";
	}
	
	
}
