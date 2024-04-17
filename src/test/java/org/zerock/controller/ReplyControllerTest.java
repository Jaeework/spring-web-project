package org.zerock.controller;

import com.google.gson.Gson;
import lombok.Setter;
import lombok.extern.log4j.Log4j2;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.zerock.domain.ReplyVO;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml",
        "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j2
public class ReplyControllerTest {

    @Setter(onMethod_ = @Autowired)
    private WebApplicationContext ctx;

    private MockMvc mockMvc;

    @Before
    public void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
    }

    @Test
    public void testRegister() throws Exception{

        ReplyVO vo = new ReplyVO();
        vo.setBno(156L);
        vo.setReply("this is the reply");
        vo.setReplyer("replyer00");

        String jsonStr = new Gson().toJson(vo);

        log.info(jsonStr);

        mockMvc.perform(post("/replies/new")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonStr))
                .andExpect(status().is(200))
                .andExpect(content().contentTypeCompatibleWith(MediaType.TEXT_PLAIN_VALUE));
    }

    @Test
    public void testGetList() throws Exception {

        mockMvc.perform(get("/replies/pages/{bno}/{page}", 155L, 1))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andDo(print());
    }

    @Test
    public void testGet() throws Exception {

        mockMvc.perform(get("/replies/{rno}", 2L))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andDo(print());
    }

    @Test
    public void testRemove() throws Exception {

        mockMvc.perform(delete("/replies/{rno}", 26L))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.TEXT_PLAIN_VALUE))
                .andDo(print());
    }

    @Test
    public void testModify() throws Exception {

        ReplyVO vo = new ReplyVO();
        vo.setRno(30L);
        vo.setReply("this is modified reply");

        String jsonStr = new Gson().toJson(vo);

        log.info(jsonStr);

        mockMvc.perform(put("/replies/{rno}", 30L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(jsonStr))
                .andExpect(status().is(200))
                .andExpect(content().contentTypeCompatibleWith(MediaType.TEXT_PLAIN_VALUE));

    }
}