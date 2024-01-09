package server.persistence;

import java.io.Serializable;

/**
 * Entity implementation class for Entity: CalcResult
 */
public class UserFriendId implements Serializable {

	private static final long serialVersionUID = 1L;

    private int userId;
    private int friendId;

    public UserFriendId() {}
    
    public UserFriendId(int userId, int friendId) {
		this.userId = userId;
		this.friendId = friendId;
    }
    
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
    
}
