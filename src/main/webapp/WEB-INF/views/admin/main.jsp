<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
<jsp:include page="../layout/header.jsp"/>
<!-- <script type="module" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.js" integrity="sha512-7DgGWBKHddtgZ9Cgu8aGfJXvgcVv4SWSESomRtghob4k4orCBUTSRQ4s5SaC2Rz+OptMqNk0aHHsaUBk6fzIXw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script> -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- include fullCalendar -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

<style>
  .main-wrap {
	  display: flex;
	  justify-content: space-around;
  }

  .searchForm1 {
    float: left;
  }
  .selected {
  background-color: #e0e0e0;  // 선택된 행의 배경색
  }

  .fc-day-today {
	  background-color: inherit !important;
  }
</style>

<div id="main-frame">
  <h1 class="title">관리자 메인</h1>

  <!--
  <div>
	<select id="search-type" name="searchType">
	  <option value="id">유저 아이디</option>
	  <option value="contents">작성 내용</option>
	  <option value="reports">신고 내용</option>
	</select>
  </div>
  -->
  <div>
	<input type="text" id="search-contents">
  </div>
  <div>
	<button type="submit" id="btn-search">검색</button>
  </div>
  <button type="click" id="btn-delete">정지</button>
  <button type="click" id="btn-recover">복구</button>
  <!-- <button type="click" id="btn-redeem">면제</button> -->
  <div id="search-result">
	<form id="frm-users-list">
	  <!--
		  method="POST"
		  action="${contextPath}/admin/deleteUsers.do">
		-->
	  <table border="1" id="user-table">
		<thead>
		  <tr>
			<th>선택</th>
			<th>아이디</th>
			<th>이름</th>
			<th>이메일</th>
			<th>가입날짜</th>
			<th>정지날짜</th>
		  </tr>
		</thead>
		<tbody id="tbody-user-list">
		</tbody>
	  </table>
	</form>
  </div>
</div>

<div id="user-profile">
</div>

