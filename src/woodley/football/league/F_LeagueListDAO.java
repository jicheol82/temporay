package woodley.football.league;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import woodley.fooball.club.Club_CreateDTO;

public class F_LeagueListDAO {
	private static F_LeagueListDAO instance = new F_LeagueListDAO();
	private F_LeagueListDAO() {}
	public static F_LeagueListDAO getInstance() { return instance; } // 싱글턴
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	public void addLeagueList(int League_num, int club_num) { // 리그참가요청 버튼 눌렀을시 추가되는거
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "insert into F_League_list(League_num, Club_num) values(?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, club_num);
			pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
	}
	public void addLeagueList(int League_num, int club_num, int authority) { // 리그 생성시 추가
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "insert into F_League_list values(?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, club_num);
			pstmt.setInt(3, authority);
			pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
	}
	
	public List<Club_CreateDTO> getclubList(int League_num, int authority) { // 리그 참가중인 팀  또는 참가 대기중인 팀
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Club_CreateDTO> rclubList = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT cc.* FROM CLUB_CREATE cc, F_LEAGUE_LIST fll " + 
					"WHERE cc.CLUBNUM = fll.CLUB_NUM AND fll.LEAGUE_NUM=? and fll.authority=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, authority);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rclubList = new ArrayList<Club_CreateDTO>();
				do {
					Club_CreateDTO dto = new Club_CreateDTO();
					dto.setClubNum(rs.getInt("clubnum"));
					dto.settName(rs.getString("tname"));
					dto.settNum(rs.getInt("tnum"));
					dto.settLocal(rs.getString("tlocal"));
					dto.setAvrAge(rs.getString("avrage"));
					dto.setClubEvent(rs.getString("clubevent"));
					dto.setSkill(rs.getString("skill"));
					dto.setGround(rs.getString("ground"));
					dto.setEmblem(rs.getString("emblem"));
					dto.setBio(rs.getString("bio"));
					dto.setHeadId(rs.getString("headid"));
					dto.setReg(rs.getTimestamp("reg"));
					rclubList.add(dto);
				}while(rs.next());
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		return rclubList;
		
	}
	
	public List<Club_CreateDTO> getallList(int League_num, int authority) { // 주최자를 포함한 리그 참가중인팀들
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Club_CreateDTO> rclubList = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT cc.* FROM CLUB_CREATE cc, F_LEAGUE_LIST fll " + 
					"WHERE cc.CLUBNUM = fll.CLUB_NUM AND fll.LEAGUE_NUM=? and not fll.authority=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, authority);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rclubList = new ArrayList<Club_CreateDTO>();
				do {
					Club_CreateDTO dto = new Club_CreateDTO();
					dto.setClubNum(rs.getInt("clubnum"));
					dto.settName(rs.getString("tname"));
					dto.settNum(rs.getInt("tnum"));
					dto.settLocal(rs.getString("tlocal"));
					dto.setAvrAge(rs.getString("avrage"));
					dto.setClubEvent(rs.getString("clubevent"));
					dto.setSkill(rs.getString("skill"));
					dto.setGround(rs.getString("ground"));
					dto.setEmblem(rs.getString("emblem"));
					dto.setBio(rs.getString("bio"));
					dto.setHeadId(rs.getString("headid"));
					dto.setReg(rs.getTimestamp("reg"));
					rclubList.add(dto);
				}while(rs.next());
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		return rclubList;
		
	}
	
