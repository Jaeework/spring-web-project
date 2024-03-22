package org.zerock.controller;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.zerock.service.BoardService;

@Controller
@Log4j2
@RequestMapping("/board/*")
@AllArgsConstructor // 생성자 만들지 않을 경우, BoardService 에 `@Setter` 또는 `@Autowired` 처리
public class BoardController {

    private BoardService service;

    @GetMapping("/list")
    public void list(Model model) {

        log.info("list");
        model.addAttribute("list", service.getList());
    }

}
