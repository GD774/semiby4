package com.gdu.semiby4.service;

import java.util.Map;
import java.util.Optional;
import java.util.HashMap;
import java.util.List;
import java.sql.Date;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gdu.semiby4.dto.ScheduleDto;
import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.CalendarMapper;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class CalendarServiceImpl implements CalendarService {

  private final CalendarMapper calendarMapper;

  @Override
  public List<ScheduleDto> getAllEvents(HttpServletRequest request) {
		int userNo = Integer.parseInt(request.getParameter("userNo"));
		return calendarMapper.getAllEvents(userNo);
  }

  @Override
  public int createEvent(HttpServletRequest request) {

    int userNo = Integer.parseInt(request.getParameter("userNo"));

    String title = request.getParameter("title");
    String contents = request.getParameter("contents");
		String startStr = request.getParameter("startDate");
    Date start = Date.valueOf(startStr);
		String endStr = request.getParameter("endDate");
		Optional<String> opt = Optional.ofNullable(endStr);
		Date end = Date.valueOf(opt.orElse(startStr));

    UserDto user = UserDto.builder()
			               .userNo(userNo)
				           .build();

    ScheduleDto scheduleDto = ScheduleDto.builder()
                             .user(user)
                             .title(title)
                             .contents(contents)
                             .startDate(start)
                             .endDate(end)
                           .build();

    return calendarMapper.createEvent(scheduleDto);
  }

  @Override
  public int updateEvent(HttpServletRequest request) {
		int userNo = Integer.parseInt(request.getParameter("userNo"));
		int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));

    String title = request.getParameter("title");
    String contents = request.getParameter("contents");
		String startStr = request.getParameter("startDate");
    Date start = Date.valueOf(startStr);
		String endStr = request.getParameter("endDate");
		Optional<String> opt = Optional.ofNullable(endStr);
		Date end = Date.valueOf(opt.orElse(startStr));

		UserDto user = UserDto.builder()
			               .userNo(userNo)
				           .build();

		ScheduleDto scheduleDto = ScheduleDto.builder()
			                       .scheduleNo(scheduleNo)
                             .user(user)
                             .title(title)
                             .contents(contents)
                             .startDate(start)
                             .endDate(end)
                           .build();

    return calendarMapper.updateEvent(scheduleDto);
  }

  @Override
  public int deleteEvent(HttpServletRequest request) {
    return calendarMapper.deleteEvent(Integer.parseInt(request.getParameter("scheduleNo")));
  }
}
