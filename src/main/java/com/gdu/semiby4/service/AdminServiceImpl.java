package com.gdu.semiby4.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import com.gdu.semiby4.dto.PenaltyDto;
import com.gdu.semiby4.dto.ReportDto;
import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.UserMapper;
import com.gdu.semiby4.mapper.AdminMapper;

@Slf4j
@RequiredArgsConstructor
@Service
public class AdminServiceImpl implements AdminService {

  private final UserMapper userMapper;
	private final AdminMapper adminMapper;

  /*
  @Override
  public void dropUser(UserDto user) {
    try {
      // 사용자 정보 생성
      UserDto dropUser = new UserDto();

      dropUser.setUserId(user.getUserId());
      // 비활성화를 위한 ROLE 값을 2로 설정
      dropUser.setRole(2);
      
      System.out.println("dropUser 메서드 호출 확인: " + user.getUserId());
      userMapper.dropUser(dropUser);  // 사용자 비활성화 업데이트
      
      System.out.println("사용자 ROLE 업데이트 완료: " + user.getUserId());
      // 이 부분이 출력이 안 됨. 받아오지 못하는 부분이 있어 role 값이 변하지 않음.
  } catch (Exception e) {
      throw new RuntimeException("사용자 권한 업데이트 실패", e);
    }
  }
  */

  

/*
@Override
public ResponseEntity<Map<String, Object>> getuserInfo(Map<String, Object> params) {
  Map<String, Object> userInfo = userMapper.getuserInfo(params);
  
  if(userInfo != null && !userInfo.isEmpty()) {
    return new ResponseEntity<>(userInfo, HttpStatus.OK);
  } else {
    return new ResponseEntity<>(userInfo, HttpStatus.NOT_FOUND); 
  }
}
*/
  @Override
  public List<UserDto> adminUserList() {
    return userMapper.adminUserList();
  }

	@Override
	public List<UserDto> searchUsers(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("searchContents"));
		return adminMapper.searchUsers(opt.orElse(""));
	}

	@Override
	public List<UserDto> searchUsersByContents(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("searchContents"));
		return adminMapper.searchUsers(opt.orElse(""));
	}

	@Override
	public List<UserDto> searchUsersByReports(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("searchContents"));
		return adminMapper.searchUsers(opt.orElse(""));
	}

	@Override
	public List<ReportDto> getBoardReportsByUser(HttpServletRequest request) {
		int userNo = Integer.parseInt(request.getParameter("userNo"));
		return adminMapper.getBoardReportsByUser(userNo);
	}

	@Override
	public List<ReportDto> getUserReportsByUser(HttpServletRequest request) {
		int userNo = Integer.parseInt(request.getParameter("userNo"));
		return adminMapper.getUserReportsByUser(userNo);
	}

	@Override
	public List<PenaltyDto> getPenalties(HttpServletRequest request) {
		int userNo = Integer.parseInt(request.getParameter("userNo"));
		return adminMapper.getPenalties(userNo);
	}

	@Override
	public int deleteUsers(HttpServletRequest request) {
		String targetString = request.getParameter("userNos");
		if (targetString.length() == 0)
			return -1;
		String[] targetArray = targetString.split(",");
		ArrayList<Integer> targets = new ArrayList<>();
		for (String userNo: targetArray)
			targets.add(Integer.parseInt(userNo));
		return adminMapper.deleteUsers(targets);
	}

	@Override
	public int recoverUsers(HttpServletRequest request) {
		String targetString = request.getParameter("userNos");
		if (targetString.length() == 0)
			return -1;
		String[] targetArray = targetString.split(",");
		ArrayList<Integer> targets = new ArrayList<>();
		for (String userNo: targetArray)
			targets.add(Integer.parseInt(userNo));
		return adminMapper.recoverUsers(targets);
	}

  @Override
  public List<UserDto> getuserInfo(String userId) {
      return userMapper.getuserInfo(userId);
  }  
  
  @Override
  public void dropUser(String userId) {
    System.out.println("userId 메서드 호출 확인: " + userId);
    userMapper.dropUser(userId);
  }
  
}
