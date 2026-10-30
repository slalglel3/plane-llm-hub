package com.plane.llmhub.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SpaForwardController {

    @RequestMapping(value = { "/", "/models/**", "/explore/**" })
    public String forward() {
        return "forward:/index.html";
    }
}
