package com.gdu.semiby4.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gdu.semiby4.dto.AttachDto;
import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.service.BoardService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/board")
@RequiredArgsConstructor
@Controller

public class BoardController {
  
  private final BoardService boardService;
  
  
  @GetMapping("/list.do")
  public String list(HttpServletRequest request, Model model) {
    model.addAttribute("request", request);
    boardService.boardList(model);
    return "board/list";
  }
  
  @GetMapping(value="/attachList.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> attachList(@RequestParam int boardNo)  {
    Map<String, Object> attachList = boardService.getAttachList(boardNo);
    return new ResponseEntity<>(attachList, HttpStatus.OK);
  }

	@GetMapping("/search.do")
	public String search(HttpServletRequest request, Model model) {
		boardService.loadboardSearchList(request, model);
		return "board/list";
	}

	@GetMapping("/write.page") // 내꺼
	public String writePage() {
		return "board/write";
	}

	@PostMapping("/register.do")  // 내꺼
	public String registerBoard(MultipartHttpServletRequest multipartRequest, RedirectAttributes redirectAttributes) {
	  redirectAttributes.addFlashAttribute("inserted", boardService.registerUpload(multipartRequest)); //count를 받아오는게 아니라 되었나 안되었나를 true/false로 받아옴
    return "redirect:/board/list.do";
  }

	@GetMapping("/detail.do")
  public String detail(@RequestParam int boardNo, Model model) {
    model.addAttribute("board", boardService.getBoardByNo(boardNo));
    model.addAttribute("attachList", boardService.getAttachByBoard(boardNo)); // 다운로드를 위해 순지선이 추가한 model(attachList)
    return "board/detail";
  }
  
  @PostMapping(value="/registerComment.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> registerComment(HttpServletRequest request) {
    return ResponseEntity.ok(Map.of("insertCount", boardService.registerComment(request)));
  }
  
  @GetMapping(value="/comment/list.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> commentList(HttpServletRequest request) {
    return ResponseEntity.ok(boardService.getCommentList(request));
  }

  //>>> 다운로드를 위해 추가
  @GetMapping("/download.do") //json 인데 produces를 쓰지 않은 이유는 service에서 이미 작성했기 때문임. 헤더에 applictation/octet-stream을 작성해줬음. 강사님 깃은 controller에는 하나 적어준 버전
  public ResponseEntity<Resource> download(HttpServletRequest request) {
    return boardService.download(request);
  }
  
  @GetMapping("/downloadAll.do")
  public ResponseEntity<Resource> downloadAll(HttpServletRequest request) {
    return boardService.downloadAll(request);
  }
  //<<< 다운로드를 위해 추가
  
  
  // 멀티리스트를 위해 추가
  @GetMapping("/multilist.do")
  public String multiList(Model model) {
    boardService.boardMultiList(model);
    return "board/multilist";
  }
  
  // 멀티리스트를 위해 추가
  @GetMapping("detaillist.do")
  public String detailList(@RequestParam(value="cateNo") String cateNo, HttpServletRequest request, Model model) {
    model.addAttribute("request", request);
    model.addAttribute("cateNo", cateNo);
    boardService.boardDetailList(model);
    
    
    
    return "board/detaillist";
  }
  
  // 삭제를 위해 추가
  @PostMapping("/removeBoard.do")
  public String removeBoard(@RequestParam(value="boardNo", required=false, defaultValue="0") int boardNo
                           , RedirectAttributes redirectAttributes) {
    int removeCount = boardService.removeBoard(boardNo);
    redirectAttributes.addFlashAttribute("removeResult", removeCount == 1 ? '1' : '0');
    return "redirect:/board/list.do";
  }

  @GetMapping("/updateHit.do")
  public String updateHit(@RequestParam int boardNo) {
		
    return "redirect:/board/detail.do?boardNo=" + boardNo;
  }
  
  // 게시글 수정 (지희)
  @PostMapping("/edit.do")
  public String edit(@RequestParam int boardNo, Model model) {
    model.addAttribute("board", boardService.getBoardByNo(boardNo));
    return "board/edit";
  }
  
  // 게시글 수정 (지희)
  @PostMapping("/modify.do")
  public String modify(BoardDto board, RedirectAttributes redirectAttributes) {
    redirectAttributes.addFlashAttribute("updateCount", boardService.modifyBoard(board));
 // return "redirect:/board/list.do";
    return "redirect:/board/detail.do?boardNo=" + board.getBoardNo();
  }
  
  @PostMapping(value="/removeAttach.do", produces="application/json" )
  public ResponseEntity<Map<String, Object>> removeAttach(@RequestBody AttachDto attach) {
    return boardService.removeAttach(attach.getAttachNo());
  }

}
