package org.project.mapper;

import org.project.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid);
    void insertCustomer(MemberVO memberVO);
    void insertAuth(MemberVO memberVO);
    int countById(String id);
}
