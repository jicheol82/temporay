package woodley.football.comboard;

import java.sql.Timestamp;

public class Notice_BoardDTO {
	private Integer notice_board_num;
	private String title;
	private String id;
	private Timestamp reg;
	private Integer readCount;
	private String pic;
	private String content;
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getNotice_board_num() {
		return notice_board_num;
	}
	public void setNotice_board_num(Integer notice_board_num) {
		this.notice_board_num = notice_board_num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	public Integer getReadCount() {
		return readCount;
	}
	public void setReadCount(Integer readCount) {
		this.readCount = readCount;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic;
	}
}
