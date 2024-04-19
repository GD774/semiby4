package com.gdu.semiby4.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.semiby4.dto.BoardDto;

public interface BoardService {

  void boardList(Model model);
  void boardListByNo(int boardNo, Model model);
  Map<String, Object> getAttachList(int boardNo);
	void loadboardSearchList(HttpServletRequest request, Model model);
	public boolean registerUpload(MultipartHttpServletRequest multipartRequest);
  BoardDto getBoardByNo(int boardNo);
  int registerComment(HttpServletRequest request);
  Map<String, Object> getCommentList(HttpServletRequest request);
  int updateHit(int boardNo);

}
