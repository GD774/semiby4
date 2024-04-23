<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>" />
<c:set var="dt" value="<%=System.currentTimeMillis() %>" />

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">

  <!-- include libraries(jquery, bootstrap) -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

  <!-- include moment.js -->
  <script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>

  <title>상세화면</title>
</head>
<body>

<div>
  <span>작성자</span>
  <span>${board.user.email}</span>
</div>

<div>
  <span>제목</span>
  <span>${board.hit}</span>
</div>

<div>
  <span>내용</span>
  <span>${board.contents}</span>
</div>


<c:if test="${not empty sessionScope.user}">  
    <c:if test="${sessionScope.user.userNo == board.user.userNo}">
    <div>   
    <form id="frm-btn" method="POST">  
        <input type="hidden" name="boardNo" value="${board.boardNo}">
        <button type="button" id="btn-edit" class="btn btn-warning btn-sm">편집</button>
        <button type="button" id="btn-remove" class="btn btn-danger btn-sm">삭제</button>
    </form>
    </div>
   </c:if>
 </c:if>

<!-- 첨부 목록 공간입니다.>>>>> ---------------------------------------------------------------------->
<h3>첨부 파일 다운로드</h3>
<div>
  <c:if test="${empty attachList}">
  <div>첨부 없음</div>
  </c:if>
  <c:if test="${not empty attachList}">
  <c:forEach items="${attachList}" var="attach">
  
  <div class="attach" data-attach-no="${attach.attachNo}">
  <c:if test="${attach.hasThumbnail == 1}">
  <img src="${contextPath}${attach.uploadPath}/s_${attach.filesystemName}">
  </c:if>
  <c:if test="${attach.hasThumbnail == 0}">
  <img src="${contextPath}/resources/images/attach.png" width="96px">
  </c:if>
  <a>${attach.originalFilename}</a>
  </div>
  </c:forEach>
  <div> 
  
    <a id="download-all" href="${contextPath}/board/downloadAll.do?boardNo=${board.boardNo}">모두 다운로드</a>
    
  </div>
  </c:if>
</div>


<!-- <<<<< 첨부 목록 공간입니다. ---------------------------------------------------------------------->
<hr>

<form id="frm-comment">
  <textarea id="contents" name="contents"></textarea>
  <input type="hidden" name="boardNo" value="${board.boardNo}">
  <c:if test="${not empty sessionScope.user}">  
    <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
  </c:if>
  <button type="button" id="btn-comment-register">댓글등록</button>
</form>



<hr>

<div id="comment-list"></div>
<div id="paging"></div>

<script>
var page = 1;
var frmBtn = document.getElementById('frm-btn');


const fnCheckSignin = () => {
  if('${sessionScope.user}' === '') {
    if(confirm('Sign In 이 필요한 기능입니다. Sign In 할까요?')) {
      location.href = '${contextPath}/user/signin.page';
    }
  }
}


const fnRegisterComment = () => {    
  $('#btn-comment-register').on('click', (evt) => {
    fnCheckSignin();
    $.ajax({
      // 요청
      type: 'POST',
      url: '${contextPath}/board/registerComment.do',
      data: $('#frm-comment').serialize(),  // <form> 내부의 모든 입력을 파라미터 형식으로 보낼 때 사용, 입력 요소들은 name 속성을 가지고 있어야 함
      // 응답
      dataType: 'json',
      success: (resData) => {  // resData = {"insertCount": 1}
        if(resData.insertCount === 1) {
          alert('댓글이 등록되었습니다.');
          $('#contents').val('');
          fnCommentList();
        } else {
          alert('댓글 등록이 실패했습니다.');
        }
      },
      error: (jqXHR) => {
        alert(jqXHR.statusText + '(' + jqXHR.status + ')');
      }
    })
    
  })
}




