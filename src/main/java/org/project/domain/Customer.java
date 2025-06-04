package org.project.domain;

import lombok.Data;

@Data
public class Customer {
    private int userno;
    private String name;
    private String id;
    private String password;
    private String phone;
    private String address;

    private int month25_1;
    private int month25_2;
    private int month25_3;
    private int month25_4;
    private int month25_5;
    private int month25_6;
    private int month25_7;
    private int month25_8;
    private int month25_9;
    private int month25_10;
    private int month25_11;
    private int month25_12;

    // 12개월 사용량을 배열로 반환하는 메서드
    public int[] getMonthlyUsage() {
        return new int[] {
            month25_1,
            month25_2,
            month25_3,
            month25_4,
            month25_5,
            month25_6,
            month25_7,
            month25_8,
            month25_9,
            month25_10,
            month25_11,
            month25_12
        };
    }
}
