package server.persistence;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserFriendRepository extends JpaRepository<UserFriend, UserFriendId> {
	
	List<UserFriend> findByUserIdAndConfirmed(int userId, boolean confirmed);
	
}