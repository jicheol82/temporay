package woodley.football.league;

public class F_ResultDTO {
	private int result_num;
	private int league_num;
	private String matchday;
	private String matchtime;
	
	public String getMatchtime() {
		return matchtime;
	}
	public void setMatchtime(String matchtime) {
		this.matchtime = matchtime;
	}
	private int homeclubnum;
	private int awayclubnum;
	
	public int getResult_num() {
		return result_num;
	}
	public void setResult_num(int result_num) {
		this.result_num = result_num;
	}
	private int homescore;
	private int awayscore;
	private int state;
	
	public int getLeague_num() {
		return league_num;
	}
	public void setLeague_num(int league_num) {
		this.league_num = league_num;
	}
	public String getMatchday() {
		return matchday;
	}
	public void setMatchday(String matchday) {
		this.matchday = matchday;
	}
	
	
	public int getHomeclubnum() {
		return homeclubnum;
	}
	public void setHomeclubnum(int homeclubnum) {
		this.homeclubnum = homeclubnum;
	}
	public int getAwayclubnum() {
		return awayclubnum;
	}
	public void setAwayclubnum(int awayclubnum) {
		this.awayclubnum = awayclubnum;
	}


	
	public int getHomescore() {
		return homescore;
	}
	public void setHomescore(int homescore) {
		this.homescore = homescore;
	}
	public int getAwayscore() {
		return awayscore;
	}
	public void setAwayscore(int awayscore) {
		this.awayscore = awayscore;
	}
	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
	
	
}
