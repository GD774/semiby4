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

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.UserMapper;
import com.gdu.semiby4.utils.MySecurityUtils;

@Slf4j
@Service
public class UserServiceImpl implements UserService {

  private final UserMapper userMapper;
  
  public UserServiceImpl(UserMapper userMapper) {
    super();
    this.userMapper = userMapper;
  }
  
  @Override
  public void signup(HttpServletRequest request, HttpServletResponse response) {

    // 전달된 파라미터
		String userId = request.getParameter("userId");
    String pw = MySecurityUtils.getSha256(request.getParameter("pw"));
		String email = request.getParameter("email");
    String name = MySecurityUtils.getPreventXss(request.getParameter("name"));
    String mobile = request.getParameter("mobile");
    String gender = request.getParameter("gender");
    String event = request.getParameter("event");
    
    // Mapper 로 보낼 UserDto 객체 생성
    UserDto user = UserDto.builder()
			                .userId(userId)
                      .email(email)
                      .pw(pw)
                      .name(name)
                      .mobile(mobile)
                      .gender(gender)
                    .build();
    
    // 회원 가입
    int insertCount = userMapper.insertUser(user);
    
    // 응답 만들기 (성공하면 sign in 처리하고 /main.do 이동, 실패하면 뒤로 가기)
    try {
      
      response.setContentType("text/html");
      PrintWriter out = response.getWriter();
      out.println("<script>");
      
      // 가입 성공
      if(insertCount == 1) {
       
        // Sign In 및 접속 기록을 위한 Map
        Map<String, Object> params = Map.of("email", email
                                          , "pw", pw
                                          , "ip", request.getRemoteAddr()
                                          , "userAgent", request.getHeader("User-Agent")
                                          , "sessionId", request.getSession().getId());
       
        // Sign In (세션에 user 저장하기)
        request.getSession().setAttribute("user", userMapper.getUserByMap(params));
       
        out.println("alert('회원 가입되었습니다.');");
        out.println("location.href='" + request.getContextPath() + "/main.page';");
        
      // 가입 실패
      } else {
        out.println("alert('회원 가입이 실패했습니다.');");
        out.println("history.back();");
      }
      out.println("</script>");
      out.flush();
      out.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    
  }
  
  @Override
  public void leave(HttpServletRequest request, HttpServletResponse response) {
    
    try {

      // 세션에 저장된 user 값 확인
      HttpSession session = request.getSession();
      UserDto user = (UserDto) session.getAttribute("user");
      
      // 세션 만료로 user 정보가 세션에 없을 수 있음
      if(user == null) {
        response.sendRedirect(request.getContextPath() + "/main.page");
      }
      
      // 탈퇴 처리
      int deleteCount = userMapper.deleteUser(user.getUserNo());
      
      // 탈퇴 이후 응답 만들기
      response.setContentType("text/html");
      PrintWriter out = response.getWriter();
      out.println("<script>");
      
      // 탈퇴 성공
      if(deleteCount == 1) {
        
        // 세션에 저장된 모든 정보 초기화
        session.invalidate();  // SessionStatus 객체의 setComplete() 메소드 호출
        
        out.println("alert('탈퇴되었습니다. 이용해 주셔서 감사합니다.');");
        out.println("location.href='" + request.getContextPath() + "/main.page';");
        
      // 탈퇴 실패
      } else {
        out.println("alert('탈퇴되지 않았습니다.');");
        out.println("history.back();");
      }
      out.println("</script>");
      
    } catch (Exception e) {
      e.printStackTrace();
    }
    
  }
  
  @Override
  public String getRedirectURLAfterSignin(HttpServletRequest request) {
    
    // Sign In 페이지 이전의 주소가 저장되어 있는 Request Header 의 referer 값 확인
    String referer = request.getHeader("referer");
    
    // referer 로 돌아가면 안 되는 예외 상황 (아이디/비밀번호 찾기 화면, 가입 화면 등)
    String[] excludeURLs = {"/findId.page", "/findPw.page", "/signup.page", "/upload/edit.do"};
    
    // Sign In 이후 이동할 url
    String url = referer;
    if(referer != null) {
      for(String excludeURL : excludeURLs) {
        if(referer.contains(excludeURL)) {
          url = request.getContextPath() + "/main.page";
          break;
        }
      }
    } else {
      url = request.getContextPath() + "/main.page";
    }
    
    return url;
    
  }
  
  @Override
  public void signin(HttpServletRequest request, HttpServletResponse response) {
    try {

			String userId = request.getParameter("userId");
      
      // // 입력한 아이디
      // String email = request.getParameter("email");
      
      // 입력한 비밀번호 + SHA-256 방식의 암호화
      String pw = MySecurityUtils.getSha256(request.getParameter("pw"));
			
			// 접속 IP (접속 기록을 남길 때 필요한 정보)
			String ip = request.getRemoteAddr();
			
			// 접속 수단 (요청 헤더의 User-Agent 값)
			String userAgent = request.getHeader("User-Agent");
			
			// DB로 보낼 정보 (email/pw: USER_T , email/ip/userAgent/sessionId: ACCESS_HISTORY_T) 
			Map<String, Object> params = Map.of("userId", userId
																				// , "email", email
			                                  , "pw", pw
			                                  , "ip", ip
			                                  , "userAgent", userAgent);
			
			// email/pw 가 일치하는 회원 정보 가져오기
			UserDto user = userMapper.getUserByMap(params);

			// 일치하는 회원 있음 (Sign In 성공)
			if (user != null) {
				if (user.getDeletedDt() == null) {

					// 회원 정보를 세션(브라우저 닫기 전까지 정보가 유지되는 공간, 기본 30분 정보 유지)에 보관하기
					HttpSession session = request.getSession();

					session.setAttribute("user", user);
					session.setMaxInactiveInterval(1000);

					// Sign In 후 페이지 이동
					response.sendRedirect(request.getParameter("url"));
				} else {
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter out = response.getWriter();

					out.println("<script>");
					out.println("alert('정지 당한 회원.');");
					out.println("location.href='" + request.getContextPath() + "/main.page';");
					out.println("</script>");
					out.flush();
					out.close();
				}
			// 일치하는 회원 없음 (Sign In 실패)
			} else {
			  response.setContentType("text/html; charset=UTF-8");
			  PrintWriter out = response.getWriter();
			  
			  out.println("<script>");
				out.println("alert('일치하는 회원 정보가 없습니다.');");
				out.println("location.href='" + request.getContextPath() + "/main.page';");
			  out.println("</script>");
			  out.flush();
			  out.close();
			}

    } catch (Exception e) {
      e.printStackTrace();
    }

  }

  @Override
  public void signout(HttpServletRequest request, HttpServletResponse response) {
    
    try {
      
      // Sign Out 기록 남기기
      HttpSession session = request.getSession();
      String sessionId = session.getId(); 
      
      // 세션에 저장된 모든 정보 초기화
      session.invalidate();
      
      // 메인 페이지로 이동
      response.sendRedirect(request.getContextPath() + "/main.page");
      
    } catch (Exception e) {
      e.printStackTrace();
    }
    
  }
 
}
