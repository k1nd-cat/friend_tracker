package server.persistence;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Entity implementation class for Entity: UserCoords
 */
@Entity
@Table(name = "user_coords")
public class UserCoords implements Serializable {

	private static final long serialVersionUID = 1L;

    @Id
    private int userId;
    
    private double lat;
    private double lng;
    private Date updated;
    
	public int getUserId() {
		return userId;
	}
	
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public double getLat() {
		return lat;
	}
	
	public void setLat(double lat) {
		this.lat = lat;
	}
	
	public double getLng() {
		return lng;
	}
	
	public void setLng(double lng) {
		this.lng = lng;
	}
	
	public Date getUpdated() {
		return updated;
	}
	
	public void setUpdated(Date updated) {
		this.updated = updated;
	}
    
}