const fnCommentList = () => {       
  $.ajax({
    type: 'get',
    url: '${contextPath}/board/comment/list.do',
    data: 'boardNo=${board.boardNo}&page=' + page,
    dataType: 'json',
    success: (resData) => {  // resData = {"commentList": [], "paging": "< 1 2 3 4 5 >"}
    console.log(resData.commentList); 
    let commentList = $('#comment-list');
      let paging = $('#paging');
      commentList.empty();
      paging.empty();
      if(resData.commentList.length === 0) {
        commentList.append('<div>첫 번째 댓글의 주인공이 되어 보세요</div>');
        paging.empty();
        return;
      }
      $.each(resData.commentList, (i, comment) => {
        let str = '';
        
        if(comment.depth === 0) {
          str += '<div>';
        } else {
          str += '<div style="padding-left: 32px;">'
        }

        str += '<span>';
        str += comment.user.email;
        str += '(' + moment(comment.createDt).format('YYYY.MM.DD.') + ')';
        str += '</span>';
        str += '<div>' + comment.contents + '</div>';

        if(comment.depth === 0) {
          str += '<button type="button" class="btn btn-success btn-reply" >답글</button>';
        }

         if(Number('${sessionScope.user.userNo}') === comment.user.userNo) {
           str += '<button type="button" class="btn btn-danger btn-remove" data=comment-no="' + comment.commentNo + '">삭제</button>';
         }
         
         /************************* 답글 입력 화면 *************************/
         if(comment.depth === 0) { 
           str += '<div>';
           str +=   '<form class="frm-reply">';
           str +=     '<input type="hidden" name="groupNo" value="' + comment.groupNo + '">';
           str +=     '<input type="hidden" name="boardNo" value="${board.boardNo}">'; 
           str +=     '<input type="hidden" name="userNo" value ="${sessionScope.user.userNo}">'; 
           str +=     '<textarea name="contents" placeholder="답글 입력"></textarea>';
           str +=     '<button type="button" class="btn btn-warning btn-register-reply">작성완료</button>';
           str +=   '</form>';         
           str += '</div>'; 
         }
         /******************************************************************/  
        str += '</div>';

        commentList.append(str);
      })

      paging.append(resData.paging);
    },
    error: (jqXHR) => {
      alert(jqXHR.statusText + '(' + jqXHR.status + ')');
    }
  })
}

const fnPaging = (p) => {     
  page = p;
  fnCommentList();
}

//------------------------------------ 삭제 구현---------------------------------->>

const fnRemoveBoard = () => {
  document.getElementById('btn-remove').addEventListener('click', (evt) => {
    if(confirm('해당 게시글을 삭제할까요?')){
      frmBtn.action = '${contextPath}/board/removeBoard.do';
      frmBtn.submit();
    }
  })
}

// 삭제시 DB에서 ATTACH_T 데이터 삭제되는 것 확인
// 삭제시 로컬디스크 상에 업로드된 파일들 삭제되는 것 확인
// 썸네일 삭제되는 것 확인

//<<------------------------------------------------------------------------------

//----------------------------------------------- 다운로드 ------------------------------------------------------->>>
const fnDownload = () => {
    $('.attach').on('click', (evt) => {
      if(confirm('해당 첨부 파일을 다운로드 할까요?')) {
        location.href = '${contextPath}/board/download.do?attachNo=' + evt.currentTarget.dataset.attachNo;
      }
    })
  }
  
const fnDownloadAll = () => {
    const downloadAllButton = document.getElementById('download-all');
    if (downloadAllButton) {
        downloadAllButton.addEventListener('click', (evt) => {
            if (!confirm('모두 다운로드 할까요?')) {
                evt.preventDefault();
                return;
            }
        });
    }
}
	
if (document.getElementById('download-all')) {
    fnDownloadAll();
}

//<<<<----------------------------------------------- 다운로드 -------------------------------------------------------

$('#contents').on('click', fnCheckSignin);
fnRemoveBoard();
fnRegisterComment();
fnCommentList();
fnDownload();


</script>

</body>
</html>