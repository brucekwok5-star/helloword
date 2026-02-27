package com.example.helloworld;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(properties = {
    "spring.main.banner-mode=off",
    "logging.level.root=WARN"
})
class HelloworldApplicationTests {

    @Test
    void contextLoads() {
        // Verify application context loads successfully
    }

    @Test
    void applicationStarts() {
        // Verify application starts without errors
    }
}
