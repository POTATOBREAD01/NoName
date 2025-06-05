package org.project.controller;

import org.project.domain.MemberVO;
import org.project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private MemberService memberService;

    // 회원가입 폼
    @GetMapping("/signup")
    public String showSignupForm(Model model) {
        model.addAttribute("memberVO", new MemberVO());
        return "signup";
    }

    // 회원가입 처리
    @PostMapping("/signup")
    public String signup(@ModelAttribute MemberVO memberVO,
                         @RequestParam String repassword,
                         Model model) {

        boolean hasError = false;

        // 아이디 유효성 및 중복 검사
        if (memberVO.getUserid() == null || !memberVO.getUserid().matches("^[a-zA-Z0-9]{4,16}$")) {
            model.addAttribute("errorId", "아이디는 4~16자의 영문자 또는 숫자만 허용됩니다.");
            hasError = true;
        } else if (memberService.isIdExist(memberVO.getUserid())) {
            model.addAttribute("errorId", "이미 사용 중인 아이디입니다.");
            hasError = true;
        }

        // 비밀번호 유효성 검사
        if (memberVO.getUserpw() == null || !memberVO.getUserpw().matches("^(?=.*[a-zA-Z])(?=.*\\d).{8,}$")) {
            model.addAttribute("errorPassword", "비밀번호는 최소 8자 이상이며, 영문자와 숫자를 포함해야 합니다.");
            hasError = true;
        }

        // 비밀번호 확인
        if (repassword == null || !repassword.equals(memberVO.getUserpw())) {
            model.addAttribute("errorRepassword", "비밀번호가 일치하지 않습니다.");
            hasError = true;
        }

        // 전화번호 유효성 검사
        if (memberVO.getUserphone() == null || !memberVO.getUserphone().matches("^\\d{10,11}$")) {
            model.addAttribute("errorPhone", "전화번호는 숫자만 입력하며, 10자리 또는 11자리여야 합니다.");
            hasError = true;
        }

        if (hasError) {
            model.addAttribute("memberVO", memberVO);
            return "signup";
        }

        // 회원 가입 처리
        memberService.registerCustomer(memberVO);
        return "redirect:/customer/success";
    }

    // 회원가입 성공 페이지
    @GetMapping("/success")
    public String signupSuccess() {
        return "signupSuccess";
    }

    // Ajax: 아이디 중복 및 유효성 검사
    @GetMapping("/checkId")
    @ResponseBody
    public Map<String, Object> checkId(@RequestParam String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (id == null || !id.matches("^[a-zA-Z0-9]{4,16}$")) {
                result.put("valid", false);
                result.put("message", "아이디는 4~16자의 영문자 또는 숫자만 허용됩니다.");
                return result;
            }

            boolean exists = memberService.isIdExist(id);
            if (exists) {
                result.put("valid", false);
                result.put("message", "이미 사용 중인 아이디입니다.");
            } else {
                result.put("valid", true);
            }
        } catch (Exception e) {
            result.put("valid", false);
            result.put("message", "서버 오류: " + e.getMessage());
            e.printStackTrace(); // 서버 로그에 예외 출력
        }
        return result;
    }


    // Ajax: 비밀번호 유효성 검사
    @GetMapping("/checkPassword")
    @ResponseBody
    public Map<String, Object> checkPassword(@RequestParam String password) {
        Map<String, Object> result = new HashMap<>();
        if (password == null || !password.matches("^(?=.*[a-zA-Z])(?=.*\\d).{8,}$")) {
            result.put("valid", false);
            result.put("message", "비밀번호는 최소 8자 이상이며, 영문자와"+System.getProperty("line.separator")+"숫자를 포함해야 합니다.");
        } else {
            result.put("valid", true);
        }
        return result;
    }

    // Ajax: 비밀번호 확인 일치 검사
    @GetMapping("/checkRepassword")
    @ResponseBody
    public Map<String, Object> checkRepassword(@RequestParam String password, @RequestParam String repassword) {
        Map<String, Object> result = new HashMap<>();
        if (password == null || repassword == null || !password.equals(repassword)) {
            result.put("valid", false);
            result.put("message", "비밀번호가 일치하지 않습니다.");
        } else {
            result.put("valid", true);
        }
        return result;
    }

    // Ajax: 전화번호 유효성 검사
    @GetMapping("/checkPhone")
    @ResponseBody
    public Map<String, Object> checkPhone(@RequestParam String phone) {
        Map<String, Object> result = new HashMap<>();
        if (phone == null || !phone.matches("^\\d{10,11}$")) {
            result.put("valid", false);
            result.put("message", "전화번호는 숫자만 입력하며, 10자리 또는"+System.getProperty("line.separator")+"11자리여야 합니다.");
        } else {
            result.put("valid", true);
        }
        return result;
    }
    
    @GetMapping("/searchCustomer")
    public String searchCustomer(@RequestParam(required = false) String keyword, Model model, HttpSession session) {
        List<MemberVO> newMembers = memberService.searchCustomer(keyword == null ? "" : keyword);
        List<MemberVO> sessionMembers = (List<MemberVO>) session.getAttribute("members");

        if (sessionMembers == null) {
            session.setAttribute("members", newMembers);
        } else {
            for (MemberVO m : newMembers) {
                boolean exists = sessionMembers.stream().anyMatch(sc -> sc.getUserid() == m.getUserid());
                if (!exists) {
                    sessionMembers.add(m);
                }
            }
            session.setAttribute("members", sessionMembers);
        }

        model.addAttribute("members", session.getAttribute("members"));
        model.addAttribute("keyword", keyword);
        return "select";
    }

    @GetMapping("/select")
    public String select(Model model, HttpSession session) {
        List<MemberVO> members = (List<MemberVO>) session.getAttribute("members");
        model.addAttribute("members", members);
        return "select";
    }

    @PostMapping("/clearSearch")
    public String clearSearch(HttpSession session) {
        session.removeAttribute("members");
        return "redirect:/customer/select";
    }

    @PostMapping("/removeCustomer")
    public String removeCustomer(@RequestParam String userid, HttpSession session, RedirectAttributes rttr) {
        List<MemberVO> members = (List<MemberVO>) session.getAttribute("members");
        if (members != null) {
            members.removeIf(c -> c.getUserid().equals(userid));
            session.setAttribute("members", members);
            rttr.addFlashAttribute("message", "고객번호 " + userid + " 조회가 취소되었습니다.");
        }
        return "redirect:/customer/select";
    }

    @GetMapping("/proof")
    public String proof(@RequestParam String userid, Model model) {
        MemberVO member = memberService.getCustomerByUserid(userid);
        model.addAttribute("member", member);
        return "proof";
    }
}
