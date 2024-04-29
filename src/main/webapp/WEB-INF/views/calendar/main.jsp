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
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

  <!-- include moment.js -->
  <script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>

<meta charset='utf-8' />
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

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
  
  .form-control{
  width: 230px;
  }
  
  .modal-body{
  margin: 8px;
  
  }
  .frm-schedule-register{
   width: 200px;
   display: flex;
   justify-content: center;
   align-items: center;
  }
  
  #date{
  display: flex;
  justify-content: center;
  }
  
  #scheduleTitle{
  margin-top: 10px;
  width: 480px;
  }
  #scheduleContents{
  width: 480px;
  }
  .fc-event-container{
  background-color: grey;
  }
  

</style>
</head>
<body>

  <div id="calendar"></div>

  <!-- Modal -->
  <div id="editSchedule" class="modal fade" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-scrollable">
      <div class="modal-content">
		<form id="frm-schedule-register"
			  method="POST">
		  <div class="modal-header">
			<h1 id="modalTitle" class="modal-title fs-5"></h1>
			<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		  </div>
		  <input type="hidden" id="user-no" name="userNo" class="modal-body" value="${sessionScope.user.userNo}">
		  <input type="hidden" id="schedule-no" name="scheduleNo" class="modal-body">
      
      <div id="date">
		  <input type="date" id="scheduleStart" name="startDate" class="form-control modal-body">
		  <input type="date" id="scheduleEnd" name="endDate" class="form-control modal-body" >
      </div>

		  <input type="text" id="scheduleTitle" name="title" class="form-control modal-body" placeholder="일정">
		  <input type="text" id="scheduleContents" name="contents" class="form-control modal-body" placeholder="상세내용">
		  <div class="modal-footer">
			<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">close</button>
			<button type="submit" id="btn-submit" class="btn btn-primary"></button>
		  </div>
		</form>
      </div>
	</div>
  </div>

<script>

  const fnInitialize = () => {
	  $('#modalTitle').empty();
	  $('#scheduleStart').empty();
	  $('#scheduleEnd').empty();
	  $('#scheduleTitle').empty();
	  $('#scheduleContents').empty();
	  $('#scheduleStart').attr('value', '');
	  $('#scheduleEnd').attr('value', '');
	  $('#scheduleTitle').attr('value', '');
	  $('#scheduleContents').attr('value', '');
	  // $('#calendar').empty();
	  $('#btn-delete').remove();
	  $('#btn-submit').empty();
	  $('#frm-schedule-register').attr('action', '');
  }

  function getAllEvents(calendar) {
      $.ajax({
		  method: 'GET',
          url: '${contextPath}/calendar/getdata',
		  data: 'userNo=${sessionScope.user.userNo}',
          dataType: 'json',
          success: (data) => {
              var events = [];
              for (var i = 0; i < data.length; i++) {
                  var eventData = {
                      scheduleNo    : data[i].scheduleNo,
                      userNo    : data[i].user.userNo,
                      title     : data[i].title,
                      contents  : data[i].contents,
                      start     : moment(data[i].startDate).format('YYYY-MM-DD'),
                      end       : moment(data[i].endDate).format('YYYY-MM-DD')
                  };
                  events.push(eventData);
              }

              calendar.addEventSource(events);
          },
          error: (jqXHR) => {
              console.log('이벤트 데이터를 가져오는 중 오류 발생: ' + jqXHR.status + ', ' + jqXHR.statusText);
          }
      });
  }

  const fnRenderCalendar = () => {
	  document.addEventListener('DOMContentLoaded', () => {
		  // FullCalendar 초기화
		  var calendarEl = document.getElementById('calendar');
		  // var calendarEl = $('#calendar')[0];
		  var calendar = new FullCalendar.Calendar(calendarEl, {
			  headerToolbar: {
				  left: 'prevYear,prev,next,nextYear today',
				  center: 'title',
				  right: 'dayGridMonth,dayGridWeek,dayGridDay'
			  },
			  initialDate: moment(Date.now()).format('YYYY-MM-DD'),
			  navLinks: true, // can click day/week names to navigate views
			  dayMaxEvents: true, // allow "more" link when too many events
			  dateClick: fnDateClick,
			  eventClick: fnEventClick
		  });
		  calendar.render();

		  getAllEvents(calendar);

	  })};

  const fnDeleteSchedule = (evt) => {
	  // evt.preventDefault();
	  scheduleNo = evt.currentTarget.scheduleNo;
	  $.ajax({
		  method: 'POST',
		  url: '${contextPath}/calendar/deleteSchedule.do',
		  // data: 'scheduleNo=' + scheduleNo,
		  data: {scheduleNo: scheduleNo},
		  success: (data) => {},
		  error: (jqXHR) => {
			  alert('you\'ve got one part of that wrong: ' + jqXHR.status + jqXHR.statusText);
		  }
	  });
  }

  const fnDateClick = (info) => {
	  $('#modalTitle').append('일정 등록');
	  $('#btn-submit').append('등록');
	  $('#frm-schedule-register').attr('action', "${contextPath}/calendar/registerSchedule.do");
  	  $('#scheduleStart').attr('value', moment(Date.parse(info.date)).format('YYYY-MM-DD'));
  	  $('#scheduleEnd').attr('value', moment(Date.parse(info.date)).format('YYYY-MM-DD'));
  	  const modalSchedule = new bootstrap.Modal('#editSchedule');
  	  modalSchedule.show();
  }

  const fnEventClick = (info) => {
	  $('#modalTitle').append('일정 수정');
	  $('#btn-submit').before('<button type="button" id="btn-delete" class="btn btn-secondary" data-bs-dismiss="modal">삭제</button>')
	  // $('#btn-delete').append('삭제');
	  $('#btn-submit').append('수정');
	  $('#frm-schedule-register').attr('action', "${contextPath}/calendar/editSchedule.do");
	  $('#schedule-no').attr('value', info.event.extendedProps.scheduleNo);
	  $('#scheduleTitle').attr('value', info.event.title);
	  $('#scheduleStart').attr('value', moment(Date.parse(info.event.start)).format('YYYY-MM-DD'));
  	  $('#scheduleEnd').attr('value', moment(Date.parse(info.event.end)).format('YYYY-MM-DD'));
	  $('#scheduleContents').attr('value', info.event.extendedProps.contents);
	  const modalSchedule = new bootstrap.Modal('#editSchedule');
	  modalSchedule.show();

	  document.getElementById('btn-delete').removeEventListener('click', fnDeleteSchedule);
	  const deleteButton = document.getElementById('btn-delete');
	  deleteButton.scheduleNo = info.event.extendedProps.scheduleNo;
	  deleteButton.addEventListener('click', fnDeleteSchedule);
  }

  fnRenderCalendar();

  const scheduleModalEl = document.getElementById('editSchedule');
  scheduleModalEl.addEventListener('hidden.bs.modal', event => {
	  fnInitialize();
	  // fnRenderCalendar();
  })

</script>
</body>
</html>
