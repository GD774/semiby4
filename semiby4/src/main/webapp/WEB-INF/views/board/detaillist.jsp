<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>
<link rel="stylesheet" href="${contextPath}/resources/css/board/detaillist.css?dt=${dt}">


<c:if test="${param.cateNo eq '1'}">
    <h1 class="title"><img class="boardicon" src="${contextPath}/resources/images/jobinfoicon.png"> 취업정보 게시판 </h1>
</c:if>
<c:if test="${param.cateNo eq '2'}">
    <h1 class="title"><img class="boardicon" src="${contextPath}/resources/images/interviewicon.png"> 면접후기 게시판</h1>
</c:if>
<c:if test="${param.cateNo eq '3'}">
    <h1 class="title"><img class="boardicon" src="${contextPath}/resources/images/communicationicon.png"> 이야기 나눠요</h1>
</c:if>



<a href="${contextPath}/board/write.page" id="write" class="btn btn-secondary">게시물 작성</a>

<!--
<div>
  <c:if test="${sessionScope.user != null}">
  <input type="checkbox" name="deleteUser" value="deleteUser" id="deleteUser">
  </c:if>
</div>
-->
<div>
  <form method="GET"
        action="${contextPath}/board/searchDetail.do">
	<select id="sort" name="sort">
	    <option value="DESC" ${sort == 'DESC' ? 'selected' : ''}>내림차순</option>
	    <option value="ASC" ${sort == 'ASC' ? 'selected' : ''}>오름차순</option>
	    <option value="VIEW_COUNT_DESC" ${sort == 'VIEW_COUNT_DESC' ? 'selected' : ''}>조회수순</option>
	</select>
    <div class="searchspace">
      <select name="column">
        <option value="U.USER_ID">작성자</option>
        <option value="B.TITLE">제목</option>
        <option value="B.CONTENTS">내용</option>
      </select>
        <input type="text" name="query" placeholder="검색어를 입력하세요">
        <input type="hidden" name="hiddensort" value="${sort}" >
        <input type="hidden" name="cateNo" value="${param.cateNo}" >
        <button type="submit" id="search">검색</button>      
    </div>
  </form>
</div>
  
 <div>
  <table class="table align-middle">
    <thead>
      <tr>
        <td>제목</td>
        <td>작성자</td>
        <td>조회수</td>
        <td>작성일자</td>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${boardDetailList}" var="board" varStatus="vs">
        <tr>
          <td class="board" data-board-no="${board.boardNo}">
            <a id="bold" href="${contextPath}/board/updateHit.do?boardNo=${board.boardNo}">${board.title}</a>
          </td>
          <td>${board.user.userId}</td>
          <td>${board.hit}</td>
          <td><fmt:formatDate value="${board.createDt}" pattern="yyyy-MM-dd" /></td>
        </tr>
      </c:forEach>
    </tbody>
    <tfoot>
      <tr>
        <td colspan="5">
          <div class="paging-container">
            ${paging}
          </div>
        </td>
      </tr>
    </tfoot>
  </table>
</div>

<input type="hidden" id="removeResult" value="${removeResult}">

<script>
const fnSearchSort = () => {
	document.getElementById('search').addEventListener('click', (evt) => {
		const sort = '${sort}';
	    $('#sort').val(sort);
	})
}

$('#sort').on('change', function() {
    const sortValue = this.value;
    const cateNo = '${param.cateNo}';  // 카테고리 번호를 JavaScript 변수로 저장
    const contextPath = '${contextPath}';
    const url = `${contextPath}/board/detaillist.do?page=1&sort=` + sortValue + '&cateNo=' + cateNo;
    location.href = url;
});

$(document).ready(function() {
    const sort = '${sort}';
    if (sort && sort !== '') {
        $('#sort').val(sort);
    } else {
        console.error('sort 오류');
    }

});



const fnResponse = () => {
	const removeResult = document.getElementById('removeResult').value;
	if(removeResult === '1') {
	    alert("게시글이 삭제되었습니다");
	}
}

fnResponse();


</script>

<%@ include file="../layout/footer.jsp" %>