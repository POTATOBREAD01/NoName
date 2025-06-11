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

    @Transactional
    public void registerCustomer(MemberVO memberVO) {
        // 비밀번호 암호화
        String encodedPw = passwordEncoder.encode(memberVO.getUserpw());
        memberVO.setUserpw(encodedPw);

        // 12개월 전기 사용량 생성
        generateRandomUsage(memberVO);

        // 회원 정보, 권한, 전기 사용량 등록
        memberMapper.insertCustomer(memberVO);
        memberMapper.insertAuth(memberVO);
        memberMapper.insertElectBill(memberVO);
    }

    private void generateRandomUsage(MemberVO memberVO) {
        for (int i = 1; i <= 12; i++) {
            int usage = (int)(Math.random() * 151) + 50; // 50 ~ 200
            switch (i) {
                case 1: memberVO.setMonth1(usage); break;
                case 2: memberVO.setMonth2(usage); break;
                case 3: memberVO.setMonth3(usage); break;
                case 4: memberVO.setMonth4(usage); break;
                case 5: memberVO.setMonth5(usage); break;
                case 6: memberVO.setMonth6(usage); break;
                case 7: memberVO.setMonth7(usage); break;
                case 8: memberVO.setMonth8(usage); break;
                case 9: memberVO.setMonth9(usage); break;
                case 10: memberVO.setMonth10(usage); break;
                case 11: memberVO.setMonth11(usage); break;
                case 12: memberVO.setMonth12(usage); break;
            }
        }
    }

    public boolean isIdExist(String id) {
        return memberMapper.countById(id) > 0;
    }

    public boolean isEmailExist(String email) {
        return memberMapper.countByEmail(email) > 0;
    }

    public boolean isUsernoExist(String userno) {
        return memberMapper.isUsernoExist(userno) > 0;
    }

    public MemberVO getCustomerByUserid(String userid) {
        return memberMapper.getCustomerByUserid(userid);
    }

    public void deleteCustomer(String userid) {
        memberMapper.deleteCustomer(userid);
    }

    public List<MemberVO> getAllCustomers() {
        return memberMapper.getAllCustomers();
    }

    public MemberVO searchCustomerByUserno(String userno) {
        return memberMapper.searchCustomerByUserno(userno);
    }
    
    public List<String> getAllUsernos() {
        return memberMapper.getAllUsernos();
    }
}