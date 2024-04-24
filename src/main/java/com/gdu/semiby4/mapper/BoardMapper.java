package com.gdu.semiby4.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semiby4.dto.AttachDto;
import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.dto.CommentDto;

@Mapper
public interface BoardMapper {
  
  int getBoardCount();
  List<BoardDto> getBoardList(Map<String, Object> map);
  BoardDto getBoardByNo(int boardNo);
	int insertBoard(BoardDto board);
  int insertAttach(AttachDto attach);
	int insertComment(CommentDto comment);
  int getCommentCount(int boardNo);
  List<CommentDto> getCommentList(Map<String, Object> map);
	int getSearchCount(Map<String, Object> map);
  List<BoardDto> getSearchList(Map<String, Object> map);
  int updateHit(int boardNo);
  int updateBoard(BoardDto board);  // 게시글 수정 (지희)
  List<AttachDto> getAttachList(int boardNo);
  AttachDto getAttachByNo(int attachNo);  // 지희 추가
  int deleteAttach(int attachNo);  // 지희 추가
  
}
