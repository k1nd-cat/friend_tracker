package server.controller;

import java.util.Base64;
import java.util.Collections;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import server.persistence.User;
import server.persistence.UserRepository;
import server.utils.Security;

@RestController
@RequestMapping("user")
public class UserController {
	
	private final UserRepository repository;

	UserController(UserRepository repository) {
		this.repository = repository;
	}

	/**
	 * Register and create token.
	 */
	@PostMapping("/register")
	ResponseEntity<?> register(@RequestBody User user) {
		String login = user.getLogin(), password = user.getPassword();
		if (!StringUtils.hasLength(StringUtils.trimAllWhitespace(login)) || !StringUtils.hasLength(StringUtils.trimAllWhitespace(password)) || !StringUtils.hasLength(StringUtils.trimAllWhitespace(user.getUserName()))) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("error", "no login and / or password and / or user name"));
		}
		Optional<User> userOpt = repository.findByLogin(login);
		if (userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("error", "user already exists"));
		}
		password = Security.getSecurity().getPasswordHash(password);
		user.setPassword(password);
		String token = Base64.getUrlEncoder().encodeToString(new String(login + System.currentTimeMillis()).getBytes());
		user.setToken(token);
		try {
			repository.save(user);
		} catch (Exception exc) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("error", "user already exists"));
		}
		user.setPassword(null);
		return ResponseEntity.status(HttpStatus.OK).body(user);
	}

	/**
	 * Login and create token.
	 */
	@PostMapping("/login")
	ResponseEntity<?> login(@RequestBody User user) {
		String login = user.getLogin(), password = user.getPassword();
		if (!StringUtils.hasLength(StringUtils.trimAllWhitespace(login)) || !StringUtils.hasLength(StringUtils.trimAllWhitespace(password))) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("error", "no login and / or password"));
		}
		Optional<User> userOpt = repository.findByLogin(login);
		if (!userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		user = userOpt.get();
		Security security = Security.getSecurity();
		if (!security.checkPassword(user.getPassword(), password)) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "password is not correct"));
		}
		String token = Base64.getUrlEncoder().encodeToString(new String(login + System.currentTimeMillis()).getBytes());
		user.setToken(token);
		repository.save(user);
		user.setPassword(null);
		return ResponseEntity.status(HttpStatus.OK).body(user);
	}
	
	/**
	 * Logout.
	 */
	@PostMapping("/logout")
	void logout(@RequestHeader String token) {
		if (!StringUtils.hasLength(StringUtils.trimAllWhitespace(token))) return;
		Optional<User> userOpt = repository.findByToken(token);
		if (userOpt.isEmpty()) return;
		userOpt.get().setToken(null);
		repository.save(userOpt.get());
	}
	
	/**
	 * Check token. 
	 */
	@PostMapping("/check")
	ResponseEntity<?> check(@RequestHeader String token) {
		if (!StringUtils.hasLength(StringUtils.trimAllWhitespace(token))) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		Optional<User> userOpt = repository.findByToken(token);
		if (!userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		return ResponseEntity.status(HttpStatus.OK).build();
	}

}
