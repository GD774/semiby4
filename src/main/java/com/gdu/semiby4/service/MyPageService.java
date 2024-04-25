package com.gdu.semiby4.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.dto.UserDto;

public interface MyPageService {
	public List<BoardDto> myBoardList(HttpServletRequest request);
	public UserDto userInfo(HttpServletRequest request);
	// public List<BoardDto> mybookmarks(HttpServletRequest request);
	public void edit(HttpServletRequest request, HttpServletResponse response);
}
