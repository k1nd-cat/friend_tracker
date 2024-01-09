package server.persistence;

import java.util.Collection;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface UserCoordsRepository extends JpaRepository<UserCoords, Integer> {
	
	@Query(value = "SELECT c.* FROM user_coords c join user_friend f on c.user_id = f.friend_id WHERE f.user_id = ?1 and f.confirmed = true", nativeQuery = true)
	Collection<UserCoords> findAllCoords(int userId);

}