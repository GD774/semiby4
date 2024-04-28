<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>
<link rel="stylesheet" href="${contextPath}/resources/css/board/multilist.css?dt=${dt}">

<style>
.contents {
    width: 500px;
  }
  
  #bold:hover {
    cursor: pointer;
    font-weight: bold;
  }
    
 #main-wrap1 {
  width: 1200px;
  height: 1000px;
  display: flex; 
  flex-direction: row; 
  flex-wrap: wrap;
  justify-content: center; 
  align-content: flex-start;
  margin-bottom: -50px;  
}  

.chid-wrap {
  width: 500px; 
  height: 350px; 
  padding: 20px;
  box-sizing: border-box;
  margin: 10px;
  }
  
  table{
  border: none;
  }
  
  thead {
  font-size: 12px;
  color: #666666;
  }
  
  td {
 max-width: 250px;
 overflow: hidden;
 text-overflow: ellipsis;
 white-space: nowrap;
  } 
  
  </style>

<div id="main-wrap1" class="main-wrap">

<div id="first" class="chid-wrap">
  <table class="table align-middle">
    <thead>
    <tr>
    <td colspan="2"><h2>취업정보</h2></td>
    <td colspan="2" class="plusicon"><a href="${contextPath}/board/detaillist.do?cateNo=1"><i class="fa-solid fa-plus"></i> 더보기</a></td>
    </tr>
      <tr>
        <td max-width="250px;">제목</td>
        <td max-width="100px;">작성자</td>
        <td max-width="40px;">조회</td>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${boardMultiList1}" var="board" varStatus="vs">
        <tr>
          <td class="contents">
            <a id="bold" href="${contextPath}/board/updateHit.do?boardNo=${board.boardNo}">${board.title}</a>
          </td>
          <td>${board.user.userId}</td>
          <td>${board.hit}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

      <!-- 아무것도 안나오는 공간이 맞습니다. 4개의 게시판을 화면에 구성하기 위해 만들어놓은 공간(실시간 best 게시글등. 추후 위치는 얼마든지 변경될 수 있습니다.) -->
<div id="four" class="chid-wrap">
  <table class="table align-middle">
    <thead>
    <tr>
    <td colspan="2"><h2>BEST 5</h2></td>
    <td colspan="2">
    </tr>
      <tr>
        <td max-width="250px;">제목</td>
        <td max-width="100px;">작성자</td>
        <td max-width="40px;" >조회</td>
      </tr>
    </thead>
	<tbody>
      <c:forEach items="${bestHitList}" var="board" varStatus="vs">
        <tr>
          <td class="board" data-board-no="${board.boardNo}">
            <a id="bold" href="${contextPath}/board/updateHit.do?boardNo=${board.boardNo}">${board.title}</a>
          </td>
          <td>${board.user.userId}</td>
          <td>${board.hit}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>


<div id="second" class="chid-wrap">
  <table class="table align-middle">
    <thead>
    <tr>
    <td colspan="2"><h2>면접 후기</h2></td>
    <td colspan="2" class="plusicon"><a href="${contextPath}/board/detaillist.do?cateNo=2"><i class="fa-solid fa-plus"></i> 더보기</a></td>
    </tr>
      <tr>
        <td max-width="250px;">제목</td>
        <td max-width="100px;">작성자</td>
        <td max-width="40px;">조회</td>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${boardMultiList2}" var="board" varStatus="vs">
        <tr>
          <td class="contents">
            <a id="bold" href="${contextPath}/board/updateHit.do?boardNo=${board.boardNo}">${board.title}</a>
          </td>
          <td>${board.user.userId}</td>
          <td>${board.hit}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<div id="third" class="chid-wrap">  
  <table class="table align-middle">
    <thead>
    <tr>
    <td colspan="2"><h2>이야기 나눠요</h2></td>
    <td colspan="2" class="plusicon"><a href="${contextPath}/board/detaillist.do?cateNo=3"><i class="fa-solid fa-plus"></i> 더보기</a></td>
    </tr>
       <tr>
        <td max-width="250px;">제목</td>
        <td max-width="100px;">작성자</td>
        <td max-width="40px;">조회</td>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${boardMultiList3}" var="board" varStatus="vs">
        <tr>
          <td class="contents">
            <a id="bold" href="${contextPath}/board/updateHit.do?boardNo=${board.boardNo}">${board.title}</a>
          </td>
          <td>${board.user.userId}</td>
          <td>${board.hit}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>


</div>




<script>

var email = "${user.email}";

  

</script>

<%@ include file="../layout/footer.jsp" %>