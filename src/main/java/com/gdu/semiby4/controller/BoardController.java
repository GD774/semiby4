package com.gdu.semiby4.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
  public ResponseEntity<Map<String, Object>> attachList(@RequestParam int boardNo) {
    return boardService.getAttachList(boardNo);
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
    boardService.updateHit(boardNo);
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
  
  @GetMapping("/updateHit.do")
  public String updateHit(@RequestParam int boardNo) {
    return "redirect:/board/detail.do?boardNo=" + boardNo;
  }
  
  @PostMapping("/edit.do")
  public String edit(@RequestParam int boardNo, Model model) {
    model.addAttribute("board", boardService.getBoardByNo(boardNo));
    return "board/edit";
  }
  
  @PostMapping("/modify.do")
  public String modify(BoardDto board, RedirectAttributes redirectAttributes) {
    redirectAttributes
      .addAttribute("boardNo", board.getBoardNo())
      .addFlashAttribute("modifyResult", boardService.modifyBoard(board) == 1 ? "수정되었습니다." : "수정을 하지 못했습니다.");
    return "redirect:/board/detail.do?boardNo={boardNo}";
  }
  
  
  @PostMapping(value="/addAttach.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> addAttach(MultipartHttpServletRequest multipartRequest) throws Exception {
    return boardService.addAttach(multipartRequest);
  }
  
  @PostMapping(value="/removeAttach.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> removeAttach(@RequestBody AttachDto attach) {
    return boardService.removeAttach(attach.getAttachNo());
  }

}
