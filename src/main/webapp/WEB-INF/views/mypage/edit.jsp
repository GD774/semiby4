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
  
  <style>
  .btn-danger {
  margin-top: 10px;
  }
  </style>

  <title>마이페이지</title>
</head>
<body>

<div class="container mt-5">
  <h2 class="mb-4">회원정보 수정</h2>
  <form method="POST" action="${contextPath}/mypage/edit.do" id="frm-signup" class="needs-validation" novalidate>

    <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">

    <div class="mb-3">
      <label for="inp-email" class="form-label">아이디</label>
      <input type="text" class="form-control" id="inp-email" name="userId" placeholder="${sessionScope.user.userId}">
    </div>

    <div class="mb-3">
      <label for="inp-pw" class="form-label">비밀번호</label>
      <input type="password" class="form-control" id="inp-pw" name="pw" required>
      <div class="invalid-feedback">
        비밀번호를 입력해 주세요.
      </div>
    </div>

    <div class="mb-3">
      <label for="inp-pw2" class="form-label">비밀번호 확인</label>
      <input type="password" class="form-control" id="inp-pw2" required>
      <div class="invalid-feedback">
        비밀번호 확인을 입력해 주세요.
      </div>
    </div>

    <div class="mb-3">
      <label for="inp-name" class="form-label">이름</label>
      <input type="text" class="form-control" name="name" id="inp-name" required>
      <div class="invalid-feedback">
        이름을 입력해 주세요.
      </div>
    </div>

    <div class="mb-3">
      <label for="inp-mobile" class="form-label">휴대전화번호</label>
      <input type="text" class="form-control" name="mobile" id="inp-mobile" required>
      <div class="invalid-feedback">
        휴대전화번호를 입력해 주세요.
      </div>
    </div>

    <fieldset class="mb-4">
      <legend class="col-form-label">성별</legend>
      <div class="form-check">
        <input class="form-check-input" type="radio" name="gender" id="rdo-none" value="none" checked>
        <label class="form-check-label" for="rdo-none">선택안함</label>
      </div>
      <div class="form-check">
        <input class="form-check-input" type="radio" name="gender" id="rdo-man" value="man">
        <label class="form-check-label" for="rdo-man">남자</label>
      </div>
      <div class="form-check">
        <input class="form-check-input" type="radio" name="gender" id="rdo-woman" value="woman">
        <label class="form-check-label" for="rdo-woman">여자</label>
      </div>
    </fieldset>

    <button type="submit" class="btn btn-primary">수정 완료</button>
    
    <div class="mb-3">
      <a href="${contextPath}/user/leave.do">
      <button type="button" class="btn btn-danger">회원탈퇴</button>
      </a>
    </div>
  </form>
</div>

<script src="${contextPath}/resources/js/edit.js?dt=${dt}"></script>

<jsp:include page="../layout/footer.jsp"/>