package Fschool_se1948.edu.service;

import Fschool_se1948.edu.dto.request.LoginRequest;
import Fschool_se1948.edu.dto.request.RegisterRequest;
import Fschool_se1948.edu.dto.response.AuthResponse;
import Fschool_se1948.edu.entity.RefreshToken;
import Fschool_se1948.edu.repository.RefreshTokenRepository;
import Fschool_se1948.edu.repository.RoleRepository;
import Fschool_se1948.edu.repository.UserRepository;
import Fschool_se1948.edu.security.JwtService;
import Fschool_se1948.edu.entity.Role;
import Fschool_se1948.edu.entity.RoleName;
import Fschool_se1948.edu.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;

@Service
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final UserRepository users;
    private final RoleRepository roles;
    private final RefreshTokenRepository refreshTokens;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final long refreshTtlSeconds;
    private final SecureRandom secureRandom = new SecureRandom();

    public AuthService(AuthenticationManager authenticationManager, UserRepository users, RoleRepository roles,
                       RefreshTokenRepository refreshTokens, PasswordEncoder passwordEncoder, JwtService jwtService,
                       @Value("${app.jwt.refresh-token-ttl-seconds}") long refreshTtlSeconds) {
        this.authenticationManager = authenticationManager;
        this.users = users;
        this.roles = roles;
        this.refreshTokens = refreshTokens;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.refreshTtlSeconds = refreshTtlSeconds;
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        String email = normalizeEmail(request.email());
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(email, request.password()));
        User user = users.findByEmailIgnoreCase(email).orElseThrow();
        return issueTokens(user);
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        String email = normalizeEmail(request.email());
        if (users.existsByEmailIgnoreCase(email)) {
            throw new EmailAlreadyRegisteredException();
        }
        Role userRole = roles.findByName(RoleName.USER).orElseGet(() -> roles.save(new Role(RoleName.USER)));
        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setName(request.name().trim());
        user.getRoles().add(userRole);
        return issueTokens(users.save(user));
    }

    @Transactional
    public AuthResponse refresh(String rawToken) {
        RefreshToken stored = refreshTokens.findByTokenHash(hash(rawToken))
                .orElseThrow(InvalidRefreshTokenException::new);
        if (stored.isRevoked() || !stored.getExpiresAt().isAfter(Instant.now())) {
            throw new InvalidRefreshTokenException();
        }
        stored.setRevoked(true);
        return issueTokens(stored.getUser());
    }

    @Transactional
    public void logout(String rawToken) {
        refreshTokens.findByTokenHash(hash(rawToken)).ifPresent(token -> {
            token.setRevoked(true);
            refreshTokens.save(token);
        });
    }

    private AuthResponse issueTokens(User user) {
        byte[] bytes = new byte[64];
        secureRandom.nextBytes(bytes);
        String rawRefreshToken = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        refreshTokens.save(new RefreshToken(hash(rawRefreshToken), user,
                Instant.now().plusSeconds(refreshTtlSeconds)));
        var userResponse = new AuthResponse.UserResponse(user.getId(), user.getEmail(), user.getName(),
                user.getRoles().stream().map(role -> role.getName().name()).toList());
        return new AuthResponse(jwtService.createAccessToken(user), rawRefreshToken, "Bearer",
                jwtService.getAccessTtlSeconds(), userResponse);
    }

    private String normalizeEmail(String email) { return email.trim().toLowerCase(java.util.Locale.ROOT); }

    private String hash(String token) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(token.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 is unavailable", e);
        }
    }
}
