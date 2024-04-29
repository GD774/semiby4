package com.gdu.semiby4.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
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

import lombok.extern.slf4j.Slf4j;

import com.gdu.semiby4.dto.PenaltyDto;
import com.gdu.semiby4.dto.ReportDto;
import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.UserMapper;
import com.gdu.semiby4.service.AdminService;
import com.gdu.semiby4.service.BoardService;
import com.gdu.semiby4.service.UserService;

@Slf4j
@RequestMapping("/admin")
@Controller
public class AdminController {
  
  @Autowired
  private final AdminService adminService;
  
  public AdminController(AdminService adminService) {
    super();
    this.adminService = adminService;
  }

  @GetMapping("")
  public String adminPage(Model model) {
    return "admin/main";
  }

	@PostMapping("/searchUsers.do")
	@ResponseBody
	public List<UserDto> searchUsers(HttpServletRequest request) {
		return adminService.searchUsers(request);
	}

	@PostMapping("/searchUsersByContents.do")
	@ResponseBody
	public List<UserDto> searchUsersByContents(HttpServletRequest request) {
		return adminService.searchUsersByContents(request);
	}

	@PostMapping("/searchUsersByReports.do")
	@ResponseBody
	public List<UserDto> searchUsersByReports(HttpServletRequest request) {
		return adminService.searchUsersByReports(request);
	}

	@GetMapping("/getBoardReportsByUser.do")
	@ResponseBody
	public List<ReportDto> getBoardReportsByUser(HttpServletRequest request) {
		return adminService.getBoardReportsByUser(request);
	}

	@GetMapping("/getUserReportsByUser.do")
	@ResponseBody
	public List<ReportDto> getUserReportsByUser(HttpServletRequest request) {
		return adminService.getUserReportsByUser(request);
	}

	@GetMapping("/getPenalties.do")
	@ResponseBody
	public List<PenaltyDto> getPenalties(HttpServletRequest request) {
		return adminService.getPenalties(request);
	}

	@PostMapping("/deleteUsers.do")
	@ResponseBody
	public int deleteUsers(HttpServletRequest request) {
		return adminService.deleteUsers(request);
	}

	@PostMapping("/recoverUsers.do")
	@ResponseBody
	public int recoverUsers(HttpServletRequest request) {
		return adminService.recoverUsers(request);
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

  @PostMapping("/dropId")
  @ResponseBody
  public String dropID(String userId) {
    System.out.println("새롭고 새롭게 최대한 알아볼 수 있는 무언어넉ㄱ사" + userId);
    adminService.dropUser(userId);
    System.out.println("최대한 알아볼 수 없음");
    return "arbitrary message";
  }

}
