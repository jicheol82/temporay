package woodley.fooball.club;

import java.sql.Timestamp;

public class Club_ListDTO {
	 
	private Integer clubNum;
	private String memid;
	private Integer authority;
	private Timestamp reg;
	
	public Integer getClubNum() {
		return clubNum;
	}
	public void setClubNum(Integer clubNum) {
		this.clubNum = clubNum;
	}
	public String getMemid() {
		return memid;
	}
	public void setMemid(String memid) {
		this.memid = memid;
	}
	public Integer getAuthority() {
		return authority;
	}
	public void setAuthority(Integer authority) {
		this.authority = authority;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	
	
	
}
