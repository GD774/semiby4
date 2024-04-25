package com.gdu.semiby4.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.service.MyPageService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RequestMapping("/mypage")
@Controller
public class MyPageController {
	private final MyPageService myPageService;

	@GetMapping("")
	public String mypage() {
		return "mypage/mypage";
	}

	@GetMapping("/edit")
	public void edit() {}

	@PostMapping("/edit.do")
  public void signup(HttpServletRequest request, HttpServletResponse response) {
    myPageService.edit(request, response);
  }

	@GetMapping("/myinfo.do")
	@ResponseBody
	public UserDto myinfo(HttpServletRequest request) {
		return myPageService.userInfo(request);
	}

	@GetMapping("/myboards.do")
	@ResponseBody
	public List<BoardDto> myBoards(HttpServletRequest request) {
		return myPageService.myBoardList(request);
	}

	// @RequestMapping("mybookmarks.do")
	// @ResponseBody
	// public List<BoardDto> myBookmarks(HttpServletRequest request) {
	// 	return myPageService.myBookmarks(request);
	// }

	// @RequestMapping("followers.do")
	// @ResponseBody
	// public List<UserDto> followers() {
	// 	return userList;
	// }

	// @RequestMapping("followings.do")
	// @ResponseBody
	// public List<UserDto> followings() {
	// 	return userList;
	// }
}
