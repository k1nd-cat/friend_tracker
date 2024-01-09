package server.controller;

import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import server.persistence.User;
import server.persistence.UserCoords;
import server.persistence.UserCoordsRepository;
import server.persistence.UserRepository;

@RestController
@RequestMapping("coords")
public class UserCoordsController {
	
	private final UserRepository userRepository;
	private final UserCoordsRepository repository;

	UserCoordsController(UserRepository userRepository, UserCoordsRepository repository) {
		this.userRepository = userRepository;
		this.repository = repository;
	}

	/**
	 * Save user coords.
	 */
	@PostMapping("")
	ResponseEntity<?> saveCoords(@RequestHeader String token, @RequestBody UserCoords userCoords) {
		Optional<User> userOpt = userRepository.findByToken(token);
		if (!userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		int userId = userOpt.get().getId();
		Optional<UserCoords> userCoordsOpt = repository.findById(userId);
		if (userCoordsOpt.isPresent()) {
			UserCoords dbUserCoords = userCoordsOpt.get();
			dbUserCoords.setLat(userCoords.getLat());
			dbUserCoords.setLng(userCoords.getLng());
			userCoords = dbUserCoords;
		} else {
			userCoords.setUserId(userId);
		}
		userCoords.setUpdated(new Date());
		repository.save(userCoords);
		return ResponseEntity.status(HttpStatus.OK).body("{}");
	}

	/**
	 * Get friends coords.
	 */
	@GetMapping("")
	ResponseEntity<?> getCoords(@RequestHeader String token) {
		Optional<User> userOpt = userRepository.findByToken(token);
		if (!userOpt.isPresent()) {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Collections.singletonMap("error", "user not found"));
		}
		int userId = userOpt.get().getId();
		Collection<UserCoords> friendCoords = repository.findAllCoords(userId);
		if (friendCoords.isEmpty()) {
			return ResponseEntity.status(HttpStatus.OK).body("[]");
		}
		Collection<User> friends = userRepository.findConfirmedFriends(userId);
		if (friends.isEmpty()) {
			return ResponseEntity.status(HttpStatus.OK).body("[]");
		}
		Map<Integer, UserCoords> friendCoordsByUserId = friendCoords.stream().collect(Collectors.toMap(UserCoords::getUserId, Function.identity()));
		friends = friends.stream().filter(friend -> friendCoordsByUserId.containsKey(friend.getId())).collect(Collectors.toList());
		friends.forEach(friend -> {
			friend.setCoords(friendCoordsByUserId.get(friend.getId()));
			friend.clear();
		});
		return ResponseEntity.status(HttpStatus.OK).body(friends);
	}

}
