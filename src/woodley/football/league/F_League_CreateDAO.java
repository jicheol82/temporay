package woodley.football.league;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import woodley.football.fmatch.FMatchDTO;

public class F_League_CreateDAO {
	
	private static F_League_CreateDAO instance = new F_League_CreateDAO();
	private F_League_CreateDAO() {}
	public static F_League_CreateDAO getInstance() { return instance; } // 싱글턴
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	// 리그생성
	public void create_League(F_League_CreateDTO dto) { 
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "insert into F_league(League_num,League_name, period, jointeam, location, banner, content, reg, creater)"
					+ " values(League_num.nextval,?,?,?,?,?,?,sysdate,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getLeague_name());
			pstmt.setString(2, dto.getPeriod());
			pstmt.setInt(3, dto.getJointeam());
			pstmt.setString(4, dto.getLocation());
			pstmt.setString(5, dto.getBanner());
			pstmt.setString(6, dto.getContent());
			pstmt.setString(7, dto.getCreater());
			pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		
	}
	// 생성된 전체 리그목록 불러오기
	public List<F_League_CreateDTO> getF_League_List(int startRow, int endRow) { 
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<F_League_CreateDTO> allList = null;
		try {
			conn = getConnection();
			String sql = "SELECT * " + 
					"FROM (SELECT rownum r, f.* FROM (SELECT * FROM F_LEAGUE ORDER BY reg DESC) f)" + 
					"WHERE r >=? AND r <=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				allList = new ArrayList<F_League_CreateDTO>();
				do {
					F_League_CreateDTO dto = new F_League_CreateDTO();
					dto.setLeague_num(rs.getInt("League_num"));
					dto.setLeague_name(rs.getString("League_name"));
					dto.setJointeam(rs.getInt("jointeam"));
					dto.setPeriod(rs.getString("period"));
					dto.setLeagueing(rs.getInt("leagueing"));
					dto.setCreater(rs.getString("creater"));
					dto.setContent(rs.getString("content"));
					dto.setLocation(rs.getString("location"));
					dto.setBanner(rs.getString("banner"));
					dto.setReg(rs.getTimestamp("reg"));
					allList.add(dto);
				}while(rs.next());
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		return allList;
	} // 생성된리그 최신순으로 보여주기
	
	// 조건 검색된 리그 목록 가져오기
	public List getF_League_List(int startRow, int endRow, String location, int ing, String search) {
		List searchList = null;
		F_League_CreateDTO dto = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			searchList = new ArrayList();
			conn = getConnection();
			String all = "%";
			String sql = "select * from (select a.*, rownum r from (select * from (SELECT * FROM F_league WHERE leagueing like '"+(ing==-1?all:ing)+"') where location like '%"+location+"%')a WHERE league_name LIKE '%"+search+"%' order by reg) where r>=? and r<=? ";
			//"SELECT * FROM (SELECT rownum r, f.* FROM (SELECT * FROM F_LEAGUE ORDER BY reg DESC)f where location=?) WHERE r >=? AND r <=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new F_League_CreateDTO();
				dto.setLeague_num(rs.getInt("League_num"));
				dto.setLeague_name(rs.getString("League_name"));
				dto.setJointeam(rs.getInt("jointeam"));
				dto.setPeriod(rs.getString("period"));
				dto.setLeagueing(rs.getInt("leagueing"));
				dto.setCreater(rs.getString("creater"));
				dto.setContent(rs.getString("content"));
				dto.setLocation(rs.getString("location"));
				dto.setBanner(rs.getString("banner"));
				dto.setReg(rs.getTimestamp("reg"));
				searchList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		return searchList;
	}

	public int LeagueCount() { // 생성된 리그 갯수 
		int max = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from F_league";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				max = rs.getInt(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		
		return max;
	}
	// 조건에 맞는 리그의 갯수
	public int LeagueCount(String location, int ing, String search) { 
		int max = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String all = "%";
			String sql = "select count(*) from (select * from (select * from F_league WHERE leagueing like '"+(ing==-1?all:ing)+"') where location like '%"+location+"%') where league_name like '%"+search+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				max = rs.getInt(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		return max;
	}
	
	
	
	public F_League_CreateDTO getInfoLeague(int num) { // 리그 정보가져오기
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		F_League_CreateDTO dto = null;
		try {
			conn = getConnection();
			String sql = "select * from F_League where league_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			
			if(rs.next()) {
				dto = new F_League_CreateDTO();
				dto.setLeague_num(rs.getInt(1));
				dto.setLeague_name(rs.getString(2));
				dto.setJointeam(rs.getInt(3));
				dto.setPeriod(rs.getString(4));
				dto.setLeagueing(rs.getInt(5));
				dto.setCreater(rs.getString(6));
				dto.setContent(rs.getString(7));
				dto.setLocation(rs.getString(8));
				dto.setBanner(rs.getString(9));
				dto.setReg(rs.getTimestamp(10));
				
				
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
	
	public int getLeaguemaxnum() { // 리그번호부여
		int max = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "select max(league_num) max from F_league";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				max = rs.getInt(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		
		
		return max;
 	}
	
	public void LeagueModify(F_League_CreateDTO dto) { // 리그 수정
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "update F_league set banner=?, League_name=?, period=?, jointeam=?, location=?,"
					+ "Leagueing=?, content=? where League_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBanner());
			pstmt.setString(2, dto.getLeague_name());
			pstmt.setString(3, dto.getPeriod());
			pstmt.setInt(4, dto.getJointeam());
			pstmt.setString(5, dto.getLocation());
			pstmt.setInt(6, dto.getLeagueing());
			pstmt.setString(7, dto.getContent());
			pstmt.setInt(8, dto.getLeague_num());
			pstmt.executeUpdate();
			
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
	}
	
	
			
}
