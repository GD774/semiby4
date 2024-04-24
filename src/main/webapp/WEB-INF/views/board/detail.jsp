<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>" />
<c:set var="dt" value="<%=System.currentTimeMillis() %>" />

<jsp:include page="../layout/header.jsp"/>

<style>

  #detail-wrap{
  display: flex;
  flex-direction: column;
  align-items: center;
  align-items: flex-start;

  }

 #title{
  width: 990px;
  margin-bottom: 10px;
  margin-left : 30px;
  }
  
  #contents{
  width: 990px;
  height: 400px;
  margin-left : 30px;
  }
  
  #writer{
  width: 300px;
  margin-left : 30px;
  }
  
   #createDt{
  width: 300px;
  margin-left : 30px;
  margin-top : 15px;
  }
  
   #modifyDt{
  width: 300px;
  margin-left : 30px;
  margin-bottom : 20px;
  }
  
  #comment-contents{
  width: 1050px;
  margin-bottom: 10px;
  margin-top: 20px;
  }
  
  #btn-remove{
  margin-left: 950px;
  }
  
  hr {
  border: 2px solid black;
  }
  
  label {
    padding-left: 25px;
    margin-top: 20px;
  }
  
  #attach-box {
    width: 85px;
    margin-bottom: 10px;
  }

</style>

 <div id="detail-wrap">

 <div id="title-div">
 <h1 class="title">상세보기</h1>
 <hr>
 </div>

<div>
  <label for="writer" >작성자</label>
  <input type="text" class="form-control" id="writer" name="writer" value="${board.user.email}" readonly>
</div>

<div>
  <label for="title" >제목</label>
  <input type="text" class="form-control" id="title" name="title" value="${board.title}" readonly>
</div>

<div>
  <input type="text" id="contents" class="form-control" name="contents" value="${board.contents}" readonly>
 </div>


<div id="createDt">
  <span>작성일자</span>
  <input type="text" value="<fmt:formatDate value="${board.createDt}" pattern="yyyy-MM-dd HH:mm"  />" class="form-control" readonly>
</div>

<div id="modifyDt">
  <span>최종수정일</span>
  <input type="text"  value=" <fmt:formatDate value="${board.modifyDt}" pattern="yyyy-MM-dd HH:mm" />" class="form-control" readonly>
</div>



<!-- 첨부 목록 공간입니다.>>>>> ---------------------------------------------------------------------->

<div>
  <c:if test="${empty attachList}">
  <div></div>
  </c:if>
  <c:if test="${not empty attachList}">
  <div>
 <input type="text" id="attach-box" class="form-control" value="첨부파일" readonly>
  </div>
  <c:forEach items="${attachList}" var="attach">
  <div class="attach" data-attach-no="${attach.attachNo}">
  <c:if test="${attach.hasThumbnail == 1}">
  <img src="${contextPath}${attach.uploadPath}/s_${attach.filesystemName}">
  </c:if>
  <c:if test="${attach.hasThumbnail == 0}">
  <img src="${contextPath}/resources/images/attach.png" width="96px">
  </c:if>
  <a><input type="text" class="form-control" value="${attach.originalFilename}" width="100px"></a>
  </div>
  </c:forEach>
  <div> 
  
    <a id="download-all" href="${contextPath}/board/downloadAll.do?boardNo=${board.boardNo}"><button  class="btn btn-dark" style="margin-top: 10px;" >모두 다운로드</button></a>
    
  </div>
  </c:if>
</div>





<!-- <<<<< 첨부 목록 공간입니다. ---------------------------------------------------------------------->

<form id="frm-comment">
  <textarea id="comment-contents" name="contents" class="form-control" placeholder="인터넷은 여러분이 만들어가는 소중한 공간입니다."></textarea>
  <input type="hidden" name="boardNo" value="${board.boardNo}">
  <c:if test="${not empty sessionScope.user}">  
    <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
  </c:if>
  <button type="button"  class="btn btn-light" id="btn-comment-register" style="margin-left:900px;" >댓글등록</button>
</form>


<div id="comment-list"></div>
<div id="paging"></div>


<c:if test="${not empty sessionScope.user}">  
    <c:if test="${sessionScope.user.userNo == board.user.userNo || sessionScope.user.userNo == '1'}">
    <div>   
    <form id="frm-btn" method="POST">
        <input type="hidden" name="boardNo" value="${board.boardNo}">
        <button type="button" id="btn-remove" class="btn btn-danger btn-sm">게시글 삭제</button>
    </form>
    </div>
   </c:if>
 </c:if>


</div>


</div>










<script defer>
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
		  
	        const commentContents = $('#comment-contents').val();
	        if (commentContents === '') {
	            alert('댓글 내용을 입력해주세요.');
	            return;
	        }
	        
	    fnCheckSignin();
	    
	    $.ajax({
	      // 요청
	      type: 'POST',
	      url: '${contextPath}/board/registerComment.do',
	      data: $('#frm-comment').serialize(),  
	      dataType: 'json',
	      success: (resData) => {  
	        if(resData.insertCount === 1) {
	          alert('댓글이 등록되었습니다.');
	          $('#comment-contents').val('');
	          fnCommentList();
	        } else {
	          alert('댓글 등록이 실패했습니다.');
	        }
	      },
	      error: (jqXHR) => {
	    	  alert(jqXHR.statusText + '(' + jqXHR.status + ')');
	      }
	    });
	  });
	};




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
        commentList.append('<div>아직 등록된 댓글이 없습니다.</div>');
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
        str += '<div style="background-color: #dcdcdc; padding: 5px; margin-top: 5px;">';
        str += '<span  style="font-size: 16px; font-weight: bold; ">' + comment.user.email + '</span>';
        str += '<span  style="font-size: 12px; margin-left: 40px;">' + moment(comment.createDt).format('YYYY.MM.DD.') + '</span>';
        str += '<div>' + comment.contents + '</div>';
        str += '</div>';


        /*if(comment.depth === 0) {
          str += '<button type="button" class="btn btn-success btn-reply" >답글</button>';
        }
        */

       
         /*if(Number('${sessionScope.user.userNo}') === comment.user.userNo) {
           str += '<button type="button" class="btn btn-danger btn-remove" data=comment-no="' + comment.commentNo + '">삭제</button>';
         }*/
         
         /************************* 답글 입력 화면 *************************/
         /*if(comment.depth === 0) { 
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



//------------------------------------ 삭제 구현---------------------------------->>

document.addEventListener('DOMContentLoaded', function() {
	if(!document.getElementById('btn-remove')){
		return;
	}
	
    const fnRemoveBoard = () => {
        document.getElementById('btn-remove').addEventListener('click', (evt) => {
            if (confirm('해당 게시글을 삭제할까요?')) {
                frmBtn.action = '${contextPath}/board/removeBoard.do';
                frmBtn.submit();
            }
        });
    };
    fnRemoveBoard(); 
}); 




// 삭제시 DB에서 ATTACH_T 데이터 삭제되는 것 확인
// 삭제시 로컬디스크 상에 업로드된 파일들 삭제되는 것 확인
// 썸네일 삭제되는 것 확인

//<<------------------------------------------------------------------------------


$('#comment-contents').on('click', fnCheckSignin);
fnRegisterComment();
fnCommentList();
fnDownload();

</script>

</body>
</html>