  var emailCheck = false;
  var passwordCheck = false;
  var passwordConfirm = false;
  var nameCheck = false;
  var mobileCheck = false;

  const checkEmail = () => {
    let email = document.getElementById('email').value;
    let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

    if (!emailRegex.test(email)) {
      alert('유효한 이메일 주소를 입력해주세요.');
      emailCheck = false;
      return;
    }

    fetch(`${contextPath}/user/checkEmail`, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ email: email })
    })
    .then(response => response.json())
    .then(data => {
      if (data.available) {
        alert('사용 가능한 이메일입니다.');
        emailCheck = true;
      } else {
        alert('이미 사용 중인 이메일입니다.');
        emailCheck = false;
      }
    })
    .catch(error => console.error('Error:', error));
  };

  const checkPassword = () => {
    let password = document.getElementById('pw').value;
    let confirmPassword = document.getElementById('pw-confirm').value;

    let regexCount = 0;
    regexCount += /[A-Za-z]/.test(password) ? 1 : 0; // 영문 포함 여부
    regexCount += /[0-9]/.test(password) ? 1 : 0;   // 숫자 포함 여부
    regexCount += /[^A-Za-z0-9]/.test(password) ? 1 : 0; // 특수문자 포함 여부

    let isValidLength = password.length >= 4 && password.length <= 12;
    passwordCheck = regexCount >= 2 && isValidLength;

    if (passwordCheck) {
      if (password === confirmPassword) {
        passwordConfirm = true;
        alert('비밀번호가 확인되었습니다.');
      } else {
        passwordConfirm = false;
        alert('비밀번호가 일치하지 않습니다.');
      }
    } else {
      alert('비밀번호는 4~12자이며, 영문/숫자/특수문자 중 2개 이상을 포함해야 합니다.');
    }
  };

  const checkName = () => {
    let name = document.getElementById('name').value;
    nameCheck = name.length <= 100;
    if (!nameCheck) {
      alert('이름은 100자 이하로 입력해야 합니다.');
    }
  };

  const checkMobile = () => {
    let mobile = document.getElementById('mobile').value;
    let mobilePattern = /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/;
    mobileCheck = mobilePattern.test(mobile);

    if (!mobileCheck) {
      alert('유효한 휴대폰 번호를 입력해주세요.');
    }
  };

  document.getElementById('signup-form').addEventListener('submit', function(event) {
    if (!emailCheck || !passwordCheck || !passwordConfirm || !nameCheck || !mobileCheck) {
      event.preventDefault();
      alert('모든 필드를 정확히 입력해주세요.');
    }
  });

  document.getElementById('email').addEventListener('blur', checkEmail);
  document.getElementById('pw').addEventListener('blur', checkPassword);
  document.getElementById('pw-confirm').addEventListener('blur', checkPassword);
  document.getElementById('name').addEventListener('blur', checkName);
  document.getElementById('mobile').addEventListener('blur', checkMobile);