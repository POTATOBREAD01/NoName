package org.project.mapper;

import java.util.List;
import org.project.domain.MemberVO;

public interface MemberMapper {
    MemberVO read(String userid);                     // 로그인 시 회원 + 권한 정보 조회
    void insertCustomer(MemberVO memberVO);           // 회원 등록
    void insertAuth(MemberVO memberVO);               // 권한 등록
    void insertElectBill(MemberVO memberVO);          // 전기 사용량 등록

    int countById(String userid);                     // 아이디 중복 검사
    int countByEmail(String email);                   // 이메일 중복 검사
    int isUsernoExist(String userno);             // 고객번호 중복 검사

    MemberVO getCustomerByUserid(String userid);      // 고객 상세 조회 (전기요금 포함)
    void deleteCustomer(String userid);               // 고객 삭제
    List<MemberVO> getAllCustomers();                 // 전체 고객 목록
    MemberVO searchCustomerByUserno(String userno);   // 고객번호로 검색
    
    List<String> getAllUsernos();
}