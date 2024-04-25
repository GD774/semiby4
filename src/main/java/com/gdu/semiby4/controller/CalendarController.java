package com.gdu.semiby4.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gdu.semiby4.dto.CalendarDto;
import com.gdu.semiby4.service.CalendarService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/calendar")
@RequiredArgsConstructor
@Controller
public class CalendarController {

    
    private final CalendarService calendarService;

    @RequestMapping("/list")
    public String viewMain() {
    
      return "calendar/list";
    }
    
    @GetMapping("/error")
    public String showErrorPage() {
        return "error"; // 에러 페이지 이름
    }

    
    @GetMapping("/create")
    public String showCreatePage() {
           // 새로운 일정 작성 페이지를 보여주는 로직을 여기에 작성합니다.
        return "calendar/create"; // 적절한 뷰 이름을 반환합니다.
    }

    
    @GetMapping(value = "/getdata", produces = "application/json")
    @ResponseBody
    public List<Map<String, Object>> getAllEvents(HttpServletRequest request) {
          
        List<CalendarDto> listAll = calendarService.getAllEvents(request);
        
        List<Map<String, Object>> result = new ArrayList<Map<String,Object>>(); 
        
        for (int i = 0; i < listAll.size(); i++) {
          HashMap<String, Object> hash = new HashMap<>();
          hash.put("scheduleId", listAll.get(i).getScheduleNo());
          hash.put("userNo", listAll.get(i).getUser().getUserNo());
          hash.put("title", listAll.get(i).getTitle());
          hash.put("start", listAll.get(i).getStartDate());
          hash.put("end", listAll.get(i).getEndDate());
          hash.put("contents", listAll.get(i).getContents());
          
          result.add(hash);
      }
        System.out.println(result);
        
        return result; 
    }

    @PostMapping("/register.do")
    public String createEvent(HttpServletRequest request) {
        System.out.println("이벤트생성컨트롤러 성공 ");
        
        try {
            calendarService.createEvent(request);
        } catch (NumberFormatException e) {
            // 숫자 변환 예외 발생 시 처리
            e.printStackTrace(); // 또는 로그로 기록
            // 예외 처리 후 리다이렉트 또는 에러 페이지 표시 등
            return "redirect:/calendar/error"; // 에러 페이지로 리다이렉트
        }
        
        return "redirect:/calendar/list";
    }

    
    
//      @PostMapping("/register.do")
//    public String createEvent(HttpServletRequest request) {
//        System.out.println("이벤트생성컨트롤러 성공 ");
//        calendarService.createEvent(request);
//        return "redirect:/calendar/list";
//    }

//    @DeleteMapping("/{}")
//    public String deleteEvent(@PathVariable int scheduleId) {
//        calendarService.deleteEvent(scheduleId);
//        return "redirect:/calendar";
    }

