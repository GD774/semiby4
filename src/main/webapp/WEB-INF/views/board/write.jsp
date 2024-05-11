<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>
<link rel="stylesheet" href="${contextPath}/resources/css/board/write.css?dt=${dt}">


 <div id="main-wrap">
 <div id="title-div">
 <h1 class="title">글작성</h1>
 <hr>
 </div>

 <form id="frm-board-register"
       method="POST"
       enctype="multipart/form-data"
       action = "${contextPath}/board/register.do">
       
 <div>
  <label for="writer" >작성자</label>
  <input type="text" class="form-control" id="writer" value="${sessionScope.user.email}" readonly>
 </div>
 
  <div id="select-div"> 
  <label for="selectBox">카테고리</label>
  <select name="cateNo" id="select-box" class="form-control">
    <option disabled selected hidden> 카테고리를 선택하세요</option>
    <option value="1">취업정보공유</option>
    <option value="2">면접후기공유</option>
    <option value="3">이야기나눠요</option>
  </select>
 </div>
 
 <div>
  <label for="title">제목</label>
  <input type="text" class="form-control" name="title" id="title" placeholder="제목을 입력하세요">
 </div> 
 
 
 
 <div>
  <textarea id="contents" class="form-control" name="contents" placeholder="내용을 입력하세요"></textarea>
 </div>
 
 <div id="files-wrap">
  <label for="files">첨부</label>
  <input class="form-control" type="file" name="files" id="files" multiple>
 </div>

 <label for="attach-list">첨부파일목록</label>
 <div id="attach-list"></div>

 <div id="buttons">
 <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
 <button type="submit" class="btn btn-light">작성완료</button>
 <a href="${contextPath}/board/list.do"><button type="button" class="btn btn-secondary">작성취소</button></a>
 </div>
 
 </form>
 
</div> 
 
<script>

//제목 필수 입력 스크립트

const fnRegisterBoard = () => {

  document.getElementById('frm-board-register').addEventListener('submit', (evt) => {
    if(document.getElementById('title').value === '') {
      alert('제목은 필수입니다.');
      evt.preventDefault();
      return;
    }
  })
}
 
// 크기 제한 스크립트 + 첨부 목록 출력 스크립트
const fnAttachCheck = () => {
  document.getElementById('files').addEventListener('change', (evt) => {
    const limitPerSize = 1024 * 1024 * 10;
    const limitTotalSize = 1024 * 1024 * 100;
    let totalSize = 0;
    const files = evt.target.files;
    const attachList = document.getElementById('attach-list');
    attachList.innerHTML = '';
    for(let i = 0; i < files.length; i++){
      if(files[i].size > limitPerSize){
        alert('각 첨부 파일의 최대 크기는 10MB입니다.');
        evt.target.value = '';
        attachList.innerHTML = '';
        return;
      }
      totalSize += files[i].size;
      if(totalSize > limitTotalSize){
        alert('전체 첨부 파일의 최대 크기는 100MB입니다.');
        evt.target.value = '';
        attachList.innerHTML = '';
        return;
      }
      attachList.innerHTML += '<input type="text" class="form-control" id="file-list" value="'+ files[i].name + '" >';
    }
  })
}

const fnRegisterCate = () => {

	  document.getElementById('frm-board-register').addEventListener('submit', (evt) => {
		  if (document.getElementById('select-box').selectedIndex === 0) {
	            alert('카테고리를 선택해주세요');
	            evt.preventDefault();
	     }
	  })
	}

fnAttachCheck();
fnRegisterBoard();
fnRegisterCate();
</script>

<%@ include file="../layout/footer.jsp" %>