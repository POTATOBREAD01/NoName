package org.project.controller;

import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

import org.project.domain.MemberVO;
import org.project.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

@Controller
public class SelectController {

    @Autowired
    private MemberMapper memberMapper;

    // 1. 고객 선택 첫 화면 (빈 리스트)
    @GetMapping("/selectCustomer.do")
    public String selectMember(Model model) {
        model.addAttribute("members", Collections.emptyList());
        return "select";
    }

    // 2. 고객 검색 처리
    @GetMapping("/searchCustomer.do")
    public String searchMember(@RequestParam("userno") String userno, Model model) {
        if (userno == null || userno.trim().isEmpty()) {
            model.addAttribute("members", Collections.emptyList());
            model.addAttribute("message", "고객번호를 입력해주세요.");
            return "select";
        }

        MemberVO member = memberMapper.searchCustomerByUserno(userno);
        
        if (member == null) {
        	model.addAttribute("members", Collections.emptyList());
            model.addAttribute("message", "일치하는 회원이 없습니다.");
        } else {
            model.addAttribute("members", Collections.singletonList(member)); // ✅ 리스트로 감싸기
        }
        return "select";
    }

    // 3. 고객 삭제
    @PostMapping("/deleteCustomer.do")
    public String deleteMember(@RequestParam("userid") String userid) {
        // 메서드 이름은 customer로 유지
        memberMapper.deleteCustomer(userid);
        return "redirect:/selectCustomer.do";
    }

    // 4. 증명서 페이지로 이동
    @GetMapping("/proof.do")
    public String showProofPage(@RequestParam(value = "userid", required = false) String userid, Model model) {
        if (userid == null || userid.isEmpty()) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated()) {
                userid = auth.getName();
            }
        }

        if (userid == null || userid.isEmpty()) {
            model.addAttribute("message", "회원 아이디가 누락되었습니다.");
            return "error";
        }

        MemberVO member = memberMapper.getCustomerByUserid(userid);
        if (member == null) {
            model.addAttribute("message", "해당 회원을 찾을 수 없습니다.");
            return "error";
        }

        List<Integer> realCharges = new ArrayList<>();
        int totalAmount = 0;

        if (member.getMonthlyUsage() != null) {
            List<Integer> usageList = member.getMonthlyUsage();
            int currentMonth = java.time.LocalDate.now().getMonthValue();

            for (int i = 0; i < usageList.size(); i++) {
                if (i + 1 > currentMonth) break;  // 현재월까지만

                int use = usageList.get(i);
                int basic = 0, useCharge = 0;

                if (use <= 200) {
                    basic = 730;
                    useCharge = use * 97;
                } else if (use <= 400) {
                    basic = 1260;
                    useCharge = use * 166;
                } else {
                    basic = 6060;
                    useCharge = use * 234;
                }

                int ceCharge = (use / 10) * 73;
                int fcAdjustment = use * 5;
                int sumCharge = basic + useCharge + ceCharge + fcAdjustment;
                int fund = (sumCharge / 1000) * 36;
                int addedTax = Math.round(sumCharge / 10f);
                int totalCharge = sumCharge + addedTax + fund;

                realCharges.add(totalCharge);
                totalAmount += totalCharge;
            }
        }

        model.addAttribute("member", member);
        model.addAttribute("realCharges", realCharges);
        model.addAttribute("totalAmount", totalAmount);  // ✅ 현재월까지만 합산된 값
        return "proof";
    }

    // 5. 메인 페이지
    @RequestMapping("/main.do")
    public String showMainPage() {
        return "main";
    }

    // 6. 전기요금표 페이지
    @RequestMapping("/electric_fee.do")
    public String showElectricFee() {
        return "electric_fee";
    }
    
    // 7. 회원가입 페이지
    @RequestMapping("/signup.do")
    public String showSignupPage() {
        return "signup";
    }
}