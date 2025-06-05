package org.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
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
	
	private final String API_KEY = "N4eVLJia24G8FILFhuSldJ65E0nmIcd0j29P7Y9r";
	
	@GetMapping("/api/publicPowerUsage")
	@ResponseBody
	public String getPowerUsage(@RequestParam int month, @RequestParam String address) {
        String monthStr = String.format("%02d", month); // 1월 -> "01" 형태로 변환
        String metroCd = getMetroCd(address);
        log.info("Received month: " + month);
        log.info("MetroCd for address {} : {}", address, metroCd);
        String url = "https://bigdata.kepco.co.kr/openapi/v1/powerUsage/houseAve.do"
                   + "?year=2024&month="+monthStr
                   + "&metroCd="+metroCd
                   + "&apiKey=" + API_KEY
                   + "&returnType=json";

        RestTemplate restTemplate = new RestTemplate();

        try {
            // API 호출 결과를 문자열로 받아서 그대로 리턴
            String response = restTemplate.getForObject(url, String.class);
            return response;
        } catch (Exception e) {
            e.printStackTrace();
            // 실패 시 빈 JSON 반환 
            return "{\"data\":[]}";
        }
    }
	
	private String getMetroCd(String address) {
	    if (address.contains("강원")) return "51";
	    if (address.contains("경기")) return "41";
	    if (address.contains("경남")) return "48";
	    if (address.contains("경북")) return "47";
	    if (address.contains("광주")) return "29";
	    if (address.contains("대구")) return "27";
	    if (address.contains("대전")) return "30";
	    if (address.contains("부산")) return "26";
	    if (address.contains("서울")) return "11";
	    if (address.contains("세종")) return "36";
	    if (address.contains("울산")) return "31";
	    if (address.contains("인천")) return "28";
	    if (address.contains("전남")) return "46";
	    if (address.contains("전북")) return "52";
	    if (address.contains("제주")) return "50";
	    if (address.contains("충남")) return "44";
	    if (address.contains("충북")) return "43";
	    return "36"; // 기본값
	}
}
