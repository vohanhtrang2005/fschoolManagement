package Fschool_se1948.edu.controller;

import Fschool_se1948.edu.dto.response.MessageResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(BadCredentialsException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    MessageResponse badCredentials() { return new MessageResponse("Invalid email or password"); }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    MessageResponse invalidRequest() { return new MessageResponse("Invalid request data"); }

    @ExceptionHandler(ResponseStatusException.class)
    org.springframework.http.ResponseEntity<MessageResponse> statusException(ResponseStatusException ex) {
        return org.springframework.http.ResponseEntity.status(ex.getStatusCode())
                .body(new MessageResponse(ex.getReason() == null ? "Request failed" : ex.getReason()));
    }
}
