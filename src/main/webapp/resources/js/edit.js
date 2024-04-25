/**
 * 
 */

var idCheck = true;
var passwordCheck = false;
var passwordConfirm = false;
var nameCheck = false;
var mobileCheck = false;
var agreeCheck = false;

const fnGetContextPath = ()=>{
  const host = location.host;  /* localhost:8080 */
  const url = location.href;   /* http://localhost:8080/mvc/getDate.do */
  const begin = url.indexOf(host) + host.length;
  const end = url.indexOf('/', begin + 1);
  return url.substring(begin, end);
}

const fnCheckPassword = () => {
  // 비밀번호 4~12자, 영문/숫자/특수문자 중 2개 이상 포함
  let inpPw = document.getElementById('inp-pw');
  let validCount = /[A-Za-z]/.test(inpPw.value)     // 영문 포함되어 있으면 true (JavaScript 에서 true 는 숫자 1 같다.)
                 + /[0-9]/.test(inpPw.value)        // 숫자 포함되어 있으면 true
                 + /[^A-Za-z0-9]/.test(inpPw.value) // 영문/숫자가 아니면 true
  let passwordLength = inpPw.value.length;
  passwordCheck = passwordLength >= 4
               && passwordLength <= 12
               && validCount >= 2
  let msgPw = document.getElementById('msg-pw');
  if(passwordCheck){
    msgPw.innerHTML = '사용 가능한 비밀번호입니다.';
  } else {
    msgPw.innerHTML = '비밀번호 4~12자, 영문/숫자/특수문자 중 2개 이상 포함';
  }
}

const fnConfirmPassword = () => {
  let inpPw = document.getElementById('inp-pw');
  let inpPw2 = document.getElementById('inp-pw2');
  passwordConfirm = (inpPw.value !== '')
                 && (inpPw.value === inpPw2.value)
  let msgPw2 = document.getElementById('msg-pw2');
  if(passwordConfirm) {
    msgPw2.innerHTML = '';
  } else {
    msgPw2.innerHTML = '비밀번호 입력을 확인하세요.';
  }
}

const fnCheckName = () => {
  let inpName = document.getElementById('inp-name');
  let name = inpName.value;
  let totalByte = 0;
  for(let i = 0; i < name.length; i++){
    if(name.charCodeAt(i) > 127) {  // 코드값이 127 초과이면 한 글자 당 2바이트 처리한다.
      totalByte += 2;
    } else {
      totalByte++;
    }
  }
  nameCheck = (totalByte <= 100);
  let msgName = document.getElementById('msg-name');
  if(!nameCheck){
    msgName.innerHTML = '이름은 100 바이트를 초과할 수 없습니다.';
  } else {
    msgName.innerHTML = '';
  }
}

const fnCheckMobile = () => {
  let inpMobile = document.getElementById('inp-mobile');
  let mobile = inpMobile.value;
  mobile = mobile.replaceAll(/[^0-9]/g, '');
  mobileCheck = /^010[0-9]{8}$/.test(mobile);
  let msgMobile = document.getElementById('msg-mobile');
  if(mobileCheck) {
    msgMobile.innerHTML = '';
  } else {
    msgMobile.innerHTML = '휴대전화를 확인하세요.';
  }
}

const fnEdit = () => {
  document.getElementById('frm-signup').addEventListener('submit', (evt) => {
    if(!idCheck) {
      alert('아이디를 확인하세요.');
      evt.preventDefault();
      return;
    // } else if(!passwordCheck || !passwordConfirm){
    //   alert('비밀번호를 확인하세요.');
    //   evt.preventDefault();
    //   return;
    } else if(!nameCheck) {
      alert('이름을 확인하세요.');
      evt.preventDefault();
      return;
    } else if(!mobileCheck) {
      alert('휴대전화를 확인하세요.');
      evt.preventDefault();
      return;
    }
  })
}


// document.getElementById('btn-code').addEventListener('click', fnCheckEmail);
document.getElementById('inp-pw').addEventListener('keyup', fnCheckPassword);
document.getElementById('inp-pw2').addEventListener('blur', fnConfirmPassword);
document.getElementById('inp-name').addEventListener('blur', fnCheckName);
document.getElementById('inp-mobile').addEventListener('blur', fnCheckMobile);
fnEdit();
