package org.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.project.domain.UserVO;

public interface UserMapper {
	
	public List<UserVO> view(@Param("userid") String userid);
}
