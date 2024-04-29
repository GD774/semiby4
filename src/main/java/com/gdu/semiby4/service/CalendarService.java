package com.gdu.semiby4.service;

import java.util.Map;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.gdu.semiby4.dto.ScheduleDto;

public interface CalendarService {
  List<ScheduleDto> getAllEvents(HttpServletRequest request);
  int createEvent(HttpServletRequest request);
	int updateEvent(HttpServletRequest request);
	int deleteEvent(HttpServletRequest request);
}
