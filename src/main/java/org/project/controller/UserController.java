
package org.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.zerock.security.domain.CustomUser;

import java.util.List;

import org.project.controller.UserController;
import org.project.domain.MemberVO;
import org.project.domain.UserVO;
import org.project.mapper.UserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/*")
@AllArgsConstructor
public class UserController {
	
	private static final Logger log = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserMapper userMapper;
	
	@GetMapping("/chargecheck")
public String view(Model model) {
		
		// 현재 로그인된 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		Object principal = authentication.getPrincipal();

		// 비로그인 상태일 경우 처리
		if (!(principal instanceof CustomUser)) {
			model.addAttribute("loginRequired", true);
			return "chargecheck"; // JS 등에서 접근 차단
		}

		// 로그인 사용자 정보에서 userid 가져오기
		CustomUser customUser = (CustomUser) principal;
		MemberVO member = customUser.getMember();
		String userid = member.getUserid();

		// Mapper 호출 및 결과 처리
		List<UserVO> list = userMapper.view(userid);
		model.addAttribute("list", list); 
		
		return "chargecheck";
	}

}
