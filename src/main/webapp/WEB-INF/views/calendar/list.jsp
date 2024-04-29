<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>" />
<c:set var="dt" value="<%=System.currentTimeMillis() %>" />
<!DOCTYPE html>
<html>
<head>

  <!-- include libraries(jquery, bootstrap) -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

  <!-- include moment.js -->
  <script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>

<meta charset='utf-8' />
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

<div>
  <button id="btn-main" onclick="location.href='http://localhost:8080/'">메인으로 가기</button>
</div>

<style>
  body {
    margin: 40px 10px;
    padding: 0;
    font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
    font-size: 14px;
  }
  #calendar {
    max-width: 1100px;
    margin: 0 auto;
  }
  
  #btn-create {
    margin-top : 20px;
    margin-bottom : 100px;
    margin-left: 1226px; 
  
  }
  
  #btn-main {
  margin-left: 200px;
  margin-bottom: 25px;
  
  }
</style>
</head>
<body>

  <div id='calendar'></div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // FullCalendar 초기화
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
        headerToolbar: {
            left: 'prevYear,prev,next,nextYear today',
            center: 'title',
            right: 'dayGridMonth,dayGridWeek,dayGridDay'
        },
        initialDate: '2024-04-30',
        navLinks: true, // can click day/week names to navigate views
        editable: true,
        dayMaxEvents: true // allow "more" link when too many events
    
      }
      
      );
      function getAllEvents() {
          $.ajax({
              url: '${contextPath}/calendar/getdata',
              method: 'GET',
              dataType: 'json',
              success: (data) => {
                console.log(data);
                  var events = [];
                  for (var i = 0; i < data.length; i++) {
                      var eventData = {
                          scheduleNo    : data[i].scheduleNo,
                              userNo    : data[i].userNo,
                              title     : data[i].title,
                              contents  : data[i].contents,
                              start     : data[i].start,
                              end       : data[i].end
                      };
                      events.push(eventData);
                  }
                  
                  // 가져온 이벤트를 FullCalendar에 추가
                  console.log(eventData);
                  calendar.addEventSource(events);
                },
                error: (jqXHR) => {
                  console.log('이벤트 데이터를 가져오는 중 오류 발생: ', jqXHR.status);
                }
              });
    // 모든 이벤트 가져오기
}
    
calendar.render();
    
getAllEvents();

    });
    
</script>

<div>
  <button id="btn-create" onclick="location.href='create'">일정 작성</button>
</div>


</body>
</html>
