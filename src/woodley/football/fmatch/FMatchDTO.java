package woodley.football.fmatch;

import java.sql.Timestamp;

public class FMatchDTO {
	private Integer num;
	private String id;
	private String tname;
	private Integer state;
	private String gamedate;
	private String gametime;
	private String homeground;
	private String uniformcolor;
	private String location;
	private String content;
	private Timestamp reg;
	public Integer getNum() {
		return num;
	}
	public void setNum(Integer num) {
		this.num = num;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTname() {
		return tname;
	}
	public void setTname(String tname) {
		this.tname = tname;
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	public String getGamedate() {
		return gamedate;
	}
	public void setGamedate(String gamedate) {
		this.gamedate = gamedate;
	}
	public String getGametime() {
		return gametime;
	}
	public void setGametime(String gametime) {
		this.gametime = gametime;
	}
	public String getHomeground() {
		return homeground;
	}
	public void setHomeground(String homeground) {
		this.homeground = homeground;
	}
	public String getUniformcolor() {
		return uniformcolor;
	}
	public void setUniformcolor(String uniformcolor) {
		this.uniformcolor = uniformcolor;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
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
}
