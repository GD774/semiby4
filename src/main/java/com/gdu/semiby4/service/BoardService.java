package com.gdu.semiby4.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.semiby4.dto.AttachDto;
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
  
  // 다운로드를 위해 추가
  ResponseEntity<Resource> download(HttpServletRequest request);
  ResponseEntity<Resource> downloadAll(HttpServletRequest request);
  List<AttachDto> getAttachByBoard(int boardNo); // List를 반환하는 getAttach가 필요해서 만듦

  // 멀티리스트를 위해 추가
  void boardMultiList(Model model);
  void boardDetailList(Model model);
  
  // 삭제를 위해 추가
  int removeBoard(int boardNo);

  int updateHit(int boardNo);
  int modifyBoard(BoardDto board);  // 게시글 수정 (지희)
  ResponseEntity<Map<String, Object>> removeAttach(int attachNo);

}
