<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>

<style>
  .blind {
    display: none;
    
  }
</style>

<h1 class="title">관리자 페이지</h1>

<div>
  <form id="searchform">
    <div>
      <select name="column">
        <option value="U.EMAIL" id="email">작성자</option>
         <!-- <option value="B.CONTENTS">내용</option> -->
      </select>
      <input type="text" name="query" placeholder="검색어 입력">
      <button type="button" class="search-user">검색</button>
    </div>
  </form>
</div>

<table border="1">
  <thead>
    <tr>
      <td>순번&nbsp;&nbsp;</td>
      <td>작성자&nbsp;&nbsp;</td>
      <td>작성일자</td>
    </tr>
  </thead>
  <tbody>
    <c:forEach items="${boardList}" var="board" varStatus="vs">
      <tr class="board">
        <td>${beginNo - vs.index}</td>
        <c:if test="${board.state == 1}">
        <td>${board.user.email}</td>
        <td>
          <c:forEach begin="1" end="${board.depth}" step="1">&nbsp;&nbsp;</c:forEach>
            <c:if test="${board.user.userNo == sessionScope.user.userNo}">
              <button type="button" class="btn-remove">삭제</button>
              <input type="checkbox" value="${board.boardNo}">
          </c:if>
        </td>
        <td>
          <fmt:formatDate value="${board.createDt}" pattern="yyyy. MM. dd. HH:mm:ss"/>
        </td>
        </c:if>
        <c:if test="${board.state == 0}">
          <td colspan="3">삭제된 게시글입니다.</td>
        </c:if>
      </tr>
   
    </c:forEach>
  </tbody>
</table>

<div>${paging}</div>

<script>

  const fnBtnRemove = () => {
    $('.btn-remove').on('click', (evt) => {
      if(confirm('게시글을 삭제할까요?')) {
        location.href = '${contextPath}/board/removeBoard.do?boardNo=' + $(evt.target).next().val();
      }
    })
  }

  
  const fnSearchUser = () => {
    $('.search-user').on('click', (evt) => {
      const email = document.getElementById('email').val();
      const xhr = new XHLHttpRequest();
      xhr.open('GET', '${contextPath}/board/search.do?column=' + column + '&query=' + query, true);
      xhr.onreadystatechange = () => {
        if (xhr.readyState === 4 && xhr.status === 200) {
          //검색 페이지
        }
       };
       xhr.send();
    } else {
      alert('유저를 제대로 입력하세요');
    }
    });
  }

  fnBtnRemove();
  $('.contents').on('click', fnCheckSignin);
  fnSearchUser();
  
</script>

<%@ include file="../layout/footer.jsp" %>