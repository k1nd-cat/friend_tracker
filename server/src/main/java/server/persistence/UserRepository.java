package server.persistence;

import java.util.Collection;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface UserRepository extends JpaRepository<User, Integer> {
	
	Optional<User> findByLogin(String login);
	
	Optional<User> findByToken(String token);
	
	@Query(value = "SELECT u.* FROM users u join user_friend f on u.id = f.friend_id WHERE f.user_id = ?1 and f.confirmed = true order by u.user_name", nativeQuery = true)
	Collection<User> findConfirmedFriends(int userId);
	
	@Query(value = "SELECT u.* FROM users u join user_friend f on u.id = f.user_id WHERE f.friend_id = ?1 and f.confirmed = false order by u.user_name", nativeQuery = true)
	Collection<User> findWaitingFriends(int userId);
	
}