package com.gdu.semiby4.dto;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class ScheduleDto {
  int scheduleNo, reminder;
	String title, contents;
	Date startDate, endDate;
	UserDto user;
}
