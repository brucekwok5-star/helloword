package com.example.helloworld;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class HelloControllerIntegrationTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void helloEndpoint_shouldReturnHelloMessage() {
        ResponseEntity<String> response = restTemplate.getForEntity("/", String.class);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("Hello, Automatic Deploy!", response.getBody());
    }

    @Test
    void helloEndpoint_shouldReturn200() {
        ResponseEntity<String> response = restTemplate.getForEntity("/", String.class);
        assertTrue(response.getStatusCode().is2xxSuccessful());
    }

    @Test
    void healthEndpoint_shouldReturnUp() {
        ResponseEntity<String> response = restTemplate.getForEntity("/actuator/health", String.class);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().contains("UP"));
    }

    @Test
    void prometheusEndpoint_shouldReturnMetrics() {
        ResponseEntity<String> response = restTemplate.getForEntity("/actuator/prometheus", String.class);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().contains("jvm_"));
    }

    @Test
    void infoEndpoint_shouldReturnInfo() {
        ResponseEntity<String> response = restTemplate.getForEntity("/actuator/info", String.class);
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }
}
