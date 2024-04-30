<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Sign In" name="title"/>
</jsp:include>

    <title>Sign In</title>

</head>
<body>
<div class="container mt-5">
    <h1 class="text-center mb-4">Sign In</h1>
    <div class="row justify-content-center">
        <div class="col-md-6">
            <form method="POST" action="${contextPath}/user/signin.do" class="card card-body">
                <div class="mb-3">
                    <label for="userId" class="form-label">아이디</label>
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디" required>
                </div>
                <div class="mb-3">
                    <label for="pw" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="pw" name="pw" placeholder="●●●●" required>
                </div>
                <input type="hidden" name="url" value="${url}">
                <button type="submit" class="btn btn-light w-100">Sign In</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="../layout/footer.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>