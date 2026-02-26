package com.example.helloworld;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Hello", description = "Hello World API")
public class HelloController {

    @Operation(summary = "Get hello message", description = "Returns a hello message")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully returned hello message")
    })
    @GetMapping("/")
    public String hello() {
        return "Hello, Automatic Deploy!";
    }
}
