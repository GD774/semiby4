package com.gdu.semiby4.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semiby4.dto.UserDto;

@Mapper
public interface UserMapper {
  UserDto getUserByMap(Map<String, Object> map);
  int insertUser(UserDto user);
  int deleteUser(int userNo);
  Map<String, Object> getuserInfo(Map<String, Object> params);
  List<UserDto> adminUserList();
  List<UserDto> adminUserList2();
  void dropUser(String email);
  
}
