package org.project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j2;

@Log4j2
@RequestMapping("/login")
@Controller
public class LoginController {

	@GetMapping("/all")
	public void doAll() {
		log.info("do all..............");
	}
	
	@GetMapping("/member")
	public void doMember() {
		log.info("login member..............");
	}
	
	@GetMapping("/admin")
	public void doAdmin() {
		log.info("login admin..............");
	}
}
