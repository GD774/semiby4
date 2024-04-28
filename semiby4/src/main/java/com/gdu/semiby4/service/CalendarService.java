package com.gdu.semiby4.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.gdu.semiby4.dto.CalendarDto;

public interface CalendarService {
   
  List<CalendarDto> getAllEvents(HttpServletRequest request);
  CalendarDto createEvent(HttpServletRequest request);
  CalendarDto updateEvent(CalendarDto calendarDto);
  void deleteEvent(Long userNo);
}
