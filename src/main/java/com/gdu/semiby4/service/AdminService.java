package com.gdu.semiby4.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.gdu.semiby4.dto.PenaltyDto;
import com.gdu.semiby4.dto.ReportDto;
import com.gdu.semiby4.dto.UserDto;

public interface AdminService {
  //getUserBoardList
  //getComList
  //dropUser
  List<UserDto> adminUserList();
	List<UserDto> searchUsers(HttpServletRequest request);
	List<UserDto> searchUsersByContents(HttpServletRequest request);
	List<UserDto> searchUsersByReports(HttpServletRequest request);
	List<ReportDto> getBoardReportsByUser(HttpServletRequest request);
	List<ReportDto> getUserReportsByUser(HttpServletRequest request);
	List<PenaltyDto> getPenalties(HttpServletRequest request);
	int deleteUsers(HttpServletRequest request);
	int recoverUsers(HttpServletRequest request);
  List<UserDto> getuserInfo(String userId);
  void dropUser(String userId);
  //void dropUser(UserDto user);
}
