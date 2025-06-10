package org.project.service;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public String sendVerificationMail(String toEmail) {
        String authCode = UUID.randomUUID().toString().substring(0, 6);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("회원가입 인증 코드");
        message.setText("인증 코드: " + authCode);

        mailSender.send(message);

        return authCode;
    }
}