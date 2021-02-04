package woodley.football.league;

public class F_Per_RecordDTO {
	private int ranked;
	private String name;
	private String tname;
	private int goals;
	private int assist;
	private int played;
	private int league_num;
	private int club_num;
	private String profile;
	
	
	
	public String getProfile() {
		return profile;
	}
	public void setProfile(String profile) {
		this.profile = profile;
	}
	public int getRanked() {
		return ranked;
	}
	public void setRanked(int ranked) {
		this.ranked = ranked;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTname() {
		return tname;
	}
	public void setTname(String tname) {
		this.tname = tname;
	}
	public int getGoals() {
		return goals;
	}
	public void setGoals(int goals) {
		this.goals = goals;
	}
	public int getAssist() {
		return assist;
	}
	public void setAssist(int assist) {
		this.assist = assist;
	}
	public int getPlayed() {
		return played;
	}
	public void setPlayed(int played) {
		this.played = played;
	}
	public int getLeague_num() {
		return league_num;
	}
	public void setLeague_num(int league_num) {
		this.league_num = league_num;
	}
	public int getClub_num() {
		return club_num;
	}
	public void setClub_num(int club_num) {
		this.club_num = club_num;
	}
	
	
}
