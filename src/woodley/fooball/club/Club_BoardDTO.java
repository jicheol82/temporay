package woodley.fooball.club;

import java.sql.Timestamp;

public class Club_BoardDTO {
	
	private Integer boardnum;
	private String title;
	private String writer;
	private String content;
	private Timestamp reg;
	private Integer readcount;
	private Integer clubnum;
	private String photo;
	public Integer getBoardnum() {
		return boardnum;
	}
	public void setBoardnum(Integer boardnum) {
		this.boardnum = boardnum;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	public Integer getReadcount() {
		return readcount;
	}
	public void setReadcount(Integer readcount) {
		this.readcount = readcount;
	}
	public Integer getClubnum() {
		return clubnum;
	}
	public void setClubnum(Integer clubnum) {
		this.clubnum = clubnum;
	}
	public String getPhoto() {
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}
	
	
	
	
}
