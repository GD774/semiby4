package com.gdu.semiby4.mapper;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gdu.semiby4.dto.PenaltyDto;
import com.gdu.semiby4.dto.ReportDto;
import com.gdu.semiby4.dto.UserDto;

@Mapper
public interface AdminMapper {
	List<UserDto> searchUsers(String keyword);
	int deleteUsers(@Param("userNos") ArrayList<Integer> userNos);
	int recoverUsers(@Param("userNos") ArrayList<Integer> userNos);
	List<ReportDto> getBoardReportsByUser(int userNo);
	List<ReportDto> getUserReportsByUser(int userNo);
	List<PenaltyDto> getPenalties(int userNo);
}
