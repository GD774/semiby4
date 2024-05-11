<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>

  <!-- include libraries(jquery, bootstrap) -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
  

  <!-- include moment.js -->
  <script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>

  <title>마이페이지</title>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>
  
  <style>
	#my-info {
	  background-color: #f8f9fa; /* 배경색 변경 */
	  border: 1px solid #dee2e6; /* 테두리 변경 */
	  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
	}
</style>
  
</head>
<body>

<div class="container mt-5">
  <div class="row">
    <!-- "나의 정보" 섹션을 더 넓게 조정 -->
    <div class="col-md-5">
      <h2>나의 정보</h2>
      <div id="my-info" class="p-3 border bg-light">
        <!-- User info will be loaded here -->
      </div>
      <div class="mt-3">
        <a href="${contextPath}/mypage/edit" class="btn btn-primary">정보수정</a>
      </div>
    </div>

    <!-- "나의 게시물 목록" 섹션의 너비를 조정 -->
    <div class="col-md-6">
      <h2>나의 게시물 목록</h2>
      <div id="my-boards" class="list-group">
        <!-- Boards will be loaded here -->
      </div>
    </div>
  </div>
</div>

<script>
  const fnMyInfo = () => {
    $.ajax({
      type: 'get',
      url: '${contextPath}/mypage/myinfo.do',
      data: 'userNo=${sessionScope.user.userNo}',
      dataType: 'json',
      success: (resData) => {
        let myInfo = $('#my-info');
        myInfo.empty();
        let str = '<div class="mb-2"><strong>ID: </strong> ' + resData.userId + '</div>';
        str += '<div class="mb-2"><strong>이메일: </strong> ' + resData.email + '</div>';
        str += '<div class="mb-2"><strong>이름: </strong> ' + resData.name + '</div>';
        str += '<div class="mb-2"><strong>성별: </strong> ' + resData.gender + '</div>';
        str += '<div class="mb-2"><strong>휴대전화번호: </strong> ' + resData.mobile + '</div>';
        myInfo.append(str);
      },
      error: (jqXHR) => {
        alert(jqXHR.statusText + '(' + jqXHR.status + ')');
      }
    })
  }

  const fnMyBoards = () => {
    $.ajax({
      type: 'get',
      url: '${contextPath}/mypage/myboards.do',
      data: 'userNo=${sessionScope.user.userNo}',
      dataType: 'json',
      success: (resData) => {
        let myBoards = $('#my-boards');
        myBoards.empty();
        $.each(resData, (i, board) => {
          let str = '<a href="${contextPath}/board/detail.do?boardNo=' + board.boardNo + '" class="list-group-item list-group-item-action">';
          str += '&nbsp;&nbsp;' + board.title;
          str += '</a>';
          myBoards.append(str);
        });
      },
      error: (jqXHR) => {
        alert(jqXHR.statusText + '(' + jqXHR.status + ')');
      }
    })
  }

  $(document).ready(() => {
    fnMyInfo();
    fnMyBoards();
  });
</script>

<jsp:include page="../layout/footer.jsp"/>
