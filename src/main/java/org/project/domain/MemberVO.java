package org.project.domain;

import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	private String userid;
	private String userpw;
	private String username;
	private String useraddr;
	private String userphone;
	private String userno;
	private String useremail;
	private boolean enabled;
	private String proofno;
	
	private List<AuthVO> authList;
	
    private int month1;
    private int month2;
    private int month3;
    private int month4;
    private int month5;
    private int month6;
    private int month7;
    private int month8;
    private int month9;
    private int month10;
    private int month11;
    private int month12;

    // 12개월 사용량을 배열로 반환하는 메서드
    public List<Integer> getMonthlyUsage() {
        return java.util.Arrays.asList(
            month1, month2, month3, month4, month5, month6,
            month7, month8, month9, month10, month11, month12
        );
    }
}