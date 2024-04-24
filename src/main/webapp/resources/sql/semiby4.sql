-- DROP TABLE BOARD_T CASCADE CONSTRAINTS;
-- DROP TABLE USER_T CASCADE CONSTRAINTS;

DROP SEQUENCE COMMENT_SEQ;
DROP SEQUENCE BOARD_SEQ;
DROP SEQUENCE ATTACH_SEQ;
DROP SEQUENCE USER_SEQ;

CREATE SEQUENCE USER_SEQ NOCACHE;
CREATE SEQUENCE BOARD_SEQ NOCACHE;
CREATE SEQUENCE ATTACH_SEQ NOCACHE;
CREATE SEQUENCE COMMENT_SEQ NOCACHE;

DROP TABLE COMMENT_T;
DROP TABLE ATTACH_T;
DROP TABLE BOARD_T;
DROP TABLE USER_T;

CREATE TABLE USER_T (
   USER_NO        NUMBER   NOT NULL,
   EMPLOYEE_ID    VARCHAR2(100 BYTE)  NOT NULL UNIQUE,
   PW            VARCHAR2(64 BYTE)  NOT NULL,
   EMAIL        VARCHAR2(100 BYTE)   NULL,
   NAME         VARCHAR2(100 BYTE) NULL,
   GENDER       VARCHAR2(5 BYTE)   NULL,
   MOBILE       VARCHAR2(20 BYTE)  NULL,
   PW_MODIFY_DT DATE               NULL,
   SIGNUP_DT    DATE               NULL,
    CONSTRAINT PK_USER_NO PRIMARY KEY(USER_NO)
);

CREATE TABLE BOARD_T (
   BOARD_NO    NUMBER               NOT NULL,
   USER_NO       NUMBER               NOT NULL,
   TITLE       VARCHAR2(1000 BYTE)   NOT NULL,
   CONTENTS    CLOB               NULL,
   HIT           NUMBER               DEFAULT 0,
   CREATE_DT   TIMESTAMP           NULL,
   MODIFY_DT   TIMESTAMP           NULL,
    CONSTRAINT PK_BOARD_NO      PRIMARY KEY (BOARD_NO),
    CONSTRAINT FK_BOARD_USER_NO FOREIGN KEY(USER_NO)
    REFERENCES USER_T(USER_NO) ON DELETE CASCADE
);

CREATE TABLE ATTACH_T (
   ATTACH_NO         NUMBER            NOT NULL,
   UPLOAD_PATH         VARCHAR2(500 BYTE) NULL,
   FILESYSTEM_NAME     VARCHAR2(500 BYTE) NULL,
   ORIGINAL_FILENAME VARCHAR2(500 BYTE) NULL,
   DOWNLOAD_COUNT     NUMBER            NULL,
   HAS_THUMBNAIL     NUMBER            NULL,
   BOARD_NO         NUMBER            NOT NULL,
    CONSTRAINT PK_ATTACH_NO PRIMARY KEY(ATTACH_NO),
    CONSTRAINT FK_ATTACH_BOARD_NO FOREIGN KEY(BOARD_NO)
    REFERENCES BOARD_T(BOARD_NO) ON DELETE CASCADE
);

CREATE TABLE COMMENT_T (
   COMMENT_NO NUMBER               NOT NULL,
   USER_NO    NUMBER               NOT NULL,
   CONTENTS   VARCHAR2(2000 BYTE)   NOT NULL,
   CREATE_DT  TIMESTAMP            NULL,
   STATE      NUMBER               NULL,
   DEPTH      NUMBER               NULL, --'?���?0, ?���?1',
   GROUP_NO   NUMBER               NULL,
   BOARD_NO   NUMBER               NOT NULL,
    CONSTRAINT PK_COMMENT_NO PRIMARY KEY (COMMENT_NO),
    CONSTRAINT FK_COMMENT_USER_NO FOREIGN KEY(USER_NO)
    REFERENCES USER_T(USER_NO) ON DELETE CASCADE
);



INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'admin', STANDARD_HASH('admin', 'SHA256'), 'admin@example.com', '�?리자', 'man', '010-1111-1111', CURRENT_DATE, CURRENT_DATE);
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'tester1', STANDARD_HASH('1111', 'SHA256'), 'tester1@example.com', '?��?��?��1', 'man', '010-1111-1111', CURRENT_DATE, CURRENT_DATE);
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'tester2', STANDARD_HASH('2222', 'SHA256'), 'tester2@example.com', '?��?��?��2', 'man', '010-2222-2222', CURRENT_DATE, CURRENT_DATE);
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'tester3', STANDARD_HASH('3333', 'SHA256'), 'tester3@example.com', '?��?��?��3', 'man', '010-3333-3333', CURRENT_DATE, CURRENT_DATE);
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'tester4', STANDARD_HASH('4444', 'SHA256'), 'tester4@example.com', '?��?��?��4', 'man', '010-4444-4444', CURRENT_DATE, CURRENT_DATE);
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'tester5', STANDARD_HASH('5555', 'SHA256'), 'tester5@example.com', '?��?��?��5', 'man', '010-5555-5555', CURRENT_DATE, CURRENT_DATE);
INSERT INTO USER_T VALUES(USER_SEQ.NEXTVAL, 'tester6', STANDARD_HASH('6666', 'SHA256'), 'tester6@example.com', '?��?��?��6', 'man', '010-6666-6666', CURRENT_DATE, CURRENT_DATE);
COMMIT;

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 1, '첫 번째 게시글 제목', '첫 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 2, '두 번째 게시글 제목', '두 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 3, '세 번째 게시글 제목', '세 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 4, '네 번째 게시글 제목', '네 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 5, '다섯 번째 게시글 제목', '다섯 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 6, '여섯 번째 게시글 제목', '여섯 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 1, '일곱 번째 게시글 제목', '일곱 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 1, '여덟 번째 게시글 제목', '여덟 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 2, '아홉 번째 게시글 제목', '아홉 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 1, '열 번째 게시글 제목', '열 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 2, '열한 번째 게시글 제목', '열한 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 3, '열두 번째 게시글 제목', '열두 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 4, '열세 번째 게시글 제목', '열세 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 5, '열네 번째 게시글 제목', '열네 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 6, '열다섯 번째 게시글 제목', '열다섯 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 1, '열여섯 번째 게시글 제목', '열여섯 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 2, '열일곱 번째 게시글 제목', '열일곱 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 3, '열여덟 번째 게시글 제목', '열여덟 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT) VALUES (BOARD_SEQ.NEXTVAL, 4, '열아홉 번째 게시글 제목', '열아홉 번째 게시글 내용입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 2, '아침에 본 아름다운 풍경', '오늘 아침에 창밖을 보니 정말 아름다운 풍경이 펼쳐져 있었습니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 4, '가을 하늘의 색', '가을 하늘이 정말 멋지게 보이네요. 구름도 많고 파란색이 눈부십니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 5, '커피 한 잔의 여유', '오늘은 시간을 내어 조용히 커피 한 잔을 마시며 주변을 둘러보았습니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 1, '책방의 숨겨진 명작들', '작은 책방에서 발견한 명작들과 그 이야기를 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 3, '운동으로 얻은 새로운 친구', '정기적인 운동을 통해 만난 새로운 친구들과의 경험을 이야기합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 2, '비 오는 날의 소리', '비 오는 날, 창가에서 들리는 빗소리에 대한 감상을 나눕니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 6, '주말 캠핑 여행', '지난 주말 가족과 함께 다녀온 캠핑 여행 이야기입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 5, '도시의 밤 풍경', '도심에서 바라본 밤하늘과 불빛의 조화를 소개합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 4, '새로운 요리 도전', '집에서 새로 시도해 본 요리법과 그 과정을 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 1, '올해 읽은 책 추천', '올해 읽은 책 중에서 인상 깊었던 책들을 추천합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 3, '테라스에서의 아침', '테라스에서 맞이하는 아침의 평화로움에 대해 이야기합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 2, '화가의 일상', '일상에서 영감을 받아 그림을 그리는 과정을 소개합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 6, '공원에서의 봄날', '공원에서 보낸 봄날의 따뜻한 햇살과 꽃들의 아름다움을 나눕니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 1, '계절의 변화 느끼기', '자연 속에서 계절의 변화를 느끼며 살아가는 이야기를 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 2, '최근에 본 영화 리뷰', '이번 주에 본 영화 중 인상 깊었던 영화에 대한 리뷰를 남깁니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 3, '지역 축제 체험기', '최근 참여한 지역 축제와 그 속에서 느낀 점을 나눕니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 4, '취미 생활 공유', '제가 즐기는 취미 생활과 그것이 주는 즐거움에 대해 이야기합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 5, '건강한 생활 습관', '건강을 유지하기 위해 실천하고 있는 생활 습관들을 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 6, '주변의 숨은 명소', '우리 동네 주변의 숨은 명소를 찾아 다녀온 후기입니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 1, '반려동물과의 일상', '반려동물과 보내는 일상 속 행복한 순간들을 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 2, '아침을 여는 조리법', '활기찬 아침을 시작하는 나만의 특별한 조리법을 소개합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 3, '스마트홈 기기 리뷰', '최근 구입한 스마트홈 기기 사용 후기와 추천 포인트를 나눕니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, 4, '도시 농부의 하루', '도시에서 농부로 살아가는 하루의 일과를 소개합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '밤하늘의 별 관찰', '도심에서 벗어나 밤하늘의 별을 관찰한 경험을 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '초보 등산가의 봉우리 도전기', '등산 초보자가 처음으로 봉우리를 정복한 이야기를 들려드립니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '수제 맥주 만들기', '집에서 수제 맥주를 만드는 과정과 그 맛에 대해 이야기합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '언택트 시대의 온라인 학습', '코로나19 이후 변화한 온라인 학습 경험과 그 장단점을 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '테라리움 DIY', '집에서 작은 테라리움을 만드는 방법과 그 매력을 소개합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '역사 도시 탐방', '역사적인 도시를 방문하고 느낀 점을 나누는 여행기.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '재테크 초보의 투자 일기', '재테크를 시작한 초보자가 겪는 시행착오와 성공담을 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '지속 가능한 삶을 위한 노력', '환경을 고려하여 지속 가능한 삶을 영위하기 위한 노력들을 소개합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '프리랜서로 살아가기', '프리랜서로 전환한 후 겪는 일상과 그 속에서의 도전을 이야기합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO BOARD_T (BOARD_NO, USER_NO, TITLE, CONTENTS, HIT, CREATE_DT, MODIFY_DT)
VALUES (BOARD_SEQ.NEXTVAL, FLOOR(DBMS_RANDOM.VALUE(1, 7)), '모바일 게임 개발기', '모바일 게임을 개발하면서 겪은 과정과 그 배움의 경험을 공유합니다.', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


COMMIT;
