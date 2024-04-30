<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Sign Up" name="title"/>
</jsp:include>

    <title>회원가입</title>

</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4 text-center">회원가입</h2>
    <div class="row justify-content-center">
        <div class="col-md-5">
            <form method="POST" action="${contextPath}/user/signup.do" class="card card-body">
                <div class="mb-4">
                    <label for="userId" class="form-label">아이디</label>
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디 입력" required>
                </div>
                <div class="mb-4">
                    <label for="pw" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="pw" name="pw" placeholder="비밀번호 입력" required>
                </div>
                <div class="mb-4">
                    <label for="pw-confirm" class="form-label">비밀번호 확인</label>
                    <input type="password" class="form-control" id="pw-confirm" name="pwConfirm" placeholder="비밀번호 확인" required>
                </div>
                <div class="mb-4">
                    <label for="email" class="form-label">이메일</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="이메일 주소" required>
                </div>
                <div class="mb-4">
                    <label for="name" class="form-label">이름</label>
                    <input type="text" class="form-control" id="name" name="name" placeholder="이름" required>
                </div>
                 <div class="mb-4">
                    <label for="mobile" class="form-label">전화번호</label>
                    <input type="text" class="form-control" id="mobile" name="mobile" placeholder="010-0000-0000" pattern="^01([0|1|6|7|8|9])-(\d{3,4})-(\d{4})$" title="010-0000-0000 형식으로 입력해주세요." required>
                </div>
                <div class="mb-4">
                    <label>성별</label>
				       <div class="form-check">
				        <input class="form-check-input" type="radio" name="gender" id="rdo-none" value="none" checked>
				        <label class="form-check-label" for="rdo-none">선택안함</label>
				      </div>
				      <div class="form-check">
				        <input class="form-check-input" type="radio" name="gender" id="rdo-man" value="man">
				        <label class="form-check-label" for="rdo-man">남자</label>
				      </div>
				      <div class="form-check">
				        <input class="form-check-input" type="radio" name="gender" id="rdo-woman" value="woman">
				        <label class="form-check-label" for="rdo-woman">여자</label>
				      </div>
                </div>
                <div class="mb-4">
                    <button type="submit" class="btn btn-primary w-100">회원가입</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${contextPath}/resources/js/signup.js?dt=${dt}"></script>

<%@ include file="../layout/footer.jsp" %>