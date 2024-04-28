package com.gdu.semiby4.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gdu.semiby4.dto.CalendarDto;
import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.CalendarMapper;

@Service
public class CalendarServiceImpl implements CalendarService {

  @Autowired
  private CalendarMapper calendarMapper;

  @Override
  public List<CalendarDto> getAllEvents(HttpServletRequest request) {
    // return calendarMapper.getAllEvents(request);
		return null;
  }

  @Override
  public CalendarDto createEvent(HttpServletRequest request) {
          
  
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    
    
    String title = request.getParameter("title");
    String contents = request.getParameter("contents");
    String start = request.getParameter("start");
    String end = request.getParameter("end");
    
    UserDto user = new UserDto();
    user.setUserNo(userNo);
    
    
    CalendarDto calendarDto = CalendarDto.builder()
                             .user(user)
                             .title(title)
                             .contents(contents)
                             .startDate(start)
                             .endDate(end)
                           .build();
    
     
    
    return calendarMapper.createEvent(calendarDto);
  }

  @Override
  public CalendarDto updateEvent(CalendarDto calendarDto) {
    calendarMapper.updateEvent(calendarDto);
    return calendarDto;
  }

  @Override
  public void deleteEvent(Long userNo) {
    calendarMapper.deleteEvent(userNo);
  }
}
