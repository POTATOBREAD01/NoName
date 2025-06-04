package org.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.project.controller.UserController;

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
	public String view(HttpSession session, Model model) {
		
		// 임시로 session userno에 값 저장 시켜놓기 (로그인 구현 후 삭제)
		session.setAttribute("userno", 3L);
		
		// session에 userno 값이 없을 때 페이지 이동 막아놓기
		Object usernoObj = session.getAttribute("userno");

		if (usernoObj == null) {
	        model.addAttribute("loginRequired", true);
	        return "chargecheck"; // 동일 JSP로 이동, JS에서 막아줌
	    }
		
		Long userno = (Long) session.getAttribute("userno");
		List<UserVO> list = userMapper.view(userno);
		model.addAttribute("list", list);
		return "chargecheck";

	}
}
