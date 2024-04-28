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

<form method="POST"
      action="${contextPath}/mypage/edit.do"
      id="frm-signup">

  <!-- 당연히 나중에 반드시 정상적으로 세션으로 userNo 를 받도록 수정해야 함 -->
  <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">

  <div>
    <label for="inp-email">아이디</label>
    <input type="text" id="inp-email" name="userId" placeholder="${sessionScope.user.userId}">
  </div>

  <hr>

  <div>
    <label for="inp-pw">비밀번호</label>
    <input type="password" id="inp-pw" name="pw">
  </div>
  <div>
    <label for="inp-pw2">비밀번호 확인</label>
    <input type="password" id="inp-pw2">
  </div>
  
  <hr>
  
  <div>
    <label for="inp-name">이름</label>
    <input type="text" name="name" id="inp-name">
  </div>

  <div>
    <label for="inp-mobile">휴대전화번호</label>
    <input type="text" name="mobile" id="inp-mobile">
  </div>

  <div>
    <label>성별</label>
      <input type="radio" name="gender" value="none" id="rdo-none" checked>
      <label for="rdo-none">선택안함</label>
    <div>
      <input type="radio" name="gender" value="man" id="rdo-man">
      <label for="rdo-man">남자</label>
    </div>
    <div>
      <input type="radio" name="gender" value="woman" id="rdo-woman">
      <label for="rdo-woman">여자</label>
    </div>
  </div>

  <hr>

  <div><a href="${contextPath}/user/leave.do">회원탈퇴</a></div>
  
  <div>
    <button type="submit" id="btn-signup">수정 완료</button>
  </div>
  
</form>

<script src="${contextPath}/resources/js/edit.js?dt=${dt}"></script>

</body>
</html>
