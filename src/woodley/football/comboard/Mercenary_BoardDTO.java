package woodley.football.comboard;

import java.sql.Timestamp;

public class Mercenary_BoardDTO {
	private Integer num;
	private String bulletPoint;
	private String title;
	private String writer;
	private String tname;
	private String content;
	private String img;
	private Integer readcount;
	private Timestamp reg;
	public Integer getNum() {
		return num;
	}
	public void setNum(Integer num) {
		this.num = num;
	}
	public String getBulletPoint() {
		return bulletPoint;
	}
	public void setBulletPoint(String bulletPoint) {
		this.bulletPoint = bulletPoint;
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
	public String getTname() {
		return tname;
	}
	public void setTname(String tname) {
		this.tname = tname;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public Integer getReadcount() {
		return readcount;
	}
	public void setReadcount(Integer readcount) {
		this.readcount = readcount;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	
}
