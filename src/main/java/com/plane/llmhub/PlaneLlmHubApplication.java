package com.plane.llmhub;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.plane.llmhub.mapper")
public class PlaneLlmHubApplication {
    public static void main(String[] args) {
        SpringApplication.run(PlaneLlmHubApplication.class, args);
    }
}
