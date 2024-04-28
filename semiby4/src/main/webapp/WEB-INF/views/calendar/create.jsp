<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"> 

<title>
게시글 작성화면
</title>


<!-- include libraries(jquery, bootstrap) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

<!-- cdn 변경 -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

</head>
<body>

  <style>
  #main-wrap{
  display: flex;
  flex-direction: column;
  align-items: center;
  }
  
  
  #title{
  width: 990px;
  margin-left : 30px;
  margin-bottom: 10px;
  }
  
  #contents{
  width: 990px;
  height: 400px;
  margin-left : 30px;
  }
  
  #files{
  width: 300px;
  margin-left : 30px;
  }
  
  #writer{
  width: 300px;
  margin-left : 30px;
  }
  
  #files-wrap{
  margin-top : 20px;
  margin-botton: 100px;
  }
  
  hr {
    border: 2px solid black;
}

  label {
    padding-left: 25px;
    margin-top: 20px;
  }
  
  #buttons {
    margin-left: 30px;
    margin-top: 20px;
    margin-bottom: 50px;
  }
  
  #file-list {
    width: 300px;
    margin-left : 30px;
  }
  
  #startDate {
  margin-left : 30px;
  
  }
  
  #endDate {
  margin-left : 30px;
  }
  
  #startword {
  margin-left : 30px;
  }
  #endword {
  margin-left : 30px;
  }
  
  #titleword {
  margin-left : 5px;
  }
  
  #btn-golist {
  display:flex;
  margin-top : 30px;
  margin-left : 285px;
  
  }
  
  </style>
  



 <div class="gnb-wrap">
 <button id="btn-golist" onclick="location.href='${contextPath}/calendar/list'">일정으로 돌아가기</button>
 </div>
     
 <div id="main-wrap">
 <div id="title">
 <h1 class="title">일정작성</h1>
 <hr>
 </div>
 
 
 <form id="frm-board-register"
       method="POST"
       enctype="multipart/form-data"
       action = "${contextPath}/calendar/register.do">
       
 <div>
  <label for="writer" >작성자</label>
  <input type="text" class="form-control" id="writer" value="${sessionScope.user.userNo}" readonly>
 </div>
 
 <div>
  <h3 id="startword">시작 날짜</h3>
  <input type="text" id="startDate" placeholder="YYYY-MM-DD로 입력하세요">
 </div>

 <div>
  <h3 id="endword">종료 날짜</h3>
  <input type="text" id="endDate" placeholder="YYYY-MM-DD로 입력하세요" >
 </div>
 
 
 <div>
  <label for="title" id="titleword">일정이름</label>
  <input type="text" class="form-control" name="title" id="title" placeholder="제목을 입력하세요">
 </div>      
 
 <div>
  <textarea id="contents" class="form-control" name="contents" placeholder="내용을 입력하세요"></textarea>
 </div>
 
 
 
 
 <div id="buttons">
 <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
 <button id="#btn-register"
	       onclick="location.href='${contextPath}/calendar/create.do'">작성완료</button>
 <a href="${contextPath}/calendar/create.do"><button type="button">작성취소</button></a>
 </div>
 
 </form>
 
</div> 
 
<script>

// 입력한 값을 컨트롤러의 PostMapping으로 요청 받을 수 있게 ajax를 사용해
const fnRegisterEvent = () => {
    $('#frm-board-register').submit(function(evt) {
        evt.preventDefault(); // 기본 제출 동작 방지

        // 폼 데이터 가져오기
        var formData = new FormData($(this)[0]);

        // AJAX 요청 보내기
        $.ajax({
            url: '${contextPath}/calendar/register.do',
            type: 'POST',
            data: formData,
            success: function(response) {
                // 요청 성공 시 할 일
                alert('일정이 성공적으로 등록되었습니다.');
            },
            error: function(xhr, status, error) {
                // 요청 실패 시 할 일
                alert('일정 등록에 실패했습니다. 오류: ' + xhr.status);
            }
        });
    });
}

$(document).ready(function() {
    $('#btn-register').on('click', function() {
        fnRegisterEvent();
    });
});

</script>
 


        
</body>
</html>
