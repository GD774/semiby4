package com.gdu.semiby4.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class AttachDto {
	int attachNo, downloadCount, hasThumbnail, boardNo;
	String uploadPath, filesystemName, originalFilename;
}
