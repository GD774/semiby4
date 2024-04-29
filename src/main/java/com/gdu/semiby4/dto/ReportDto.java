package com.gdu.semiby4.dto;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class ReportDto {
	int reportNo, userNo, boardNo;
	String title, contents;
	Date createDt;
}
