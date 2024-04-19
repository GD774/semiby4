package com.gdu.semiby4.service;

import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.Optional;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.RequiredArgsConstructor;
import net.coobird.thumbnailator.Thumbnails;

import com.gdu.semiby4.mapper.BoardMapper;
import com.gdu.semiby4.utils.MyFileUtils;
import com.gdu.semiby4.utils.MyPageUtils;
import com.gdu.semiby4.utils.MySecurityUtils;

import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.dto.AttachDto;
import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.dto.CommentDto;

@RequiredArgsConstructor
@Service

public class BoardServiceImpl implements BoardService {
  
  private final BoardMapper boardMapper;
  private final MyPageUtils myPageUtils;
  private final MyFileUtils myFileUtils;

  @Override
  public void boardList(Model model) {
    Map<String, Object> modelMap = model.asMap();
    HttpServletRequest request = (HttpServletRequest) modelMap.get("request");
    
    int total = boardMapper.getBoardCount();
    
    Optional<String> optDisplay = Optional.ofNullable(request.getParameter("display"));
    int display = Integer.parseInt(optDisplay.orElse("10"));
    
    Optional<String> optPage = Optional.ofNullable(request.getParameter("page"));
    int page = Integer.parseInt(optPage.orElse("1"));
    
    myPageUtils.setPaging(total, display, page);
    
    Optional<String> optSort = Optional.ofNullable(request.getParameter("sort"));
    String sort = optSort.orElse("DESC");
    
    Map<String, Object> map = Map.of("begin", myPageUtils.getBegin()
                                   , "end", myPageUtils.getEnd()
                                   , "sort", sort);
    
    model.addAttribute("beginNo", total - (page - 1) * display);
    model.addAttribute("boardList", boardMapper.getBoardList(map));
    model.addAttribute("paging", myPageUtils.getPaging(request.getContextPath() + "/board/list.do", sort, display));
    model.addAttribute("display", display);
    model.addAttribute("sort", sort);
    model.addAttribute("page", page);
  }


  @Override
  public void boardListByNo(int boardNo, Model model) {
    
    model.addAttribute("board", boardMapper.getBoardByNo(boardNo));
    model.addAttribute("attachList", boardMapper.getAttachList(boardNo));
    
  }
  
 
  
  @Override
  public Map<String, Object> getAttachList(int boardNo) {
      return Map.of("attachList", boardMapper.getAttachList(boardNo));
  }

	@Override
  public void loadboardSearchList(HttpServletRequest request, Model model) {
    
    String column = request.getParameter("column");
    String query = request.getParameter("query");
    
    // 검색 데이터 개수를 구할 때 사용할 Map
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("column", column);
    map.put("query", query);
    
    int total = boardMapper.getSearchCount(map);
    
    int display = 20;
    
    Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
    int page = Integer.parseInt(opt.orElse("1"));
    
    myPageUtils.setPaging(total, display, page);
  }

