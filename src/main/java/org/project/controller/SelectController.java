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
    public String searchMember(@RequestParam("keyword") String keyword, Model model) {
        if (keyword == null || keyword.trim().isEmpty()) {
            model.addAttribute("members", Collections.emptyList());
            model.addAttribute("message", "검색어를 입력해주세요.");
            return "select";
        }

        // 메서드 이름은 customer로 유지
        List<MemberVO> members = memberMapper.searchCustomers(keyword);
        if (members.isEmpty()) {
            model.addAttribute("message", "일치하는 회원이 없습니다.");
        }

        model.addAttribute("members", members);
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
        // userid 파라미터가 없으면 로그인 사용자 아이디로 대체
        if (userid == null || userid.isEmpty()) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated()) {
                userid = auth.getName();  // 로그인한 아이디 가져오기
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
            for (int use : member.getMonthlyUsage()) {
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
                int addedTax = Math.round(sumCharge / 10);
                int totalCharge = sumCharge + addedTax + fund;

                realCharges.add(totalCharge);
                totalAmount += totalCharge; // ⭐ 여기서 누적
            }
        }

        model.addAttribute("member", member);
        model.addAttribute("realCharges", realCharges);
        model.addAttribute("totalAmount", totalAmount); // ✔ 정확한 총액 전달
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