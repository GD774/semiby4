<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
 <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<jsp:include page="../layout/header.jsp"/>

<style>
  .searchForm1 {
    float: left;
  }
  .selected {
  background-color: #e0e0e0;  // 선택된 행의 배경색
  }
</style>

<h1 class="title">BIG BROTHER IS WATCHING YOU</h1>

<form class="searchForm1" id="search-form1">
  <div>
  <input type="text" id="search-id1" placeholder="유저아이디를 입력하세요.">
  <button type="button" id="search-btn">검색</button>
  <button type="button" id="deleteBtn1">삭제</button>
  <table border="1" id="userTable1">
    <thead>
        <tr>
            <th>순번</th>
            <th>아이디</th>
            <th>이름</th>
            <th>이메일</th>
            <th>가입날짜</th>
        </tr>
    </thead>
    <tbody id="userTableBody1">
       <c:forEach items="${userList}" var="user">
      <tr>
          <td>${user.userNo}</td>
          <td class="userLink1">${user.userId}</td>
          <td>${user.name}</td>
          <td>${user.email}</td>
          <td>${user.signupDt}</td>
          <td>${user.boardCnt}</td>
      </tr>
     </c:forEach>
    </tbody>
</table>

  </div>

</form>
<form class="search-form2" id="searchForm2">
  <div>
  <input type="text" id="search-id2" placeholder="유저아이디를 입력하세요.">
  <button type="button" id="search-btn2">검색</button>
  <table border="1" id="userTable2">
    <thead>
        <tr>
            <th>순번</th>
            <th>아이디</th>
            <th>이름</th>
            <th>이메일</th>
            <th>가입날짜</th>
        </tr>
    </thead>
    <tbody id="userTableBody2">
       <c:forEach items="${userList}" var="user">
      <tr>
          <td>${user.userNo}</td>
          <td class="userLink2">${user.userId}</td>
          <td>${user.name}</td>
          <td>${user.email}</td>
          <td>${user.signupDt}</td>
          <td>${user.boardCnt}</td>
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
  var selectedRow = null;
  // 페이지 로드 시 사용자 정보를 가져옵니다.
  loadUserInfo();

  // 검색 버튼 클릭 이벤트
  $("#search-btn").click(function() {
      var searchId = $("#searchId1").val();  // 입력된 userId 값 가져오기
      searchUserById(searchId);  // userId 기준으로 검색 함수 호출
  });
  
  // 각 사용자 아이디 클릭 이벤트
  /*
  $("#userTableBody").on("click", ".userLink", function() {
      var userId = $(this).data("userid");  // 데이터 속성 값 가져오기
      window.location.href = "mypage.jsp?userId=" + userId;
  });
  */
  
  //각 사용자 아이디 클릭 이벤트
  $("#userTableBody1").on("click", "tr", function() {
    // 이전에 선택된 행의 스타일을 제거
    if (selectedRow) {
      selectedRow.removeClass("selected");
    }
    // 선택한 행의 스타일을 변경하고 선택된 행을 저장
    $(this).addClass("selected");
    selectedRow = $(this);
    /*
    수정 전 테이블 클릭 시, 바로 삭제 확인.
    var userId = $(this).find("td:eq(1)").text();  // 클릭된 td의 텍스트(아이디) 가져오기
    dropUserById(userId);  // userId 기준으로 사용자 삭제 함수 호출
    */
  });
  
  $("#deleteBtn1").click(function() {
    if (selectedRow) {
      var userId = selectedRow.find("td:eq(1)").text();  // 선택된 행에서 아이디 가져오기
      dropUserById(userId);
      //var userId = $("#searchId").val();  // 입력된 userId 값 가져오기
      // 선택 상태 해제
      selectedRow.removeClass("selected");
      selectedRow = null;
    } else {
      alert("삭제할 사용자를 선택해주세요.");
    }
  });
});



function loadUserInfo() {
  $.ajax({
      url: "${contextPath}/admin/adminUserList.do",
      type: "GET",
      dataType: "json",
      success: function(data) {
          users = parseUser(data);
          displayUserInfo(users[0], "#userTableBody1");
          displayUserInfo(users[1], "#userTableBody2");
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
        console.log('what is search data' + data.length);
          users = parseUser(data);
          displayUserInfo(users[0], "#userTableBody1");
          displayUserInfo(users[1], "#userTableBody2");
      },
      error: function(error) {
          console.error("검색 문제 생김", error);
      }
  });
}

function parseUser(data) {
  var active = [];
  var banned = [];
  for (var i = 0; i < data.length; i++) {
    user = data[i];
    if (! user.deletedDt) {
      active.push(user)
    } else {
      banned.push(user)
    }
  }
  return [active, banned];
}

function displayUserInfo(userList, tableBodyTagId) {
  var tableBody = $(tableBodyTagId);
  tableBody.empty();  // 기존 테이블 내용 삭제

  $.each(userList, function(index, user) {
      var row1 = $("<tr>");
      row1.append($("<td>").text(user.userNo));
      row1.append($("<td>").text(user.userId));
      row1.append($("<td>").text(user.name));
      row1.append($("<td>").text(user.email));
      
      var date1 = new Date(user.signupDt);
      var formattedDate1 = date1.getFullYear().toString().substr(-2) + "-" + ("0" + (date1.getMonth() + 1)).slice(-2) + "-" + ("0" + date1.getDate()).slice(-2);
      row1.append($("<td>").text(formattedDate1));
      
      //row.append($("<td>").text(user.signupDt));  // signupDt가 TimeStamp형식으로 나와 위와 같이 날짜 작업 함.
      row1.append($("<td>").text(user.boardCnt));
      row1.append($("<td>").text(user.commentCnt));
      
      tableBody.append(row1);
  });
}

/*
// userId 비활성화 
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
*/

function dropUserById(userId) {
  // 사용자에게 삭제 여부를 확인하는 메시지 표시
  if (confirm("사용자를 삭제하시겠습니까?")) {
    console.log("dropUserById 함수 호출 확인:" + userId);
    $.ajax({
       url: "${contextPath}/admin/dropId",
       data: {
         userId: userId,
       },
       // dataType: "json",
       type: "POST",
       success: function(resData) {
         console.log("성공");
         loadUserInfo();
       },
       error: function(errmsg) {
         console.log("실패" + errmsg + ", " + errmsg.status + ", " + errmsg.statusText);
       }
    }); 
  } else {
    console.log("사용자 삭제 취소");
  }
}

const fnMypage = () => {
  $(document).on('click', '.userLink1', (evt) => {
      location.href = '${contextPath}/mypage/mypage.page';
  })
}

</script>

<%@ include file="../layout/footer.jsp" %>
