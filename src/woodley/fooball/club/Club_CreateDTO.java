package woodley.fooball.club;

import java.sql.Timestamp;

public class Club_CreateDTO {
	private Integer clubNum;
	private String tName;
	private Integer tNum;
	private String tLocal;
	private String avrAge;
	private String clubEvent;
	private String skill;
	private String ground;
	private String emblem;
	private String bio;
	private String headId;
	private Timestamp reg;
	
	public Integer getClubNum() {
		return clubNum;
	}
	public void setClubNum(Integer clubNum) {
		this.clubNum = clubNum;
	}
	public String gettName() {
		return tName;
	}
	public void settName(String tName) {
		this.tName = tName;
	}
	public Integer gettNum() {
		return tNum;
	}
	public void settNum(Integer tNum) {
		this.tNum = tNum;
	}
	public String gettLocal() {
		return tLocal;
	}
	public void settLocal(String tLocal) {
		this.tLocal = tLocal;
	}
	public String getAvrAge() {
		return avrAge;
	}
	public void setAvrAge(String avrAge) {
		this.avrAge = avrAge;
	}
	public String getClubEvent() {
		return clubEvent;
	}
	public void setClubEvent(String clubEvent) {
		this.clubEvent = clubEvent;
	}
	public String getSkill() {
		return skill;
	}
	public void setSkill(String skill) {
		this.skill = skill;
	}
	public String getGround() {
		return ground;
	}
	public void setGround(String ground) {
		this.ground = ground;
	}
	public String getEmblem() {
		return emblem;
	}
	public void setEmblem(String emblem) {
		this.emblem = emblem;
	}
	public String getBio() {
		return bio;
	}
	public void setBio(String bio) {
		this.bio = bio;
	}
	public String getHeadId() {
		return headId;
	}
	public void setHeadId(String headId) {
		this.headId = headId;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
}
