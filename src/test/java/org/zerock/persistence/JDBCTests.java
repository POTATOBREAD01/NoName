package org.zerock.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

import lombok.extern.log4j.Log4j2;



@Log4j2
public class JDBCTests {
	
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	@Test
	public void testConnection() {
		
		try(Connection con = 
			DriverManager.getConnection(
					"jdbc:mysql://192.168.30.215:3306/elect?serverTimezone=Asia/Seoul","root","1234")){
		log.info(con);
		}catch (Exception e) {
			fail(e.getMessage());
		}
	}
}
