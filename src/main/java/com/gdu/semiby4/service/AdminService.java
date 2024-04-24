package com.gdu.semiby4.service;

import java.util.List;

import com.gdu.semiby4.dto.UserDto;

public interface AdminService {
  //getUserBoardList
  //getComList
  //dropUser
  List<UserDto> adminUserList();
  List<UserDto> getuserInfo(String userId);
  void dropUser(String userId);
  //void dropUser(UserDto user);
}
