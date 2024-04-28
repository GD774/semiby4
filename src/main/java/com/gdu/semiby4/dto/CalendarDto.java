package com.gdu.semiby4.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class CalendarDto {
  UserDto user;
  int scheduleNo;
  String title, contents,  startDate, endDate;


 
}
