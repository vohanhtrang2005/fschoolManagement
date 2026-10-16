package Fschool_se1948.edu.dto.response;

import java.util.List;

public record AuthResponse(
        String accessToken,
        String refreshToken,
        String tokenType,
        long expiresIn,
        UserResponse user) {
    public record UserResponse(Long id, String email, String name, List<String> roles) {
    }
}
