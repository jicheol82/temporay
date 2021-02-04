package woodley.football.comboard;

import java.sql.Timestamp;

public class Free_BoardDTO {
	private Integer free_board_num;
	private String title;
	private String writer;
	private String content;
	private Timestamp reg;
	private Integer readcount;
	private String img;
	public Integer getFree_board_num() {
		return free_board_num;
	}
	public void setFree_board_num(Integer free_board_num) {
		this.free_board_num = free_board_num;
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
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}	
}
