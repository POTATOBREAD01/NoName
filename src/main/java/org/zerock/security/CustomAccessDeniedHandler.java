package org.zerock.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.log4j.Log4j2;

@Log4j2
public class CustomAccessDeniedHandler implements AccessDeniedHandler{
	// 권환이 없을때 핸들러
	@Override
	public void handle(HttpServletRequest request,
			HttpServletResponse response, AccessDeniedException accessException)
			throws IOException, ServletException {
		
		log.error("Access Denied Handler");
		
		log.error("Redirect");
		
		response.sendRedirect("/accessError");
	}
}
