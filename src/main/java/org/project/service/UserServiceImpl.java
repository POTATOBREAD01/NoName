package org.project.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.project.domain.UserVO;

import org.project.mapper.UserMapper;

public class UserServiceImpl implements UserService {
	
	private UserMapper mapper;
	
	public List<UserVO> view(@Param("userid") String userid){
		return mapper.view(userid);
	}
}
