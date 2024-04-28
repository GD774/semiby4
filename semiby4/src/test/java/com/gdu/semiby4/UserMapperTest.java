package com.gdu.semiby4;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.UserMapper;

// JUnit5
@ExtendWith(SpringExtension.class)

@ContextConfiguration(locations="file:src/main/webapp/WEB-INF/spring/root-context.xml")

class UserMapperTest {

  @Autowired
  private UserMapper userMapper;
  
  @Test
  void test() {
    // assertEquals(1, userMapper.insertUser(new UserDto()));
  }

}
