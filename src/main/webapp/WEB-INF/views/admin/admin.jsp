<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
 <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<jsp:include page="../layout/header.jsp"/>

<style>

</style>

<h1 class="title">관리자 메인</h1>
 
<form class="search-form" id="searchForm">
  <div>
    <input autofocus id="searchList" maxlength="100" id="email" placeholder="유저아이디를 입력하세요." type="text">
    <button type="button" id="search" >검색</button>
  </div>
  <div>
    <table border="1">
      <thead>
        <tr>
          <td>아이디</td>
          <td>이메일</td>
          <td>이름</td>
          <td>가입일</td>
          <td>게시글수</td>
          <td>댓글수</td>
        </tr>
      </thead>
      <tbody>
         <tr>
          <td>아이디</td>
          <td>이메일</td>
          <td>이름</td>
          <td>가입일</td>
          <td>게시글수</td>
          <td>댓글수</td>
        </tr>
      </tbody>
    </table>
  </div>
</form>




<script>

$('#search').on('click', function(evt) {
  $.ajax({
    type: 'GET',
    url: '${contextPath}/admin/getuserInfo.do', 
    success: function(resData) {
      console.log('success', resData);   
    }
  }) 
})


  


  
</script>

<%@ include file="../layout/footer.jsp" %>