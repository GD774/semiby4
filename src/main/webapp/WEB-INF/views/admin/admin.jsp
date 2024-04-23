<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
 <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<jsp:include page="../layout/header.jsp"/>

<style>
  .search-form {
    float: left;
  }
</style>

<h1 class="title">관리자 메인</h1>
 
<form class="search-form" id="searchForm">
  <div>
  <input type="text" id="searchId" placeholder="유저아이디를 입력하세요.">
  <button type="button" id="searchBtn">검색</button>
  <button type="button" id="deleteBtn">삭제</button>
  <table border="1" id="userTable">
    <thead>
        <tr>
            <th>순번</th>
            <th>아이디</th>
            <th>이름</th>
            <th>이메일</th>
            <th>가입날짜</th>
            <th>게시글 수</th>
            <th>댓글 수</th>
        </tr>
    </thead>
    <tbody id="userTableBody">
       <c:forEach items="${userList}" var="user">
      <tr>
          <td>${user.userNo}</td>
          <td id="userLink" class="userLink">${user.userId}</td>
          <td>${user.name}</td>
          <td>${user.email}</td>
          <td>${user.signupDt}</td>
          <td>${user.boardCnt}</td>
          <td>${user.commentCnt}</td>
      </tr>
     </c:forEach>
    </tbody>
</table>
  
  </div>  
            
</form>


<script>
/*
const fngetuserInfo = (userId) => {
    $.ajax({
      type: 'GET',
      url: '${contextPath}/admin/getuserInfo.do?userId=${userId}',
      dataType: 'json',
      success: function(resData) {
        var userDto = resData.data;
        $('#userId').text(userDto.userId);
        console.log('success', resData);
        console.log(1);
      },  error: function() {
        console.log(123);
      }
    }) 
  
}

$('#search').click(function() {
  const userId = $('#searchList').val();
  fngetuserInfo(userId);
})


fngetuserInfo('');
*/

$(document).ready(function() {
  // 페이지 로드 시 사용자 정보를 가져옵니다.
  loadUserInfo();

  // 검색 버튼 클릭 이벤트
  $("#searchBtn").click(function() {
      var searchId = $("#searchId").val();  // 입력된 userId 값 가져오기
      searchUserById(searchId);  // userId 기준으로 검색 함수 호출
  });
  
  // 각 사용자 아이디 클릭 이벤트
  $("#userTableBody").on("click", ".userLink", function() {
      var userId = $(this).data("userid");  // 데이터 속성 값 가져오기
      window.location.href = "mypage.jsp?userId=" + userId;
  });
  
  $("#deleteBtn").click(function() {
    console.log("deleteBtn 클릭 확인");  // 클릭 이벤트 확인 로그
    var userId = $("#searchId").val();  // 입력된 userId 값 가져오기
    dropUserById(userId);  // userId 기준으로 사용자 비활성화 함수 호출
  });
  
});

$(document).ready(function() {
  // 페이지 로드 시 사용자 정보를 가져옵니다.
  loadUserInfo();
});

function loadUserInfo() {
  $.ajax({
      url: "${contextPath}/admin/adminUserList.do",
      type: "GET",
      dataType: "json",
      success: function(data) {
          displayUserInfo(data);
      },
      error: function(error) {
          console.error("이런 문제 생김", error);
      }
  });
}

function searchUserById(userId) {
  $.ajax({
      url: "${contextPath}/admin/getuserInfo.do",
      type: "GET",
      dataType: "json",
      data: {
          userId: userId  // 검색할 userId 전달
      },
      success: function(data) {
          displayUserInfo(data);
      },
      error: function(error) {
          console.error("검색 문제 생김", error);
      }
  });
}

function displayUserInfo(userList) {
  var tableBody = $("#userTableBody");
  tableBody.empty();  // 기존 테이블 내용 삭제

  $.each(userList, function(index, user) {
      var row = $("<tr>");
      row.append($("<td>").text(user.userNo));
      row.append($("<td>").text(user.userId));
      row.append($("<td>").text(user.name));
      row.append($("<td>").text(user.email));
      
      var date = new Date(user.signupDt);
      var formattedDate = date.getFullYear().toString().substr(-2) + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + ("0" + date.getDate()).slice(-2);
      row.append($("<td>").text(formattedDate));
      
      //row.append($("<td>").text(user.signupDt));  // signupDt가 TimeStamp형식으로 나와 위와 같이 날짜 작업 함.
      row.append($("<td>").text(user.boardCnt));
      row.append($("<td>").text(user.commentCnt));

      tableBody.append(row);
  });
}

function dropUserById(userId) {
  console.log("dropUserById 함수 호출 확인: " + userId); 
  $.ajax({
      url: "${contextPath}/admin/" + userId,
      type: "DELETE",
      dataType: "json",
      success: function(response) {
        console.log("성공");
        if (response.success) {
              alert(response.message);
              loadUserInfo();  // 사용자 정보 다시 로드
          } else {
              alert(response.message);
          }
      },
      error: function(error) {
          console.error("사용자 비활성 문제 생김", error);
      }
  });
}

</script>

<%@ include file="../layout/footer.jsp" %>