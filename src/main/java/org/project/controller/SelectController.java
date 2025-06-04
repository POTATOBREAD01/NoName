package org.project.controller;

import java.util.Collections;
import java.util.List;
import java.util.Arrays;

import org.project.domain.Customer;
import org.project.mapper.CustomerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class SelectController {

    @Autowired
    private CustomerMapper customerMapper;

    // 1. 고객 선택 첫 화면 (빈 리스트)
    @GetMapping("/selectCustomer.do")
    public String selectCustomer(Model model) {
        model.addAttribute("customers", Collections.emptyList());
        return "select";
    }

    // 2. 고객 검색 처리
    @GetMapping("/searchCustomer.do")
    public String searchCustomer(@RequestParam("keyword") String keyword, Model model) {
        if (keyword == null || keyword.trim().isEmpty()) {
            model.addAttribute("customers", Collections.emptyList());
            model.addAttribute("message", "검색어를 입력해주세요.");
            return "select";
        }

        List<Customer> customers = customerMapper.searchCustomers(keyword);
        if (customers.isEmpty()) {
            model.addAttribute("message", "일치하는 고객이 없습니다.");
        }

        model.addAttribute("customers", customers);
        return "select";
    }

    // 3. 고객 삭제
    @PostMapping("/deleteCustomer.do")
    public String deleteCustomer(@RequestParam("userno") int userno) {
        customerMapper.deleteCustomer(userno);
        return "redirect:/selectCustomer.do";
    }

    // 4. 전기요금 납부증명서 페이지로 이동
    @GetMapping("/proof.do")
    public String showProofPage(@RequestParam(value = "userno", required = false) Integer userno, Model model) {
        if (userno == null) {
            model.addAttribute("message", "고객번호가 누락되었습니다.");
            return "error";
        }

        Customer customer = customerMapper.getCustomerByUserno(userno);
        if (customer == null) {
            model.addAttribute("message", "해당 고객을 찾을 수 없습니다.");
            return "error";
        }

        int totalAmount = Arrays.stream(customer.getMonthlyUsage())
                                .map(usage -> usage * 210)
                                .sum();

        model.addAttribute("customer", customer);
        model.addAttribute("totalAmount", totalAmount);
        return "proof";
    }

    // 5. 메인 페이지
    @RequestMapping("/main.do")
    public String showMainPage() {
        return "main";  // main.jsp
    }

    // 6. 전기요금표 페이지
    @RequestMapping("/electric_fee.do")
    public String showElectricFee() {
        return "electric_fee";  // electric_fee.jsp
    }
    
 // 7. 메인 페이지
    @RequestMapping("/signup.do")
    public String showSignupPage() {
        return "signup";  // main.jsp
    }
}
