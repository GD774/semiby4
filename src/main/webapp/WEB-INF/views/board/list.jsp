<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>

<style>
  .board {
    width: 500px;
  }
  
  #bold:hover {
    cursor: pointer;
    font-weight: bold;
  }

  .title {
    text-align:center;  
  }
  
  #write {
    float: right;
  }

</style>


<h1 class="title">게시판 목록</h1>

<a href="${contextPath}/board/write.page" id="write" class="btn btn-secondary">게시물 작성</a>

<div>
  <form method="GET"
        action="${contextPath}/board/search.do">
    <div display:inline-block;>
      <select name="column">
        <option value="U.USER_NO">작성자</option>
        <option value="B.TITLE">제목</option>
        <option value="B.CONTENTS">내용</option>
      </select>
       <!-- <img src="${contextPath}/resources/images/searchicon.png" width="20"> -->
        <input type="text" name="query" placeholder="검색어 입력">
        <input type="hidden" name="sort" value="${sort}">
        <button type="submit" id="search">검색</button>      
    </div>
  </form>
</div>


<div>
    <!-- <input type="radio" name="sort" value="DESC" id="descending" checked>
    <label for="descending">내림차순</label>
    <input type="radio" name="sort" value="ASC" id="ascending">
    <label for="ascending">오름차순</label>
    <input type="radio" name="sort" value="VIEW_COUNT_DESC" id="viewDescending">
  	<label for="viewDescending">조회수순</label> -->
<select id="sort" name="sort">
    <option value="DESC" ${sort == 'DESC' ? 'selected' : ''}>내림차순</option>
    <option value="ASC" ${sort == 'ASC' ? 'selected' : ''}>오름차순</option>
    <option value="VIEW_COUNT_DESC" ${sort == 'VIEW_COUNT_DESC' ? 'selected' : ''}>조회수순</option>
</select>

</div>
  
  <!-- <div>
    <select id="display" name="display">
      <option>20</option>
      <option>30</option>
      <option>40</option>
    </select>
  </div> -->
  <table class="table align-middle">
    <thead>
      <tr>
        <td>순번</td>
        <td>제목</td>
        <td>작성자</td>
        <td>조회수</td>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${boardList}" var="board" varStatus="vs">
        <tr>
          <td>${beginNo - vs.index}</td>
          <td class="board" data-board-no="${board.boardNo}">
            <a id="bold" href="${contextPath}/board/detail.do?boardNo=${board.boardNo}">${board.title}</a>
          </td>
          <td>${board.user.email}</td>
          <td>${board.hit}</td>
        </tr>
      </c:forEach>
    </tbody>
    <tfoot>
      <tr>
        <td colspan="4">${paging}</td>
      </tr>
    </tfoot>
  </table>
</div>

<script>
  
/* const fnDisplay = () => {
  document.getElementById('display').value = '${display}';
  document.getElementById('display').addEventListener('change', (evt) => {
    location.href = '${contextPath}/board/list.do?page=1&sort=${sort}&display=' + evt.target.value;
  })
} */


const fnSearchSort = () => {
	document.getElementById('search').addEventListener('click', (evt) => {
		const sort = '${sort}'; // 일반적으로 서버에서 템플릿 엔진을 통해 이 변수를 렌더링합니다.
	    $('#sort').val(sort);
	})
}

$(document).ready(function() {
    const sort = '${sort}';
    if (sort && sort !== '') {
        $('#sort').val(sort); // 정렬 값 설정
    } else {
        console.error('Sort parameter is missing or empty.');
    }

    $('#sort').on('change', function() {
        const sortValue = this.value;
        const contextPath = '${contextPath}';
        const url = `${contextPath}/board/list.do?page=1&sort=` + sortValue;
        location.href = url;
    });
});





/* fnDisplay(); */

</script>

<%@ include file="../layout/footer.jsp" %>
