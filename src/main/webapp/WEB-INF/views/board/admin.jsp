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
</style>

<h1 class="title">관리자 메인</h1>
 
<form class="search-form" id="searchForm">
  <div class="search-container">
    
    <div>
    <label class="user-label">
       <input autofocus id="searchList" maxlength="100" id="email" placeholder="유저아이디를 입력하세요." type="text">
    </label>
    </div>
    <div class="title">유저 검색</div>
 
 </div>
 <div>
  
    <div class="info">
    <div class="user-container">
      <div class="user-id"></div>
    </div>
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
        $.each(resData.emailList, (i, email) => {
          let str = '<div class="adminPage" data-user-no="' + admin.user.userNo + '" data-email="' + user.email + '">';
          str += '<span>' + admin.user.email + '</span>';
          str += '<span>' + moment(blog.createDt).format('YYYY.MM.DD.') + '</span>';
          str += '</div>';
          $('#eamil-list').append(str);
        })
      },
      error: (jqXHR) => {
        alert(jqXHR.statusText + '(' + jqXHR.status + ')'); 
      }
    });
    
  }
  
  
  

  
</script>

<%@ include file="../layout/footer.jsp" %>