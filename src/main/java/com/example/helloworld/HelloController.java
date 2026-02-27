package com.example.helloworld;

import com.example.helloworld.repository.MessageRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

@RestController
@Tag(name = "Hello", description = "Hello World API")
public class HelloController {

    private final DataSource dataSource;
    private final MessageRepository messageRepository;

    public HelloController(DataSource dataSource, MessageRepository messageRepository) {
        this.dataSource = dataSource;
        this.messageRepository = messageRepository;
    }

    @Operation(summary = "Get hello message", description = "Returns a hello message")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully returned hello message")
    })
    @GetMapping("/")
    public String hello() {
        long messageCount = messageRepository.count();
        String dbStatus = checkDatabase();
        return String.format("Hello, Automatic Deploy! | DB: %s | Messages: %d", dbStatus, messageCount);
    }

    private String checkDatabase() {
        try (Connection conn = dataSource.getConnection()) {
            return conn.isValid(2) ? "Connected" : "Disconnected";
        } catch (SQLException e) {
            return "Error: " + e.getMessage();
        }
    }
}
