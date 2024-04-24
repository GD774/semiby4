package com.gdu.semiby4.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.UserMapper;
import com.gdu.semiby4.service.AdminService;
import com.gdu.semiby4.service.BoardService;
import com.gdu.semiby4.service.UserService;

@RequestMapping("/admin")
@Controller
public class AdminController {
  
  @Autowired
  private final AdminService adminService;
  
  public AdminController(AdminService adminService) {
    super();
    this.adminService = adminService;
  }
  
  @GetMapping("/admin.page")
  public String adminPage(Model model) {
    System.out.println("메인 페이지로");
    return "admin/admin";
  }
  
  @GetMapping("/adminUserList.do")
    public ResponseEntity<List<UserDto>> userList() {
    System.out.println("유저 인포, 컨트롤러");
    List<UserDto> userList = adminService.adminUserList(); 
    return new ResponseEntity<>(userList, HttpStatus.OK);
  }

  @GetMapping("/getuserInfo.do")
  public ResponseEntity<List<UserDto>> userInfo(@RequestParam String userId) {
      System.out.println("userInfo");  
      List<UserDto> userList = adminService.getuserInfo(userId);
      if (userList == null || userList.isEmpty()) {
          return new ResponseEntity<>(HttpStatus.NO_CONTENT);
      }
      return new ResponseEntity<>(userList, HttpStatus.OK);
  }
 
/*
 // 기존 식
  @GetMapping("/adminUserList.do")      // 기존 controller는 Ajax에서 data 요청 보낸 것을 받을 때 문제가 있었음.
  public ResponseEntity<Map<String, Object>> userList(HttpServletRequest request, Model model) {
    System.out.println("유저 인포, 컨트롤러");
    Map<String, Object> params = new HashMap<String, Object>();
    String userId = request.getParameter("userId");
    if(userId != null) {
      params.put("userId", userId);
      model.addAttribute("userId", userId);
    }
    return adminService.adminuserList(params);
  }
*/
  //기존 사용자 비활성화 식 : 미완성
  /*
  @DeleteMapping("/{userId}")
  public ResponseEntity<Map<String, Object>> dropUser(@PathVariable String userId) {
      try {
          UserDto user = new UserDto();
          user.setUserId(userId);
          adminService.dropUser(user);  // 서비스 호출
          return ResponseEntity.ok(Map.of("success", true, "message", "사용자 비활성 성공"));
      } catch (Exception e) {
          return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                  .body(Map.of("success", false, "message", "사용자 비활성 실패: " + e.getMessage()));
      }
  }
  */
  @PostMapping("/dropId")
  @ResponseBody
  public String dropID(String userId) {
    System.out.println("새롭고 새롭게 최대한 알아볼 수 있는 무언어넉ㄱ사" + userId);
    adminService.dropUser(userId);
    System.out.println("최대한 알아볼 수 없음");
    return "arbitrary message";
  }
  

  
}
