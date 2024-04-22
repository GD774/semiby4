package com.gdu.semiby4.service;

import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.Optional;

import java.io.File;
import java.nio.file.Files;

import javax.servlet.http.HttpServletRequest;

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
    
//    Optional<String> optDisplay = Optional.ofNullable(request.getParameter("display"));
//    int display = Integer.parseInt(optDisplay.orElse("20"));
    int display = 20;
    
    Optional<String> optPage = Optional.ofNullable(request.getParameter("page"));
    int page = Integer.parseInt(optPage.orElse("1"));
    
    myPageUtils.setPaging(total, display, page);
    
	/*
	 * Optional<String> optSort = Optional.ofNullable(request.getParameter("sort"));
	 * String sort = optSort.orElse("DESC");
	 */
    
    String sort = request.getParameter("sort");
    if (sort == null) {
    	sort = "DESC";
    }
    
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
    
	// 요청 파라미터
    String column = request.getParameter("column");
    String query = request.getParameter("query");
    String sort = request.getParameter("sort");
    
    // 검색 데이터 개수를 구할 때 사용할 Map 생성
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("column", column);
    map.put("query", query);
    map.put("sort", sort);
    
    // 검색 데이터 개수 구하기
    int total = boardMapper.getSearchCount(map);
    
    // 한 페이지에 표시할 검색 데이터 개수
    int display = 20;
    
    // 현재 페이지 번호
    Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
    int page = Integer.parseInt(opt.orElse("1"));
    
    // 페이징 처리에 필요한 처리
    myPageUtils.setPaging(total, display, page);
    
    // 검색 목록을 가져오기 위해서 기존 Map 에 begin 과 end 를 추가
    map.put("begin", myPageUtils.getBegin());
    map.put("end", myPageUtils.getEnd());
    
    // 검색 목록 가져오기
    List<BoardDto> boardList = boardMapper.getSearchList(map);
    
    // 뷰로 전달할 데이터
    model.addAttribute("beginNo", total - (page - 1) * display);
    model.addAttribute("boardList", boardList);
    model.addAttribute("sort", sort);
    model.addAttribute("paging", myPageUtils.getPaging(request.getContextPath() + "/board/search.do"
                                                     , ""
                                                     , 20
                                                     , "column=" + column + "&query=" + query));
  }
	
	@Override
  public boolean registerUpload(MultipartHttpServletRequest multipartRequest) {
    
    // Upload_T 테이블에 추가하기(ATTACH_T 삽입을 위해 이걸 가장 먼저 처리해줌)
    String title = multipartRequest.getParameter("title");
    String contents = multipartRequest.getParameter("contents");
    int userNo = Integer.parseInt(multipartRequest.getParameter("userNo"));
    
    UserDto user = new UserDto();
    user.setUserNo(userNo);
    
    BoardDto board = BoardDto.builder()
                          .title(title)
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
  
  @Override
  public int updateHit(int boardNo) {
    return boardMapper.updateHit(boardNo);
  }
  
}