	@Override
  public boolean registerUpload(MultipartHttpServletRequest multipartRequest) {
    
    // Upload_T 테이블에 추가하기(ATTACH_T 삽입을 위해 이걸 가장 먼저 처리해줌)
    String title = multipartRequest.getParameter("title");
    String contents = multipartRequest.getParameter("contents");
    String cateNo = multipartRequest.getParameter("cateNo");
    int userNo = Integer.parseInt(multipartRequest.getParameter("userNo"));
    
    UserDto user = new UserDto();
    user.setUserNo(userNo);
    
    BoardDto board = BoardDto.builder()
                          .title(title)
                          .cateNo(cateNo)
                          .contents(contents)
                          .user(user)
                        .build();
   
    int insertUploadCount = boardMapper.insertBoard(board);
    
    
   
    List<MultipartFile> files = multipartRequest.getFiles("files");  
    
    
    int insertAttachCount;
    if(files.get(0).getSize() == 0) {
      insertAttachCount = 1;         // 첨부가 없으면 files.size() 는 1 이다.
    } else {
      insertAttachCount = 0;         // 0으로 초기화 시켜놓고 있는 파일개수만큼 올라감.
    }
    
    for (MultipartFile multipartFile : files) {
      if(multipartFile != null && !multipartFile.isEmpty()) {     // null 아니고 공백 아니면
        
        String uploadPath = myFileUtils.getUploadPath();
        File dir = new File(uploadPath);
        if(!dir.exists()) {
          dir.mkdirs();
        }
        
        String originalFilename = multipartFile.getOriginalFilename();
        String filesystemName = myFileUtils.getFilesystemName(originalFilename);
        File file = new File(dir, filesystemName);
        
        try {
          multipartFile.transferTo(file); // 여기까지가 저장
          
          // 썸네일 작성
          String contentType = Files.probeContentType(file.toPath()); 
          int hasThumbnail = contentType != null && contentType.startsWith("image") ? 1 : 0;
          if(hasThumbnail == 1) {
            File thumbnail = new File(dir, "s_" + filesystemName); // 썸네일 이름은 smallsize란 뜻의 s_를 원래이름 앞에 붙여줌
            Thumbnails.of(file)            // 원본 이미지 파일
                      .size(96, 64)        // 가로 96px, 세로 64px. 사이즈는 1920/20 1280/20 이렇게 해서 정해줌...1/20 사이즈로 줄여넣음. 원본의 몇 % 이렇게 지정하는 방법도 있음. 사이트 참고~
                      .toFile(thumbnail);  // 썸네일 이미지 파일
          }
         
      
          AttachDto attach = AttachDto.builder()
                               .uploadPath(uploadPath)
                               .filesystemName(filesystemName)
                               .originalFilename(originalFilename)
                               .hasThumbnail(hasThumbnail)
                               .boardNo(board.getBoardNo())    
                               .build();
          
          insertAttachCount += boardMapper.insertAttach(attach);  // 여기는 for문 내부임. += 를 해줘야 한다.
          
        } catch (Exception e) {
          e.printStackTrace();
        }
      } // if 끝
    }   // for 끝
    return (insertUploadCount == 1) && (insertAttachCount == files.size());
    // 첨부파일이 없으면 사이즈가 = 1. 그래서 초기화값도 1
  }

	
	// 다운로드(attachList 를 위해 순지선이 건드리는 중)
	@Override
  public BoardDto getBoardByNo(int boardNo) {
	  
    return boardMapper.getBoardByNo(boardNo);
  }

  @Override
  public int registerComment(HttpServletRequest request) {
    String contents = MySecurityUtils.getPreventXss(request.getParameter("contents"));
    int boardNo = Integer.parseInt(request.getParameter("boardNo"));
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    
    UserDto user = new UserDto();
    user.setUserNo(userNo);
    
    CommentDto comment = CommentDto.builder()
                             .contents(contents)
                             .user(user)
                             .boardNo(boardNo)
                          .build();
    
    return boardMapper.insertComment(comment);
  }

  @Override
  public Map<String, Object> getCommentList(HttpServletRequest request) {
    int boardNo = Integer.parseInt(request.getParameter("boardNo"));
    int page = Integer.parseInt(request.getParameter("page"));
    
    int total = boardMapper.getCommentCount(boardNo);
    int display = 10;
    
    myPageUtils.setPaging(total, display, page);
    Map<String, Object> map = Map.of("boardNo", boardNo
                                   , "begin", myPageUtils.getBegin()
                                   , "end", myPageUtils.getEnd());
    return Map.of("commentList", boardMapper.getCommentList(map)
                , "paging", myPageUtils.getAsyncPaging());
  }
  
  
  // 순지선이 다운로드를 위해 추가
  
