<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>
<link rel="stylesheet" href="${contextPath}/resources/css/board/edit.css?dt=${dt}">

<div id="detail-wrap">
    <div id="title-div">
        <h1 class="title">게시글 수정하기</h1>
        <hr>
    </div>

    <div id="info-wrap">
        <div class="info-section">
            <span>작성자</span>
            <input type="text" class="form-control" id="writer" name="writer" value="${sessionScope.user.email}" readonly>
        </div>
        <div class="info-section">
            <span>작성일자</span>
            <input type="text" value="<fmt:formatDate value='${board.createDt}' pattern='yyyy-MM-dd HH:mm' />" class="form-control" readonly>
        </div>
        <div class="info-section">
            <span>최종수정일</span>
            <input type="text" value="<fmt:formatDate value='${board.modifyDt}' pattern='yyyy-MM-dd HH:mm' />" class="form-control" readonly>
        </div>
    </div>

    <form id="frm-board-modify" method="POST" enctype="multipart/form-data" action="${contextPath}/board/modify.do">
        <input type="hidden" name="boardNo" value="${board.boardNo}">

        <div>
            <label for="title"></label>
            <input type="text" class="form-control" id="title" name="title" value="${board.title}">
        </div>

		<div id="content-container">
		    <textarea id="contents" class="form-control" name="contents">${board.contents}</textarea>
		    <div id="action-buttons">
		        <button type="submit" class="btn btn-light">수정 완료</button>
		        <button type="button" class="btn btn-secondary" onclick="location.href='${contextPath}/board/list.do'">수정 취소</button>
		    </div>
		</div>

        <c:if test="${sessionScope.user.userNo == board.user.userNo}">
			<div id="files-wrap">
			    <input type="file" name="files" id="files" class="form-control" style="width: 70%; display: inline-block;">
			    <button type="button" id="btn-add-attach" class="btn btn-outline-secondary" style="width: 25%; display: inline-block;">첨부 추가</button>
			</div>
            <div id="new-attach-list"></div>
            <hr>
            <h3>현재 첨부 목록</h3>
            <div id="attach-list"></div>
        </c:if>
    </form>
</div>

<!-- 첨부 추가 -->

<script>

// 첨부 목록 가져와서 <div id="attach-list"></div> 에 표시하기
const fnAttachList = () => {
  fetch('${contextPath}/board/attachList.do?boardNo=${board.boardNo}', {
    method: 'GET'
  })
  .then(response => response.json())
  .then(resData => {  // resData = {"attachList": []}
    let divAttachList = document.getElementById('attach-list');
    divAttachList.innerHTML = '';
    const attachList = resData.attachList;
    for(let i = 0; i < attachList.length; i++) {
      const attach = attachList[i];
      let str = '<div class="attach">';
      if(attach.hasThumbnail === 0) {
        str += '<img src="${contextPath}/resources/images/attach.png" width="96px">';
      } else {
        str += '<img src="${contextPath}' + attach.uploadPath + '/s_' + attach.filesystemName + '">';
      }
      str += '<span>' + attach.originalFilename + '</span>';
      if('${sessionScope.user.userNo}' === '${board.user.userNo}') {
        str += '<a style="margin-left: 10px;" class="remove-attach" data-attach-no="' + attach.attachNo + '">X</a>';
        // <i class="fas fa-trash-alt"></i>
      }
      str += '</div>';
      divAttachList.innerHTML += str;
    }
  })
}

// 첨부 추가
const fnAddAttach = () => {
  $('#btn-add-attach').on('click', () => {
    // 폼을 FormData 객체로 생성한다.
    let formData = new FormData();
    // 첨부된 파일들을 FormData에 추가한다.
    let files = $('#files').prop('files');
    $.each(files, (i, file) => {
      formData.append('files', file);  // 폼에 포함된 파라미터명은 files이다. files는 여러 개의 파일을 가지고 있다.
    })
    // 현재 게시글 번호(boardNo)를 FormData에 추가한다.
    formData.append('boardNo', '${board.boardNo}');
    // FormData 객체를 보내서 저장한다.
    $.ajax({
      // 요청
      type: 'POST',
      url: '${contextPath}/board/addAttach.do',
      data: formData,
      contentType: false,
      processData: false,
      // 응답
      dataType: 'json',
      success: (resData) => {  // resData = {"attachResult": true}
        if(resData.attachResult){
          alert('첨부 파일이 추가되었습니다.');
          fnAttachList();
          document.getElementById('files').value = '';
          document.getElementById('new-attach-list').innerHTML = '';
        } else {
          alert('첨부 파일이 추가되지 않았습니다.');
        }
        $('#files').val('');
      }
    })
  })
}

//첨부 삭제
const fnRemoveAttach = () => {
  $(document).on('click', '.remove-attach', (evt) => {
    if(!confirm('해당 첨부 파일을 삭제할까요?')) {
      return;
    }
    fetch('${contextPath}/board/removeAttach.do', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        'attachNo': evt.target.dataset.attachNo
      })
    })
    .then(response => response.json())
    .then(resData => {  // resData = {"deleteCount": 1}
      if(resData.deleteCount === 1) {
        alert('첨부 파일이 삭제되었습니다.');
        fnAttachList();
      } else {
        alert('첨부 파일이 삭제되지 않았습니다.');
      }
    })
  })
}




// 제목 필수 입력 스크립트
const fnModifyBoard = () => {
  document.getElementById('frm-board-modify').addEventListener('submit', (evt) => {
    if(document.getElementById('title').value === '') {
      alert('제목은 필수입니다.');
      evt.preventDefault();
      return;
    }
  })
}

// 파일 미첨부 상태로 파일 첨부하는거 막음
const fnCheckAttachList = () => {
<<<<<<< HEAD
  document.getElementById('btn-add-attach').addEventListener('click', (evt) => {
      if(document.getElementById('files').value === '') {
        alert('업로드 할 파일을 선택해주세요.');
        evt.preventDefault();
        return;
      }
    })
=======
	document.getElementById('btn-add-attach').addEventListener('click', (evt) => {
	    if(document.getElementById('files').value === '') {
	      alert('업로드 할 파일을 선택해주세요.');
	      evt.preventDefault();
	      return;
	    }
	  })
	
	
>>>>>>> e60f3f12008f2782437821369b26d977ef3cb3a1
}

 
// 크기 제한 스크립트 + 첨부 목록 출력 스크립트
const fnAttachCheck = () => {
  document.getElementById('files').addEventListener('change', (evt) => {
    const limitPerSize = 1024 * 1024 * 10;
    const limitTotalSize = 1024 * 1024 * 100;
    let totalSize = 0;
    const files = evt.target.files;
    const newAttachList = document.getElementById('new-attach-list');
    newAttachList.innerHTML = '';
    for(let i = 0; i < files.length; i++){
      if(files[i].size > limitPerSize){
        alert('각 첨부 파일의 최대 크기는 10MB입니다.');
        evt.target.value = '';
        newAttachList.innerHTML = '';
        return;
      }
      totalSize += files[i].size;
      if(totalSize > limitTotalSize){
        alert('전체 첨부 파일의 최대 크기는 100MB입니다.');
        evt.target.value = '';
        newAttachList.innerHTML = '';
        return;
      }
      newAttachList.innerHTML += '<div>' + files[i].name + '</div>';
    }
  })
}


fnAttachList();
fnAddAttach();
fnRemoveAttach();
fnModifyBoard();
fnAttachCheck();
fnCheckAttachList();

</script>

<%@ include file="../layout/footer.jsp" %>
