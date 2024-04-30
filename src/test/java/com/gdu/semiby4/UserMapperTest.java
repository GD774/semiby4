package com.gdu.semiby4;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.sql.Date;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import lombok.RequiredArgsConstructor;

import com.gdu.semiby4.dto.BoardDto;
import com.gdu.semiby4.dto.ReportDto;
import com.gdu.semiby4.dto.UserDto;
import com.gdu.semiby4.mapper.AdminMapper;
import com.gdu.semiby4.mapper.BoardMapper;
import com.gdu.semiby4.mapper.UserMapper;

// @RequiredArgsConstructor
// JUnit5
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations="file:src/main/webapp/WEB-INF/spring/root-context.xml")
class UserMapperTest {

	@Autowired
  private UserMapper userMapper;

	@Autowired
	private BoardMapper boardMapper;

	@Autowired
	private AdminMapper adminMapper;

  @Test
  void test() {
    // assertEquals(1, userMapper.insertUser(new UserDto()));
		List<BoardDto> allboards = boardMapper.getAllBoards();
		int maxbno = 0;
		int minbno = 10;
		for (int i = 0; i < allboards.size(); i++) {
			int bno = allboards.get(i).getBoardNo();
			if (maxbno < bno)
				maxbno = bno;
			if (minbno > bno)
				minbno = bno;
		}

		List<UserDto> allusers = adminMapper.getAllUsers();
		int maxuno = 0;
		int minuno = 10;
		for (int i = 0; i < allusers.size(); i++) {
			int uno = allusers.get(i).getUserNo();
			if (maxuno < uno)
				maxuno = uno;
			if (minuno > uno)
				minuno = uno;
		}

		ThreadLocalRandom rando = ThreadLocalRandom.current();

		for (int i = 0; i < 1000; i++) {
			userMapper.insertUser(UserDto.builder()
														         .userId("tester" + Integer.toString(maxuno + 1 + i))
														         .pw(Integer.toString(maxuno + 1 + i))
														         .email("tester" + Integer.toString(maxuno + 1 + i) + "@tester.mail")
														         .name("cloneTester" + Integer.toString(maxuno + 1 + i))
														         .gender("man")
														         .mobile("01099999999")
														      .build());
		}

		for (int i = 0; i < 1000; i++) {
			long delta = rando.nextInt(-30, 30) * 1000 * 60 * 60 * 24;
			userMapper.report(ReportDto.builder()
												           .reporterNo(rando.nextInt(minuno, maxuno + 1))
											             .userNo(rando.nextInt(minuno, maxuno + 1))
											             .boardNo(rando.nextInt(minbno, maxbno + 1))
												           .createDt(new Date(System.currentTimeMillis() + delta))
												           .title("?x?")
												           .contents("!x!")
											          .build());
		}
  }

}
