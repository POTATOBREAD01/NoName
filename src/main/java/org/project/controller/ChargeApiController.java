package org.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.project.domain.ChargeVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@Log4j
@Controller
@RequestMapping("/*")
@AllArgsConstructor
public class ChargeApiController {
private final String API_KEY = "N4eVLJia24G8FILFhuSldJ65E0nmIcd0j29P7Y9r";
	

	private static final Logger log = LoggerFactory.getLogger(ChargeApiController.class);

	@GetMapping("/api/calculateCharges")
	@ResponseBody
	public ChargeVO calculateCharges(@RequestParam int usage) {
	    ChargeVO vo = new ChargeVO();
	    int basic, useCharge;
	    
	    if (usage <= 200) {
	        basic = 730;
	        useCharge = usage * 97;
	    } else if (usage <= 400) {
	        basic = 1260;
	        useCharge = usage * 166;
	    } else {
	        basic = 6060;
	        useCharge = usage * 234;
	    }

	    int ceCharge = (usage / 10) * 73;
	    int fcAdjustment = usage * 5;
	    int sumCharge = basic + useCharge + ceCharge + fcAdjustment;
	    int fund = (sumCharge / 1000) * 36;
	    int addedTax = Math.round(sumCharge / 10.0f);
	    int totalCharge = sumCharge + addedTax + fund;

	    vo.setBasic(basic);
	    vo.setUseCharge(useCharge);
	    vo.setCeCharge(ceCharge);
	    vo.setFcAdjustment(fcAdjustment);
	    vo.setSumCharge(sumCharge);
	    vo.setFund(fund);
	    vo.setAddedTax(addedTax);
	    vo.setTotalCharge(totalCharge);

	    return vo;
	}	
	
	@GetMapping("/api/publicPowerUsage")
	@ResponseBody
	public Map<String, Object> getPowerUsage(@RequestParam int month, @RequestParam String address) {
        String monthStr = String.format("%02d", month); // 1월 -> "01" 형태로 변환
        String metroCd = getMetroCd(address);
        String regionName = getRegionName(address);
        
        String url = "https://bigdata.kepco.co.kr/openapi/v1/powerUsage/houseAve.do"
                   + "?year=2024&month="+monthStr
                   + "&metroCd="+metroCd
                   + "&apiKey=" + API_KEY
                   + "&returnType=json";

        RestTemplate restTemplate = new RestTemplate();
        
        Map<String, Object> responseMap = new HashMap<>();
        try {
            // API 호출 결과를 문자열로 받아서 그대로 리턴
        	String rawJson = restTemplate.getForObject(url, String.class);
            // Jackson 사용해서 JSON 파싱 (권장)
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(rawJson);
            JsonNode dataNode = root.get("data");

            responseMap.put("regionName", regionName);
            responseMap.put("data", dataNode);
            return responseMap;
        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("regionName", regionName);
            responseMap.put("data", List.of());
            return responseMap;
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
	
	private String getRegionName(String address) {
	    if (address.contains("서울")) return "서울";
	    if (address.contains("부산")) return "부산";
	    if (address.contains("대구")) return "대구";
	    if (address.contains("인천")) return "인천";
	    if (address.contains("광주")) return "광주";
	    if (address.contains("대전")) return "대전";
	    if (address.contains("울산")) return "울산";
	    if (address.contains("세종")) return "세종";
	    if (address.contains("경기")) return "경기";
	    if (address.contains("강원")) return "강원";
	    if (address.contains("충북")) return "충북";
	    if (address.contains("충남")) return "충남";
	    if (address.contains("전북")) return "전북";
	    if (address.contains("전남")) return "전남";
	    if (address.contains("경북")) return "경북";
	    if (address.contains("경남")) return "경남";
	    if (address.contains("제주")) return "제주";
	    return "세종";
	}
}