	public List<Club_CreateDTO> getnclubList(int League_num) { // 리그 참가대기중인 팀  리스트
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Club_CreateDTO> rclubList = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT cc.* FROM CLUB_CREATE cc, F_LEAGUE_LIST fll " + 
					"WHERE cc.CLUBNUM = fll.CLUB_NUM AND fll.LEAGUE_NUM=? and fll.authority=1";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rclubList = new ArrayList<Club_CreateDTO>();
				do {
					Club_CreateDTO dto = new Club_CreateDTO();
					dto.setClubNum(rs.getInt("clubnum"));
					dto.settName(rs.getString("tname"));
					dto.settNum(rs.getInt("tnum"));
					dto.settLocal(rs.getString("tlocal"));
					dto.setAvrAge(rs.getString("avrage"));
					dto.setClubEvent(rs.getString("clubevent"));
					dto.setSkill(rs.getString("skill"));
					dto.setGround(rs.getString("ground"));
					dto.setEmblem(rs.getString("emblem"));
					dto.setBio(rs.getString("bio"));
					dto.setHeadId(rs.getString("headid"));
					dto.setReg(rs.getTimestamp("reg"));
					rclubList.add(dto);
				}while(rs.next());
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		return rclubList;
		
	}
	
	
	
	
	
	
	
	public void acceptLeague(int League_num, int club_num) { // 리그 참가수락
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "update F_league_list set authority=1 where league_num=? and club_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, club_num);
			pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
	}
	
	public void leagueban(int League_num, int club_num) {  // 리그 추방
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = getConnection();
			String sql = "DELETE F_LEAGUE_LIST WHERE league_num=? AND club_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, club_num);
			pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
	}
	
	public F_LeagueListDTO checkjoinLeague(int League_num, int club_num) { // 참가요청 눌렀거나 참가중이면 버튼안보이게
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		F_LeagueListDTO dto = null;
		
		try {
			conn = getConnection();
			String sql = "select * from F_League_list where league_num=? and club_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, club_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new F_LeagueListDTO();
				dto.setLeague_num(rs.getInt("league_num"));
				dto.setClub_num(rs.getInt("club_num"));
				dto.setAuthority(rs.getInt("authority"));
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		return dto;
	}
	
	// 내가 참가중인 리그 몇갠지 불러오기
	public int myLeagueCount(int club_num) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			
			conn = getConnection();
			String sql = "select count(*) from F_League_list where club_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, club_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt(1);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		return count;
	}
	
	// 내가 참여중인 리그 목록 불러오기
	
	public List<F_League_CreateDTO> getMyLeagueList(int club_num, int startRow, int endRow) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<F_League_CreateDTO> myLeagueList = null;
		
		try {
			 
			 conn = getConnection();
			 String sql = "SELECT * FROM " + 
			 		"(SELECT alldata.*,rownum r from " + 
			 		"(SELECT fl.league_name, fl.location, fl.jointeam, fl.period, fl.creater, fl.leagueing, fl.LEAGUE_NUM " + 
			 		"FROM F_LEAGUE fl, F_LEAGUE_LIST fll " + 
			 		"WHERE fll.CLUB_NUM=? AND NOT fll.AUTHORITY=0 " + 
			 		"AND fll.LEAGUE_NUM = fl.LEAGUE_NUM ORDER BY fl.REG DESC)alldata) WHERE r >=? AND r <=?";
			 pstmt = conn.prepareStatement(sql);
			 pstmt.setInt(1, club_num);
			 pstmt.setInt(2, startRow);
			 pstmt.setInt(3, endRow);
			 rs = pstmt.executeQuery();
			 if(rs.next()) {
				 myLeagueList = new ArrayList<F_League_CreateDTO>();
				 do {
					 F_League_CreateDTO dto = new F_League_CreateDTO();
					 dto.setLeague_name(rs.getString("league_name"));
					 dto.setLocation(rs.getString("location"));
					 dto.setJointeam(rs.getInt("jointeam"));
					 dto.setPeriod(rs.getString("period"));
					 dto.setCreater(rs.getString("creater"));
					 dto.setLeagueing(rs.getInt("leagueing"));
					 dto.setLeague_num(rs.getInt("league_num"));
					 myLeagueList.add(dto);
				 }while(rs.next());
			 }
			 
				 
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		return myLeagueList;
	}
		
		
		
		
	
	 
	
	
	
}
