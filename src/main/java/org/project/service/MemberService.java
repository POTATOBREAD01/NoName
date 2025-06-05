package org.project.service;

import java.util.List;

import org.project.domain.MemberVO;
import org.project.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberService {

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
    // 회원가입 처리
    @Transactional
    public void registerCustomer(MemberVO memberVO) {
    	// 비밀번호 BCrypt 인코딩
    	String encodedPw = passwordEncoder.encode(memberVO.getUserpw());
    	memberVO.setUserpw(encodedPw);
    	
        // 1. 회원 정보 삽입
        memberMapper.insertCustomer(memberVO);

        // 2. 권한 정보 삽입
        memberMapper.insertAuth(memberVO); 
    }
    
    // 아이디 존재 여부 확인 (중복 검사용)
    public boolean isIdExist(String id) {
        return memberMapper.countById(id) > 0;
    }
    
    public List<MemberVO> searchCustomer(String keyword) {
        return memberMapper.searchCustomers(keyword);
    }
    
    //고객번호로 고객 조회 (증명서 출력용)
    public MemberVO getCustomerByUserid(String userid) {
        return memberMapper.getCustomerByUserid(userid);
    }
}
