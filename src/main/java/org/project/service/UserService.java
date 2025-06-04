package org.project.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.project.domain.UserVO;

public interface UserService {
	public List<UserVO> view(@Param("userid") String userid);
}
