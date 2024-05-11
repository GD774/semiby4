<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${contextPath}/resources/css/footer.css?dt=${dt}">
    <title>Document</title>
</head>

<body>
</div>
<div>
    <footer class="footer bg-light">
        <p class="footer-content">© 2024 GD Academy. All rights reserved.</p>
        <a href="https://www.saramin.co.kr/zf_user/">
        <img id="saramin" src="${contextPath}/resources/images/saramin.png">
        </a>
        <a href="https://www.jobkorea.co.kr/">
        <img id="jobkorea" src="${contextPath}/resources/images/jobkorea.png">
        </a>
        <a href="https://www.jobplanet.co.kr/job">
        <img id="jobplanet" src="${contextPath}/resources/images/jobplanet.png">
        </a>
        <a href="https://www.wanted.co.kr/">
        <img id="wanted" src="${contextPath}/resources/images/wanted.png">
        </a>
        
    </footer>
    </div>
</body>
</html>