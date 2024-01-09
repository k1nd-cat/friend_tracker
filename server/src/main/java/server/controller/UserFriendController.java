package server.controller;

import java.util.Collection;
import java.util.Collections;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import server.persistence.User;
import server.persistence.UserFriend;
import server.persistence.UserFriendId;
import server.persistence.UserFriendRepository;
import server.persistence.UserRepository;

@RestController
@RequestMapping("friend")
public class UserFriendController {
	
	private final UserRepository userRepository;
	private final UserFriendRepository repository;

	UserFriendController(UserRepository userRepository, UserFriendRepository repository) {
		this.userRepository = userRepository;
		this.repository = repository;
	}

	/**
	 * Invite user friend.
	 */
	@PostMapping("/invite")
	ResponseEntity<?> invite(@RequestHeader String token, @RequestBody User friend) {
		Optional<User> userOpt = userRepository.findByToken(token);
		if (!userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		Optional<User> friendOpt = userRepository.findByLogin(friend.getLogin());
		if (!friendOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.singletonMap("error", "friend not found"));
		}
		friend = friendOpt.get();
		if (userOpt.get().getId() == friend.getId()) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("error", "self invite is not possible"));
		}
		Optional<UserFriend> userFriendOpt = repository.findById(new UserFriendId(userOpt.get().getId(), friend.getId()));
		if (userFriendOpt.isEmpty()) {
			UserFriend userFriend = new UserFriend();
			userFriend.setUserId(userOpt.get().getId());
			userFriend.setFriendId(friend.getId());
			repository.save(userFriend);
		}
		return ResponseEntity.status(HttpStatus.OK).body("{}");
	}

	/**
	 * Accept user friend invitation.
	 */
	@PostMapping("/accept")
	ResponseEntity<?> accept(@RequestHeader String token, @RequestBody User friend) {
		Optional<User> userOpt = userRepository.findByToken(token);
		if (!userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		Optional<User> friendOpt = userRepository.findByLogin(friend.getLogin());
		if (!friendOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.singletonMap("error", "friend not found"));
		}
		friend = friendOpt.get();
		Optional<UserFriend> userFriendOpt = repository.findById(new UserFriendId(friend.getId(), userOpt.get().getId()));
		if (userFriendOpt.isEmpty()) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.singletonMap("error", "invitation not found"));
		}
		UserFriend userFriend = userFriendOpt.get();
		userFriend.setConfirmed(true);
		repository.save(userFriend);
		// create reverse friendship
		userFriendOpt = repository.findById(new UserFriendId(userOpt.get().getId(), friend.getId()));
		if (userFriendOpt.isEmpty()) {
			userFriend = new UserFriend();
			userFriend.setUserId(userOpt.get().getId());
			userFriend.setFriendId(friend.getId());
		} else {
			userFriend = userFriendOpt.get();
		}
		userFriend.setConfirmed(true);
		repository.save(userFriend);
		return ResponseEntity.status(HttpStatus.OK).body("{}");
	}

	/**
	 * Get confirmed friends.
	 */
	@GetMapping("")
	ResponseEntity<?> get(@RequestHeader String token, @RequestParam boolean confirmed) {
		Optional<User> userOpt = userRepository.findByToken(token);
		if (!userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		Collection<User> friends = confirmed ? userRepository.findConfirmedFriends(userOpt.get().getId()) : userRepository.findWaitingFriends(userOpt.get().getId());
		friends.forEach(User::clear);
		return ResponseEntity.status(HttpStatus.OK).body(friends);
	}

}