   @Override
  public List<AttachDto> getAttachByBoard(int boardNo) {
     return boardMapper.getAttachList(boardNo);
  }
  
  
  @Override
  public ResponseEntity<Resource> download(HttpServletRequest request) {
    // 첨부 파일 정보를 DB 에서 가져오기
    int attachNo = Integer.parseInt(request.getParameter("attachNo"));
    AttachDto attach = boardMapper.getAttachByNo(attachNo);
    
    // 첨부 파일 정보를 File 객체로 만든 뒤 Resource 객체로 변환
    File file = new File(attach.getUploadPath(), attach.getFilesystemName()); 
    Resource resource = new FileSystemResource(file);
    
    // 첨부 파일 없으면 다운로드 취소
    if(!resource.exists()) {
      return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    
    // DOWNLOAD_COUNT 증가
    boardMapper.updateDownloadCount(attachNo);
    
    // 사용자가 다운로드 받을 파일명 결정
    String originalFilename = attach.getOriginalFilename();
    String userAgent = request.getHeader("User-Agent");  
    try { 
      
      // IE
      if(userAgent.contains("Trident")){
        originalFilename = URLEncoder.encode(originalFilename, "UTF-8").replace("+", ""); //
      }
      // Edge
      else if(userAgent.contains("Edg")){ 
        originalFilename = URLEncoder.encode(originalFilename, "UTF-8");
      }

      else {
       originalFilename = new String(originalFilename.getBytes(""), "ISO-8859-1");
      }
      
    } catch (Exception e) {
      e.printStackTrace();
    }
    
    // 다운로드용 응답 헤더 설정
    HttpHeaders responseHeader = new HttpHeaders();
    responseHeader.add("Content-Type", "application/octet-stream");
    responseHeader.add("Content-Disposition", "attachment; filename=" + originalFilename);
    responseHeader.add("Content-Length", file.length() + ""); //file.length()가 long 이라서 "" 더해서 String 으로 만들어줌
    
    
    // 다운로드 진행
    return new ResponseEntity<Resource>(resource, responseHeader, HttpStatus.OK);
  
  }
  
  @Override
  public ResponseEntity<Resource> downloadAll(HttpServletRequest request) {

    // 다운로드할 모든 첨부 파일들의 정보를 DB 에서 가져오기
    
    int boardNo = Integer.parseInt(request.getParameter("boardNo"));
    List<AttachDto> attachList = boardMapper.getAttachList(boardNo);
    
    // 첨부 파일이 없으면 종료
    if(attachList.isEmpty()) {
      return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
    }
    
    // 임시 zip 파일 저장할 경로
    File tempDir = new File(myFileUtils.getTempPath());
    if (!tempDir.exists()) {
     tempDir.mkdirs(); 
    }
    
    // 임시 zip 파일 이름
    String tempFilename = myFileUtils.getTempFilename() + ".zip";
    
    // 임시 zip 파일 File 객체
    File tempfile = new File(tempDir, tempFilename);
    
    // 첨부 파일들을 하나씩 zip 파일로 모으기
    try {
      
      // ZipOutputStream 객체 생성
      ZipOutputStream zout = new ZipOutputStream(new FileOutputStream(tempfile));
      
      for (AttachDto attach : attachList) {
        
        // zip 파일에 포함할 ZipEntry 객체 생성
        ZipEntry zipEntry = new ZipEntry(attach.getOriginalFilename()); // zip 파일에 들어갈 개별 파일의 이름
        
        // zip 파일에 ZipEntry 객체 명단 추가 (파일의 이름만 등록한 상황)
        zout.putNextEntry(zipEntry);
        
        // 실제 첨부 파일을 zip 파일에 등록 (첨부 파일을 읽어서 zip 파일로 보냄. 읽어들이는 건 InputStream) 
        BufferedInputStream in = new BufferedInputStream(new FileInputStream(new File(attach.getUploadPath(), attach.getFilesystemName())));
        zout.write(in.readAllBytes());  // 싹 다 읽어오는 메소드
        
        // 사용한 자원 정리
        in.close();
        zout.closeEntry();
        
        // DOWNLOAD_COUNT 증가
        boardMapper.updateDownloadCount(attach.getAttachNo());
        
      } // for문 종료
      
      // zout 자원 반납
      zout.close();
      
    } catch (Exception e) {
      e.printStackTrace();
    }
    
    // 다운로드 할 zip File 객체 -> Resource 객체
     Resource resource = new FileSystemResource(tempfile);
    
     // 임시파일의 이름이 숫자(TIMPESTAMP)로 되어있기 때문에 인코딩을 할 필요가 없다.
     
     // 다운로드용 응답 헤더 설정 (HTTP 참조)
     HttpHeaders responseHeader = new HttpHeaders();
     responseHeader.add("Content-Type", "application/octet-stream");
     responseHeader.add("Content-Disposition", "attachment; filename=" + tempFilename);
     responseHeader.add("Content-Length", tempfile.length() + ""); //file.length()가 long 이라서 "" 더해서 String 으로 만들어줌
     
     
     // 다운로드 진행
     return new ResponseEntity<Resource>(resource, responseHeader, HttpStatus.OK);
  }

  
}
