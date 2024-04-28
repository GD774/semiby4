<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <!-- jQuery CDN 추가 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
</head>
<body>
    <script>
        $(document).ready(function() {
            // 에러 알림을 표시하는 함수
            function showErrorAlert(message) {
                alert(message);
            }
            
            // URL에서 error 파라미터를 가져옴
            var urlParams = new URLSearchParams(window.location.search);
            var error = urlParams.get('error');
            
            // error 파라미터에 따라 에러 알림을 표시
            if (error === 'numberFormatError') {
                showErrorAlert('숫자 형식에 오류가 있습니다.');
            } else {
                showErrorAlert('알 수 없는 오류가 발생했습니다.');
            }
        });
    </script>
</body>
</html>
