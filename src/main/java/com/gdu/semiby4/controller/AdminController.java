package com.gdu.semiby4.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gdu.semiby4.service.AdminService;

@RequestMapping("/board")
@Controller
public class AdminController {
 
  private AdminService adminService;
  
  @GetMapping("/admin.page")
  public String adminPage() {
    return "board/admin";
  }
  
}
