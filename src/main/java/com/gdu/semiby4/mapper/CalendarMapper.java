package com.gdu.semiby4.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semiby4.dto.ScheduleDto;

@Mapper
public interface CalendarMapper {
    List<ScheduleDto> getAllEvents(int userNo);
    int createEvent(ScheduleDto scheduleDto);
    int updateEvent(ScheduleDto scheduleDto);
    int deleteEvent(int scheduleNo);
}
