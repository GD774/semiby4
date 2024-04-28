package com.gdu.semiby4.mapper;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semiby4.dto.CalendarDto;

@Mapper
public interface CalendarMapper {

    List<CalendarDto> getAllEvents();
    CalendarDto createEvent(CalendarDto calendarDto);
    CalendarDto updateEvent(CalendarDto calendarDto);
    CalendarDto deleteEvent(Long userNo);
}
