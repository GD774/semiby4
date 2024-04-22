package com.gdu.semiby4.service;

import java.util.List;

import com.gdu.semiby4.dto.UserDto;

public interface AdminService {
  //getAllBoard
  //adminUserList
  //getUserBoardList
  //getComList
  //dropUser
  List<UserDto> adminUserList();
  List<UserDto> adminUserList2();
  void dropUser(String id);
  
}
