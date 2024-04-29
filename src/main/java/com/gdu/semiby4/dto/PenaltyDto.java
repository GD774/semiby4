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
public class PenaltyDto {
	int penaltyNo, userNo;
	String note;
	Date actionedDt;
}
