<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="./layout/header.jsp"/>

<h1>PROJECT SEMIBY4</h1>

<div>
  <form method="GET"
        action="${contextPath}/board/search.do">
    <div>
      <select name="column">
        <option value="U.USER_ID">작성자</option>
        <option value="B.CONTENTS">내용</option>
      </select>
      <input type="text" name="query" placeholder="검색어 입력">
      <button type="submit">검색</button>
    </div>
  </form>
</div>


<h3>테스트 가능한 사용자 리스트</h3>
<h5>id: admin, pw: admin</h5>
<h5>id: tester1, pw: 1111</h5>
<h5>id: tester2, pw: 2222</h5>
<h5>id: tester3, pw: 3333</h5>
<h5>id: tester4, pw: 4444</h5>
<h5>id: tester5, pw: 5555</h5>
<h5>id: tester6, pw: 6666</h5>


  
<%@ include file="./layout/footer.jsp" %>
