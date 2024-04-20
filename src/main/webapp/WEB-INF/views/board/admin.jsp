<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>

<style>
  .search-container {
    float: left;
    text-align: center;
  }
  .search-container div {
    display:inline-block;
  }
  .search-list {
    float: left;
  }
</style>

<h1 class="title">관리자 메인</h1>
 
<form class="search-form" id="searchForm">
  <div class="search-container">
    
    <div>
    <label class="user-label">
       <input autofocus id="searchList" maxlength="100" id="email" placeholder="유저아이디를 입력하세요." type="text">
    </label>
    </div>
    <div class="search-button">유저 검색</div>
 
 </div>
 <div class="search-list">
    <div class="member-list">
    <table class="admin_board_wrap" id="user-admin">
      <thead class="admin_boardList">
        <tr>
          <td>이름</td>      
          <td>이메일</td>      
          <td>가입일</td>      
          <td>게시글수</td>      
          <td>댓글수</td>      
          <td>[]</td>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="vo" items="${UserDto}">    <!-- mapper의 resultMap값을 items에 넣음 -->
          <tr class="admin_board_content">
            <td><a class="mypage user_id" value="${vo.email}">${vo.email}</a></td>
            <td>${vo.name}</td>
            <td>${vo.signupDt}</td>
            <td><a href="#" class="boardList_admin" data-user-email="${vo.email}">${vo.boardCnt}</a></td>
            <td><a href="#" class="comment_admin" data-user-email="${vo.email}">${vo.commentCnt}</a></td>
            <td></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
 </div>   
</form>




<script>
  const fnSearchEmail = () => {
    $.ajax({
      type: 'GET',
      url: '${contextPath}/users',
      data: 'json',
      success: (resData) => {
        totalEmail = resData.totalEmail;
       // $.each(resData.emailList, (i, email) => {
         // let str = '<div class="adminPage" data-user-no="' + admin.user.userNo + '" data-email="' + user.email + '">';
         // str += '<span>' + admin.user.email + '</span>';
          //str += '<span>' + moment(blog.createDt).format('YYYY.MM.DD.') + '</span>';
         // str += '</div>';
         // $('#eamil-list').append(str);
        console.log(totalEmail);
       });
    
  }
  
  
  

  
</script>

<%@ include file="../layout/footer.jsp" %>