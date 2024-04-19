package com.gdu.semiby4.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import com.gdu.semiby4.dto.UserDto;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class BoardDto {
  private int attachCount;
  int boardNo, hit;
	String title, contents, cateNo;
	Timestamp createDt, modifyDt;
	UserDto user;
}
