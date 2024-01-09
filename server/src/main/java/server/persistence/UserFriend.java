package server.persistence;

import java.io.Serializable;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

/**
 * Entity implementation class for Entity: UserFriend
 */
@Entity
@Table(name = "user_friend")
@IdClass(UserFriendId.class)
public class UserFriend implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
    private int userId;
    
	@Id
    private int friendId;

    private boolean confirmed;
	
	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getFriendId() {
		return friendId;
	}

	public void setFriendId(int friendId) {
		this.friendId = friendId;
	}

	public boolean isConfirmed() {
		return confirmed;
	}

	public void setConfirmed(boolean confirmed) {
		this.confirmed = confirmed;
	}
	
}
