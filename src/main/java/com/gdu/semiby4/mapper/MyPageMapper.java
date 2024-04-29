package com.gdu.semiby4.mapper;

import java.util.List;

import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.dto.UserDto;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MyPageMapper {
	public List<BoardDto> myBoardList(int userNo);
	public UserDto userInfo(int userNo);
	// public List<BoardDto> mybookmarks(int userNo);
	public int editUser(UserDto user);
}
