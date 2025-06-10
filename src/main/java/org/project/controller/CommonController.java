package org.project.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
public class CommonController {
	
	// 권한 없음 매핑
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		log.info("access Denied : " + auth);
		model.addAttribute("msg", "Access Denied");
	}
	
	// 커스텀 로그인 매핑
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		
		log.info("error: "+error);
		log.info("logout: "+logout);
		
		if(error!=null) {
			model.addAttribute("error", "아이디 또는 비밀번호를 재확인해주세요.");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "로그아웃이 완료되었습니다.");
		}
	}
	
	// 로그아웃매핑
	@GetMapping("/customLogout")
	public void logoutGet() {
		log.info("custom logout");
	}
}
