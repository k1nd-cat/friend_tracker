package server;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
//import org.springframework.core.io.ClassPathResource;
//import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Component;

import java.sql.Connection;

import javax.sql.DataSource;

@Component
public class InitializeData {

    @Autowired
    private DataSource dataSource;

    @EventListener(ApplicationReadyEvent.class)
    public void loadData() {
		Connection conn = null;
    	try {
    		conn = dataSource.getConnection();
    		/*
    		conn.createStatement().execute("drop table if exists users");    		
    		conn.createStatement().execute("drop table if exists user_friend");    		
    		conn.createStatement().execute("drop table if exists user_coords");    		
    		*/
    		conn.createStatement().execute("create table if not exists users (id INTEGER NOT NULL AUTO_INCREMENT, login CHARACTER VARYING(50), password CHARACTER VARYING(500), user_name CHARACTER VARYING(500), token CHARACTER VARYING(500), CONSTRAINT users_pkey PRIMARY KEY (id), CONSTRAINT users_login UNIQUE (login))");
    		conn.createStatement().execute("create table if not exists user_friend (user_id INTEGER NOT NULL, friend_id INTEGER NOT NULL, confirmed boolean DEFAULT false, CONSTRAINT user_friend_pkey PRIMARY KEY (user_id, friend_id))");
    		conn.createStatement().execute("create table if not exists user_coords (user_id INTEGER NOT NULL, lat DOUBLE NOT NULL, lng DOUBLE NOT NULL, updated TIMESTAMP NOT NULL, CONSTRAINT user_coords_pkey PRIMARY KEY (user_id))");
    	} catch (Exception exc) {
    		throw new RuntimeException(exc);
		} finally {
			if (conn != null) try {
				conn.close();
			} catch (Exception exc2) {}
		}
//      ResourceDatabasePopulator resourceDatabasePopulator = new ResourceDatabasePopulator(false, false, "UTF-8", new ClassPathResource("create_users.sql"));
//      resourceDatabasePopulator.execute(dataSource);
    }
}