<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">

  <!-- include libraries(jquery, bootstrap) -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

  <!-- include moment.js -->
  <script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>

  <title>마이페이지</title>

</head>
<body>

  <div id="main-wrap">
	<h2>나의 정보</h2>
	<div id="my-info">
	</div>
	<h2>나의 게시물 목록</h2>
	<div id="my-boards">
	  {boardList}
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
				str = '<div> ID: ' + resData.userId + '</div>';
				str += '<div> email: ' + resData.email + '</div>';
				str += '<div> name: ' + resData.name + '</div>';
				str += '<div> gender: ' + resData.gender + '</div>';
				str += '<div> mobile: ' + resData.mobile + '</div>';
				str += '<a href="${contextPath}/mypage/edit">정보수정</a>';
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
					str = '<div>' + board.boardNo + ': ';
					str += '<span><a href=' + '${contextPath}/board/detail.do?boardNo=' + board.boardNo + '>' + board.title + '</a></span>' + '</div>';
					myBoards.append(str);
				})
			},
			error: (jqXHR) => {
				alert(jqXHR.statusText + '(' + jqXHR.status + ')');
			}
		})
	}

	fnMyInfo();
	fnMyBoards();

  </script>

</body>
</html>
