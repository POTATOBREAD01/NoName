package org.project.controller;

import org.project.domain.MemberVO;
import org.project.service.EmailService;
import org.project.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private MemberService memberService;
    
    @Autowired
    private EmailService emailService;
      
    // 회원가입 폼
    @GetMapping("/signup")
    public String showSignupForm(Model model) {
        model.addAttribute("memberVO", new MemberVO());
        return "signup";
    }

    
    @GetMapping("/generateUserno")
    @ResponseBody
    public Map<String, Object> generateUserno() {
        Map<String, Object> result = new HashMap<>();

        // 1. 이미 사용 중인 고객번호 목록 조회
        List<String> usedUsernos = memberService.getAllUsernos(); // 예: ["1111", "1114", "1471", "1235"]

        // 2. 후보 번호 리스트 생성
        List<String> candidates = new ArrayList<>();
        for (int i = 0; i <= 9999; i++) {
            String userno = String.format("%04d", i);
            if (!usedUsernos.contains(userno)) {
                candidates.add(userno);
            }
        }

        // 3. 후보가 없다면 오류 반환
        if (candidates.isEmpty()) {
            result.put("success", false);
            result.put("message", "사용 가능한 고객번호가 없습니다.");
            return result;
        }

        // 4. 랜덤하게 하나 선택
        Collections.shuffle(candidates);
        String newUserno = candidates.get(0);

        result.put("success", true);
        result.put("userno", newUserno);
        return result;
    }
    	
    // 회원가입 처리
    @PostMapping("/signup")
    public String signup(@ModelAttribute MemberVO memberVO,
                         @RequestParam String repassword,
                         Model model,
                         HttpSession session) {

        boolean hasError = false;

        // 고객번호 유효성 및 중복 검사
        if (memberVO.getUserno() == null || !memberVO.getUserno().matches("^\\d{4,10}$")) {
            model.addAttribute("errorUserno", "고객번호는 4~10자리 숫자여야 합니다.");
            hasError = true;
        } else if (memberService.isUsernoExist(memberVO.getUserno())) {
            model.addAttribute("errorUserno", "이미 사용 중인 고객번호입니다.");
            hasError = true;
        }
        
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

        // 이메일 인증 여부 확인
        Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
        if (emailVerified == null || !emailVerified) {
            model.addAttribute("errorEmail", "이메일 인증이 완료되지 않았습니다.");
            hasError = true;
        }
        
        // 주소 유효성 검사
        if (memberVO.getUseraddr() == null || memberVO.getUseraddr().trim().isEmpty()) {
            model.addAttribute("errorAddr", "주소를 입력해주세요.");
            hasError = true;
        }
        
        if (hasError) {
            model.addAttribute("memberVO", memberVO);
            return "signup";
        }
        // 회원 가입 처리
        memberService.registerCustomer(memberVO);
        
        // 이메일 인증 관련 세션 초기화
        session.removeAttribute("emailAuthCode");
        session.removeAttribute("emailForAuth");
        session.removeAttribute("emailVerified");
        
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
    
    // 이메일 인증 코드 전송
    @GetMapping("/sendAuthCode")
    @ResponseBody
    public Map<String, Object> sendAuthCode(@RequestParam String email, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        try {
            String authCode = emailService.sendVerificationMail(email);
            session.setAttribute("emailAuthCode", authCode);     // 통일된 네임
            session.setAttribute("emailForAuth", email);         // 통일된 네임
            session.setAttribute("emailVerified", false);        // 통일된 네임
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "메일 발송 실패: " + e.getMessage());
        }

        return result;
    }
    
    // 이메일 인증 코드 확인
    @PostMapping("/verifyAuthCode")
    @ResponseBody
    public Map<String, Object> verifyAuthCode(@RequestParam String inputCode, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        String authCode = (String) session.getAttribute("emailAuthCode");
        if (authCode != null && authCode.equals(inputCode)) {
            session.setAttribute("emailVerified", true);
            result.put("valid", true);
        } else {
            result.put("valid", false);
            result.put("message", "인증 코드가 일치하지 않습니다.");
        }

        return result;
    }
    
    // 이메일 중복 확이
    @GetMapping("/checkEmail")
    @ResponseBody
    public Map<String, Object> checkEmail(@RequestParam String email) {
        Map<String, Object> result = new HashMap<>();

        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$")) {
            result.put("valid", false);
            result.put("message", "이메일 형식이 올바르지 않습니다.");
            return result;
        }

        boolean exists = memberService.isEmailExist(email); // 이메일 중복 확인 메서드 필요
        if (exists) {
            result.put("valid", false);
            result.put("message", "이미 등록된 이메일입니다.");
        } else {
            result.put("valid", true);
        }
        return result;
    }
    
    // 고객번호 중복 확인
    @GetMapping("/checkUserno")
    @ResponseBody
    public Map<String, Object> checkUserno(@RequestParam String userno) {
        Map<String, Object> result = new HashMap<>();

        if (userno == null || !userno.matches("^\\d{4,10}$")) {
            result.put("valid", false);
            result.put("message", "고객번호는 4~10자리의 숫자여야 합니다.");
            return result;
        }

        boolean exists = memberService.isUsernoExist(userno); // service 메서드 호출
        if (exists) {
            result.put("valid", false);
            result.put("message", "이미 등록된 고객번호입니다.");
        } else {
            result.put("valid", true);
        }

        return result;
    }
}