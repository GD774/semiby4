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
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- 페이지마다 다른 제목 -->
<title>
  <c:choose>
    <c:when test="${empty param.title}">Welcome</c:when>
    <c:otherwise>${param.title}</c:otherwise>
  </c:choose>
</title>

<!-- include libraries(jquery, bootstrap) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

<!-- include moment.js -->
<script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>

<!-- include summernote css/js -->
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote.min.css">
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote.min.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>

<!-- include custom css/js -->
<link rel="stylesheet" href="${contextPath}/resources/css/init.css?dt=${dt}">
<link rel="stylesheet" href="${contextPath}/resources/css/header.css?dt=${dt}">



</head>
<body>

  <div class="header-wrap">
  
    <div class="logo"></div>

<nav class="navbar navbar-expand-lg bg-body-tertiary">
  <div class="container-fluid">
    <a class="navbar-brand" href="${contextPath}/board/multilist.do">
    <img id="logo" src="${contextPath}/resources/images/logo.png">
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="${contextPath}/board/list.do">전체게시판</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${contextPath}/board/multilist.do">멀티게시판</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${contextPath}/board/detaillist.do?cateNo=1">취업정보</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${contextPath}/board/detaillist.do?cateNo=2">면접후기</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${contextPath}/board/detaillist.do?cateNo=3">이야기</a>
        </li>
      </ul>
      <ul id="sign">
        <c:if test="${sessionScope.user == null}">
          <div class="nav-item individual-link">
            <a id="sign-in" href="${contextPath}/user/signin.page"><i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In</a>
          </div>
          <div class="nav-item individual-link">
            <a id="sign-up" href="${contextPath}/user/signup.page"><i class="fa-solid fa-user-plus"></i> Sign Up</a>
          </div>
        </c:if></li>
        <c:if test="${sessionScope.user != null}">
          <div class="nav-item individual-link" id="mypage">
			<c:if test="${sessionScope.user.role == 0}">
              <a href="${contextPath}/mypage"><i class="fa-solid fa-user"></i> 마이페이지</a>
			  <a href="${contextPath}/calendar"><i class="fa-regular fa-calendar"></i> 일정관리</a>
			</c:if>
			<c:if test="${sessionScope.user.role == 1}">
              <a href="${contextPath}/admin"><i class="fa-solid fa-user"></i>빅브라더</a>
			</c:if>
          </div>
          <div class="nav-item individual-link">
            <a href="${contextPath}/user/signout.do"><i class="fa-solid fa-sign-out-alt"></i> 로그아웃</a>
          </div>
        </c:if>
      </ul>
    </div>
  </div>
</nav>

  <div class="main-wrap">
