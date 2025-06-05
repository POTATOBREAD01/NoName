package org.project.mapper;

import java.util.List;

import org.project.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid);
    void insertCustomer(MemberVO memberVO);
    void insertAuth(MemberVO memberVO);
    int countById(String id);
    List<MemberVO> searchCustomers(String keyword);
    MemberVO getCustomerByUserid(String userid);
    void deleteCustomer(String userid);
    List<MemberVO> getAllCustomers();
}
