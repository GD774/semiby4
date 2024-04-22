package com.gdu.semiby4.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.UserMapper;

@Service
public class AdminServiceImpl implements AdminService {

  private final UserMapper userMapper;
  
  public AdminServiceImpl(UserMapper userMapper) {
    super();
    this.userMapper = userMapper;
  }

  @Override
  public List<UserDto> adminUserList() {
    return userMapper.adminUserList();
  }

  @Override
  public List<UserDto> adminUserList2() {
    return userMapper.adminUserList2();
  }

  @Override
  public void dropUser(String email) {
    userMapper.dropUser(email);
  }

}
