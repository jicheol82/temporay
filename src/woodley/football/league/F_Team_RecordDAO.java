package woodley.football.league;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class F_Team_RecordDAO {
	private static F_Team_RecordDAO instance = new F_Team_RecordDAO();
	private F_Team_RecordDAO() {}
	public static F_Team_RecordDAO getInstance() { return instance; } // 싱글턴
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	public void createRecord(int League_num, int club_num) { // 리그 참가 수락하면 바로 팀랭크에 등록 
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = getConnection();
			String sql = "insert into f_team_record(league_num, club_num) values(?,?)";
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
	
	public void updateTeamRank(F_Team_RecordDTO dto) { // 경기 결과 등록하면 팀랭크에 반영
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			
			conn = getConnection();
			String sql = "update f_team_record set played=played+?, gf=gf+?, won=won+?, drawn=drawn+?,"
					+ "lost=lost+?, goals=goals+?, runs=runs+?, gd=gd+? where league_num=? and club_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getPlayed());
			pstmt.setInt(2, dto.getGf());
			pstmt.setInt(3, dto.getWon());
			pstmt.setInt(4, dto.getDrwn());
			pstmt.setInt(5, dto.getLost());
			pstmt.setInt(6, dto.getGoals());
			pstmt.setInt(7, dto.getRuns());
			pstmt.setInt(8, dto.getGd());
			pstmt.setInt(9, dto.getLeague_num());
			pstmt.setInt(10, dto.getClub_num());
			pstmt.executeUpdate();
			
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
	}
	
	public List<F_Team_RecordDTO> teamRankList(int league_num) { // 승점 높은 리그 순위 
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<F_Team_RecordDTO> teamrankList = null;
		try {
			
			conn = getConnection();
			String sql = "SELECT alldata.*, rownum r from " + 
					"(SELECT ftr.*, rank() over(order by gf desc, played asc, gd desc) ranked " + 
					"FROM (SELECT * FROM F_TEAM_RECORD WHERE LEAGUE_NUM=?) ftr) alldata";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, league_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				teamrankList = new ArrayList<F_Team_RecordDTO>();
				do {
					F_Team_RecordDTO dto = new F_Team_RecordDTO();
					dto.setRanked(rs.getInt("ranked"));
					dto.setLeague_num(rs.getInt("league_num"));
					dto.setClub_num(rs.getInt("club_num"));
					dto.setPlayed(rs.getInt("played"));
					dto.setGf(rs.getInt("gf"));
					dto.setWon(rs.getInt("won"));
					dto.setDrwn(rs.getInt("drawn"));
					dto.setLost(rs.getInt("lost"));
					dto.setGoals(rs.getInt("goals"));
					dto.setRuns(rs.getInt("runs"));
					dto.setGd(rs.getInt("gd"));
					teamrankList.add(dto);
				}while(rs.next());
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		return teamrankList;
	}
	
	public void deleteTeamRank(int League_num, int club_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "delete f_team_record where league_num=? and club_num=?";
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
}
