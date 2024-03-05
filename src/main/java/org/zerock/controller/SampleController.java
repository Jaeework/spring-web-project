package org.zerock.controller;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.zerock.domain.SampleDTO;
import org.zerock.domain.SampleDTOList;

import java.util.ArrayList;
import java.util.Arrays;

@Controller
@RequestMapping("/sample/*")
@Log4j2
public class SampleController {

    /* 여러 개의 객체 타입을 처리하는 경우 */
    @GetMapping("/ex02Bean")
    public String ex02Bean(SampleDTOList list) {

        log.info("list dtos : " + list);

        return "ex02Bean";
    }

    /* 동일한 이름의 파라미터가 여러 개 전달되는 경우 : 리스트, 배열 처리 */
    @GetMapping("/ex02List")
    public String ex02List(@RequestParam("ids")ArrayList<String> ids) {

        log.info("ids : " + ids);

        return "ex02List";
    }

    @GetMapping("/ex02Array")
    public String ex02Array(@RequestParam("ids")String[] ids) {

        log.info("array ids : " + Arrays.toString(ids));

        return "ex02Array";
    }

    /* 기본 자료형이나 문자열 등 이용시, @RequestParam 이용해 파라미터의 타입만을 맞게 선언 */
    @GetMapping("/ex02")
    public String ex02(@RequestParam("name") String name, @RequestParam("age") int age) {

        log.info("name : " + name);
        log.info("age : " + age );

        return "ex02";
    }

    /* 파라미터의 수집 - 파라미터 타입에 따라 자동으로 변환*/
    @GetMapping("/ex01")
    public String ex01(SampleDTO dto) {

        log.info("" + dto);

        return "ex01";
    }

    @RequestMapping(value="/basic", method = {RequestMethod.GET, RequestMethod.POST})
    public void basicGet() {

        log.info("basic get...............");

    }

    @GetMapping("/basicOnlyGet")
    public void basicGet2() {

        log.info("basic get only get.................");

    }

    @RequestMapping("")
    public void basic() {

        log.info("basic...................");

    }

    @GetMapping("/doA")
    public void doA() {

        log.info("doA called.............");
        log.info("-----------------------");
    }
}