<script>

  class UserProfile {
	  constructor(htmlEl, userDto) {
		  this.el = htmlEl;
		  this.info = userDto;
		  this.brd = {}; // 게시물로 신고 먹은 데이터
		  this.urd = {}; // 유저가 바로 신고 먹은 데이터
		  this.bData = {}; // 이걸로 신고 먹은 게시물 바 차트
		  this.dData = {}; // 이걸로 신고 먹은 날짜 히트맵
		  this.pData = {}; // 이걸로 패널티 먹은 횟수
	  }

	  async fetchBoardProfile() {
		  await $.ajax({
			  method: 'GET',
			  url: '${contextPath}/admin/getBoardReportsByUser.do',
			  data: 'userNo=' + this.info.userNo,
			  dataType: 'json',
			  success: (resData) => {
				  // resData[ind] 는 리포트 데이터
				  // resData[ind].boardNo
				  this.brd = resData;
			  },
			  error: (jqXHR) => {
				  alert('failed to fetch board details: ' + jqXHR.statusText + '(' + jqXHR.status + ')');
			  }
		  })
	  }

	  // 히트맵 찍을 거임
	  async fetchReportProfile() {
		  await $.ajax({
			  method: 'GET',
			  url: '${contextPath}/admin/getUserReportsByUser.do',
			  data: 'userNo=' + this.info.userNo,
			  dataType: 'json',
			  success: (resData) => {
				  this.urd = resData;
			  },
			  error: (jqXHR) => {
				  alert('failed to fetch report details: ' + jqXHR.statusText + '(' + jqXHR.status + ')');
			  }
		  })
	  }

	  async fetchPenaltyProfile() {
		  await $.ajax({
			  method: 'GET',
			  url: '${contextPath}/admin/getPenalties.do',
			  data: 'userNo=' + this.info.userNo,
			  dataType: 'json',
			  success: (resData) => {
				  console.log(resData);
			  },
			  error: (jqXHR) => {
				  alert('failed to fetch actioned details: ' + jqXHR.statusText + '(' + jqXHR.status + ')');
			  }
		  })
	  }

	  async fetch() {
		  // fetch and parse
		  await this.fetchBoardProfile();
		  await this.fetchReportProfile();
		  await this.fetchPenaltyProfile();
	  }

	  processBdata() {
		  var stat = {};
		  for (var ind = 0; ind < this.brd.length; ind++) {
			  var bn = this.brd[ind].boardNo;
			  if (bn in stat)
				  stat[bn] += 1;
			  else
				  stat[bn] = 1;
		  }
		  for (var ind in stat) {
			  if (stat[ind] in this.bData)
				  this.bData[stat[ind]] += 1;
			  else
				  this.bData[stat[ind]] = 1;
		  }
	  }

	  processDdata() {
		  var stat = {};
		  for (var ind = 0; ind < this.brd.length; ind++)
			  stat[this.brd[ind].reportNo] = this.brd[ind].createDt;
		  for (var ind = 0; ind < this.urd.length; ind++)
			  stat[this.urd[ind].reportNo] = this.urd[ind].createDt;
		  for (var no in stat) {
			  var date = moment(stat[no]).format('YYYY-MM-DD');
			  if (date in this.dData)
				  this.dData[date] += 1;
			  else
				  this.dData[date] = 1;
		  }
	  }

	  processPdata() {
		  //
	  }

	  processTotal() {
		  this.processBdata();
		  this.processDdata();
		  this.processPdata();
	  }

	  renderBarChart(elementId, xs, ys, dataLabel) {
		  const ctx = document.getElementById(elementId);
		  new Chart(ctx, {
			  type: 'bar',
			  data: {
				  labels: xs,
				  datasets: [{
					  label: dataLabel,
					  data: ys,
					  borderWidth: 1
				  }]
			  },
			  options: {
				  scales: {
					  y: {
						  beginAtZero: true
					  }
				  }
			  }
		  })
	  }

	  renderCalendarHeatmap(elementId, data) {
		  var calendarEl = document.getElementById(elementId);
		  var calendar = new FullCalendar.Calendar(calendarEl, {
			  headerToolbar: {
				  left: 'prev,next',
				  center: 'title',
				  right: ''
			  }
		  });
		  calendar.render();

		  const rgbmax = 256
		  var reports = [];
		  for (var date in data) {
			  var strength = rgbmax - Math.min(rgbmax, 16*data[date]);
			  var d = {
				  start: date,
				  end: date,
				  display: 'background',
				  backgroundColor: "#ff" + strength.toString(16).padStart(2, '0') + "ff"
			  }
			  reports.push(d);
		  }
		  calendar.addEventSource(reports);
	  }

	  render() {
		  var summary = '';
		  summary += '<div>';
		  summary += '<div>기본 정보</div>';
		  summary += '<div>ID: ' + this.info.userId + '</div>';
		  summary += '<div>email: ' + this.info.email + '</div>';
		  summary += '<div>name: ' + this.info.name + '</div>';
		  summary += '<div>mobile: ' + this.info.mobile + '</div>';
		  // 신고 당한 횟수 x축, 신고 횟수에 대한 게시물 수 y축
		  summary += '<div>신고 당한 게시물 차트</div>';
		  summary += '<canvas id="boardReports"></canvas>'
		  // fullcalendar 를 판떼기로 heatmap
		  summary += '<div>신고 당한 날짜 차트</div>';
		  summary += '<div id="dateReports"></div>'
		  summary += '</div>';
		  this.el.innerHTML = summary;

		  var bDataXs = [];
		  var bDataYs = [];
		  for (var ind in this.bData) {
			  bDataXs.push(ind);
			  bDataYs.push(this.bData[ind]);
		  }
		  this.renderBarChart('boardReports', bDataXs, bDataYs, '신고 횟수별 게시물 수');

		  this.renderCalendarHeatmap('dateReports', this.dData);
	  }
  }

  async function fnRenderUserProfile(evt) {
	  var profileEl = document.getElementById('user-profile');
	  var profile = new UserProfile(profileEl, userData[evt.currentTarget.getAttribute('value')]);
	  await profile.fetch();
	  profile.processTotal();
	  profile.render();
  }

  var userData = {};

  // const searchUri = {'id': '${contextPath}/admin/searchUsers.do',
  // 					 'contents': '${contextPath}/admin/searchUsersByContents.do',
  // 					 'reports': '${contextPath}/admin/searchUsersByReports.do'}
  const treatUri = {'btn-delete': '${contextPath}/admin/deleteUsers.do',
					'btn-recover': '${contextPath}/admin/recoverUsers.do'}

  const fnSearchUsers = () => {
	  $.ajax({
		  method: 'POST',
		  url: '${contextPath}/admin/searchUsers.do', //searchUri[$('#search-type')[0].value],
		  data: {searchContents: $('#search-contents').val()},
		  dataType: 'json',
		  success: (data) => {
			  let target = $('#search-result');
			  let resultBody = target.find('#tbody-user-list');
			  resultBody.empty();
			  let results = '';
			  for (var ind = 0; ind < data.length; ind++) {
				  d = data[ind];
				  userData[ind+1] = d;
				  results += '<tr class="userField" value="' + d.userNo + '">';
				  results += '<td><input type="checkbox" name="userNos" value="'+ d.userNo +'"></td>';
				  results += '<td>' + d.userId + '</td>';
				  results += '<td>' + d.name + '</td>';
				  results += '<td>' + d.email + '</td>';
				  results += '<td>' + moment(d.signupDt).format('YYYY-MM-DD') + '</td>';
				  results += '<td>' + moment(d.deletedDt).format('YYYY-MM-DD') + '</td>';
				  results += '</tr>';
			  }
			  if (data.length === 0)
				  results = '<td>일치하는 유저 없음.</td>';
			  resultBody.append(results);
		  },
		  error: (jqXHR) => {
			  alert('error: ' + jqXHR.status + ', ' + jqXHR.statusText);
		  }
	  })
  }

  const fnAddEvtLsnr = () => {
	  // var userEls = document.getElementsByClassName('userField');
	  var userEls = $('.userField');
	  for (var ind = 0; ind < userEls.length; ind++) {
		  userEls[ind].addEventListener('click', fnRenderUserProfile);
	  }
  }

  const fnTreatUsers = (evt) => {
	  nodes = document.querySelectorAll('input[name=userNos]:checked');
	  var values = [];
	  for (var ind = 0; ind < nodes.length; ind++)
		  values.push(nodes[ind].value);
	  values = String(values);
	  $.ajax({
		  method: 'POST',
		  url: treatUri[evt.currentTarget.id],
		  data: "userNos=" + values,
		  dataType: 'json',
		  success: (data) => {
			  console.log(data);
		  },
		  error: (jqXHR) => {
			  alert('error: ' + jqXHR.status + ', ' + jqXHR.statusText);
		  }
	  })
	  fnSearchUsers();
  }

  const searchbtn = document.getElementById('btn-search');
  searchbtn.addEventListener('click', fnSearchUsers);

  const tableEl = document.getElementsByTagName('table')[0];
  tableEl.addEventListener('click', fnAddEvtLsnr)

  const deletebtn = document.getElementById('btn-delete');
  deletebtn.addEventListener('click', fnTreatUsers);

  const recoverbtn = document.getElementById('btn-recover');
  recoverbtn.addEventListener('click', fnTreatUsers);

</script>

<%@ include file="../layout/footer.jsp" %>
