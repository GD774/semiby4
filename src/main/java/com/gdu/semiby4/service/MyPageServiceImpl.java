package com.gdu.semiby4.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.UserMapper;
import com.gdu.semiby4.mapper.MyPageMapper;
import com.gdu.semiby4.utils.MySecurityUtils;

@RequiredArgsConstructor
@Service
public class MyPageServiceImpl implements MyPageService {

	private final UserMapper userMapper;
	private final MyPageMapper myPageMapper;

  public List<BoardDto> myBoardList(HttpServletRequest request) {
		int userNo = Integer.parseInt(request.getParameter("userNo"));
		return myPageMapper.myBoardList(userNo);
	}

	public UserDto userInfo(HttpServletRequest request) {
		int userNo = Integer.parseInt(request.getParameter("userNo"));
		return myPageMapper.userInfo(userNo);
	}

	// public List<BoardDto> mybookmarks(HttpServletRequest request) {
	// 	int userNo = Integer.parseInt(request.getParameter("userNo"));
	// 	return myPageMapper.mybookmarks(userNo);
	// }

	@Override
  public void edit(HttpServletRequest request, HttpServletResponse response) {

		// 당연히 나중에 반드시 정상적으로 세션으로 userNo 를 받도록 수정해야 함
		// HttpSession session = request.getSession();
		// UserDto userPrev = (UserDto) session.getAttribute("user");
		// int userNo = userPrev.getUserNo();
		int userNo = Integer.parseInt(request.getParameter("userNo"));

    // 전달된 파라미터
		String userId = request.getParameter("userId");
    String pw = MySecurityUtils.getSha256(request.getParameter("pw"));
    String name = MySecurityUtils.getPreventXss(request.getParameter("name"));
    String mobile = request.getParameter("mobile");
    String gender = request.getParameter("gender");
    
    // Mapper 로 보낼 UserDto 객체 생성
    UserDto userPost = UserDto.builder()
			                        .userNo(userNo)
			                        .userId(userId)
                              .pw(pw)
                              .name(name)
                              .mobile(mobile)
                              .gender(gender)
                            .build();

    // 회원 가입
    int insertCount = myPageMapper.editUser(userPost);
    
    // 응답 만들기 (성공하면 sign in 처리하고 /main.do 이동, 실패하면 뒤로 가기)
    try {
      
      response.setContentType("text/html");
      PrintWriter out = response.getWriter();
      out.println("<script>");
      
      // 가입 성공
      if(insertCount == 1) {
       
        // Sign In 및 접속 기록을 위한 Map
        Map<String, Object> params = Map.of("userId", userId
                                          , "pw", pw
                                          , "ip", request.getRemoteAddr()
                                          , "userAgent", request.getHeader("User-Agent")
                                          , "sessionId", request.getSession().getId());
       
        // Sign In (세션에 수정된 user 저장하기)
        request.getSession().setAttribute("user", userMapper.getUserByMap(params));
       
        out.println("alert('정보 수정 완료.');");
        out.println("location.href='" + request.getContextPath() + "/main.page';");
        
      // 가입 실패
      } else {
        out.println("alert('정보 수정 실패.');");
        out.println("history.back();");
      }
      out.println("</script>");
      out.flush();
      out.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    
  }
}
