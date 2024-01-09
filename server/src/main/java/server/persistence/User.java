package server.persistence;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

/**
 * Entity implementation class for Entity: CalcResult
 */
@Entity
@Table(name = "users")
public class User implements Serializable {

	private static final long serialVersionUID = 1L;

    @Id
    private int id;
    
    private String login;
    private String password;
    private String userName;
    private String token;

	@Transient
    private double lat;
	@Transient
    private double lng;
	@Transient
    private Date updated;
    
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public void setCoords(UserCoords coords) {
		this.lat = coords != null ? coords.getLat() : 0d;
		this.lng = coords != null ? coords.getLng() : 0d;
		this.updated = coords != null ? coords.getUpdated() : null;
	}

	public double getLat() {
		return lat;
	}
	
	public double getLng() {
		return lng;
	}
	
	public Date getUpdated() {
		return updated;
	}
	
	public void clear() {
		setPassword(null);
		setToken(null);
		setId(0);
	}
}
