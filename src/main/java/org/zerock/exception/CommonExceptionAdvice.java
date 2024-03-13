package org.zerock.exception;

import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
@Log4j2
public class CommonExceptionAdvice {

    /* 특정 예외 처리 - WAS 내부에서 발생하는 404 에러 처리 */
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException ex) {

        return "custom404";
    }


    /* 일반적인 예외 처리 */
    @ExceptionHandler(Exception.class)
    public String except(Exception ex, Model model) {

        log.error("Exception ......." + ex.getMessage());
        model.addAttribute("exception", ex);
        log.error(model);

        return "error_page";
    }

}
