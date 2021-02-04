package woodley.football.league;

import java.sql.Timestamp;

public class F_League_CreateDTO {
	private int league_num; //리그고유번호
	private String league_name; // 리그이름
	private int jointeam; // 참가수
	private String period; // 기간
	private int leagueing; // 진행상화
	private String creater; // 개최자
	private String content;  // 리그소개
	private String location; // 리그 지역
	private String banner;  // 리그배너
	private Timestamp reg; // 리그 생성시간
	
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	public int getLeague_num() {
		return league_num;
	}
	public void setLeague_num(int league_num) {
		this.league_num = league_num;
	}
	public String getLeague_name() {
		return league_name;
	}
	public void setLeague_name(String league_name) {
		this.league_name = league_name;
	}
	public int getJointeam() {
		return jointeam;
	}
	public void setJointeam(int jointeam) {
		this.jointeam = jointeam;
	}
	public String getPeriod() {
		return period;
	}
	public void setPeriod(String period) {
		this.period = period;
	}
	public int getLeagueing() {
		return leagueing;
	}
	public void setLeagueing(int leagueing) {
		this.leagueing = leagueing;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getBanner() {
		return banner;
	}
	public void setBanner(String banner) {
		this.banner = banner;
	}
	
	
	
}
