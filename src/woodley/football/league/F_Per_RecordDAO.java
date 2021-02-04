package woodley.football.league;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import woodley.main.member.MemberDAO;
import woodley.main.member.MemberDTO;

public class F_Per_RecordDAO {
	
	private static F_Per_RecordDAO instance = new F_Per_RecordDAO();
	private F_Per_RecordDAO() {}
	public static F_Per_RecordDAO getInstance() {return instance;}
	
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	
	public void inputPer_Record(int League_num, int club_num, String name) {
		Connection conn= null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "insert into f_perrecord values(?,0,0,0,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setInt(2, League_num);
			pstmt.setInt(3, club_num);
			pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
	}
	
	public List<MemberDTO> getUserInfo(int club_num) { // 클럽번호로 유저목록 가져오기
		Connection conn= null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<MemberDTO> memList = null;
		
		try {
			conn = getConnection();
			String sql = "select * from members where clubnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, club_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				memList = new ArrayList<MemberDTO>();
				do {
					MemberDTO memdto = new MemberDTO();
					memdto.setId(rs.getString("id"));
					memdto.setName(rs.getString("name"));
					memdto.setProfile(rs.getString("profile"));
					memdto.setClubnum(rs.getInt("clubnum"));
					memList.add(memdto);
				}while(rs.next());
			}
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return memList;
	}
	
	public List<F_Per_RecordDTO> getPerRecord(int Leauge_num, int startRow, int endRow) { // 리그 참가중인 전체 선수 목록 가져오기
		Connection conn= null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<F_Per_RecordDTO> allUserList = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT * FROM " + 
					"(SELECT alldata2.*, rownum r from " + 
					"(SELECT alldata1.*, rank() over(ORDER BY goals desc) ranked from " + 
					"(SELECT fper.*, cc.tname FROM \r\n" + 
					"(SELECT * FROM F_PERRECORD WHERE LEAGUE_NUM=?)fper, club_create cc " + 
					"WHERE cc.CLUBNUM = fper.club_num)alldata1)alldata2) WHERE r >=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Leauge_num);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				allUserList = new ArrayList<F_Per_RecordDTO>();
				do {
					F_Per_RecordDTO perdto = new F_Per_RecordDTO();
					perdto.setName(rs.getString("player"));
					perdto.setTname(rs.getString("tname"));
					perdto.setGoals(rs.getInt("goals"));
					perdto.setAssist(rs.getInt("assist"));
					perdto.setPlayed(rs.getInt("played"));
					perdto.setLeague_num(rs.getInt("league_num"));
					perdto.setClub_num(rs.getInt("club_num"));
					perdto.setRanked(rs.getInt("ranked"));
					allUserList.add(perdto);
					
					
				}while(rs.next());
					
				
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return allUserList;
	}
	
	public List<F_Per_RecordDTO> getPerRecord(int Leauge_num, int club_num, int startRow, int endRow ) { // 리그참가중인 선택된 팀 선수만 불러오기
		Connection conn= null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<F_Per_RecordDTO> allUserList = null;
		
		try {
			
			conn = getConnection();
			String sql = "SELECT * FROM " + 
					"(SELECT alldata2.*, rownum r from " + 
					"(SELECT alldata1.*, rank() over(ORDER BY goals desc) ranked from " + 
					"(SELECT fper.*, cc.tname FROM " + 
					"(SELECT * FROM F_PERRECORD WHERE LEAGUE_NUM=? AND CLUB_NUM=?)fper, club_create cc " + 
					"WHERE cc.CLUBNUM = fper.club_num)alldata1)alldata2) WHERE r >=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Leauge_num);
			pstmt.setInt(2, club_num);
			pstmt.setInt(3, startRow);
			pstmt.setInt(4, endRow);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				allUserList = new ArrayList<F_Per_RecordDTO>();
				do {
					F_Per_RecordDTO perdto = new F_Per_RecordDTO();
					perdto.setName(rs.getString("player"));
					perdto.setTname(rs.getString("tname"));
					perdto.setGoals(rs.getInt("goals"));
					perdto.setAssist(rs.getInt("assist"));
					perdto.setPlayed(rs.getInt("played"));
					perdto.setLeague_num(rs.getInt("league_num"));
					perdto.setClub_num(rs.getInt("club_num"));
					perdto.setRanked(rs.getInt("ranked"));
					allUserList.add(perdto);
					
					
				}while(rs.next());
					
				
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return allUserList;
	}
	
	public int allCount(int League_num) {
		int count = 0;
		Connection conn= null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from F_PERRECORD where league_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return count;
	}
	
	public int teamCount(int League_num, int club_num) {
		int count = 0;
		Connection conn= null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from F_PERRECORD where league_num=? and club_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			pstmt.setInt(2, club_num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return count;
	}
	
	
	public void modifyPerRecord(F_Per_RecordDTO perDTO) {
		Connection conn= null;
		PreparedStatement pstmt = null;
		
		
		
		try {
			conn = getConnection();
			String sql = "update f_perrecord set played=?, goals=?, assist=? where league_num=? and club_num=? and player=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, perDTO.getPlayed());
			pstmt.setInt(2, perDTO.getGoals());
			pstmt.setInt(3, perDTO.getAssist());
			
			pstmt.setInt(4, perDTO.getLeague_num());
			pstmt.setInt(5, perDTO.getClub_num());
			pstmt.setString(6, perDTO.getName());
			pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	public String getProfile(String name, int club_num) {
		String profile = "";
		Connection conn= null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "select profile from members where name=? and clubnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setInt(2, club_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				profile = rs.getString("profile");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return profile;
	}
}
