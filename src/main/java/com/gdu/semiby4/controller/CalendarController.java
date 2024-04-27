package com.gdu.semiby4.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gdu.semiby4.dto.ScheduleDto;
import com.gdu.semiby4.service.CalendarService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/calendar")
@RequiredArgsConstructor
@Controller
public class CalendarController {

	private final CalendarService calendarService;

	@RequestMapping("")
	public String calendarMain() {
		return "calendar/main";
	}

	@GetMapping("/create")
	public String createSchedule(Model model) {
		model.addAttribute("pageTitle", "일정 추가");
		return "calendar/create";
	}

	@GetMapping("/edit")
	public String editSchedule(Model model) {
		return "calendar/create";
	}

	@GetMapping(value = "/getdata", produces = "application/json")
	@ResponseBody
	public List<ScheduleDto> getAllEvents(HttpServletRequest request) {
		return calendarService.getAllEvents(request);
	}

	@PostMapping("/registerSchedule.do")
	public String createEvent(HttpServletRequest request) {
		calendarService.createEvent(request);
		return "redirect:/calendar";
	}

	@PostMapping("/editSchedule.do")
	public String editEvent(HttpServletRequest request) {
		calendarService.updateEvent(request);
		return "redirect:/calendar";
	}

	//      @PostMapping("/register.do")
	//    public String createEvent(HttpServletRequest request) {
	//        System.out.println("이벤트생성컨트롤러 성공 ");
	//        calendarService.createEvent(request);
	//        return "redirect:/calendar/main";
	//    }

	// @DeleteMapping("/deleteSchedule.do")
	@PostMapping("/deleteSchedule.do")
	public String deleteEvent(HttpServletRequest request) {
		calendarService.deleteEvent(request);
		return "redirect:/calendar";
	}
}
