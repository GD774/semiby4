package com.gdu.semiby4.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MvcController {

  @GetMapping(value={"/", "/main.page"})
  public String welcome() {

    return "redirect:board/multilist.do";
  }

}
