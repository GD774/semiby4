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
</style>


<h1 class="title">게시판 목록</h1>

<a href="${contextPath}/board/write.page">게시물 작성</a>

<div>
  <div>
    <input type="radio" name="sort" value="DESC" id="descending" checked>
    <label for="descending">내림차순</label>
    <input type="radio" name="sort" value="ASC" id="ascending">
    <label for="ascending">오름차순</label>
    <input type="radio" name="sort" value="VIEW_COUNT_DESC" id="viewDescending">
  <label for="viewDescending">조회수순</label>
</div>
  </div>
  <div>
    <select id="display" name="display">
      <option>20</option>
      <option>30</option>
      <option>40</option>
    </select>
  </div>
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
  
const fnDisplay = () => {
  document.getElementById('display').value = '${display}';
  document.getElementById('display').addEventListener('change', (evt) => {
    location.href = '${contextPath}/board/list.do?page=1&sort=${sort}&display=' + evt.target.value;
  })
}

const fnSort = () => {
    $(':radio[value=${sort}]').prop('checked', true);
    $(':radio').on('click', (evt) => {
      let sortValue = evt.target.value;
      let displayValue = document.getElementById('display').value;
      let url = '${contextPath}/board/list.do?page=1&sort=' + sortValue + '&display=' + displayValue;
      location.href = url;
    });
};

const fnUpdateHit = () => {
	  
	  $(document).on('click', '.board', (evt) => {

	    if('${sessionScope.user.userNo}' ===  evt.target.dataset.userNo) {
	      location.href = '${contextPath}/board/detail.do?boardNo=' + evt.target.dataset.boardNo;
	    } else {
	      location.href = '${contextPath}/board/updateHit.do?boardNo=' + evt.target.dataset.boardNo;
	    }
	  })
}




fnDisplay();
fnSort();
fnUpdateHit();

</script>

<%@ include file="../layout/footer.jsp" %>
