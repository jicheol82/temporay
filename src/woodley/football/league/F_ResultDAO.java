package woodley.football.league;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class F_ResultDAO {
	private static F_ResultDAO instance = new F_ResultDAO();
	private F_ResultDAO() {}
	public static F_ResultDAO getInstance() { return instance; } // 싱글턴
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	public void insertResult(F_ResultDTO dto) { // 경기등록
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			
			conn = getConnection();
			String sql = "insert into f_result(result_num, league_num, matchday,matchtime, homeclubnum, awayclubnum) "
					+ "values(result_num_seq.nextval,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getLeague_num());
			pstmt.setString(2, dto.getMatchday());
			pstmt.setString(3, dto.getMatchtime());
			pstmt.setInt(4, dto.getHomeclubnum());
			pstmt.setInt(5, dto.getAwayclubnum());
			pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
	}
	
	public List<F_ResultDTO> getResult(int League_num) { // 저장된 경기일정 목록 불러오기
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<F_ResultDTO> resultList = null;
		
		try {
			conn = getConnection();
			String sql = "select * from f_result where league_num=? order by matchday desc";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, League_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				resultList = new ArrayList<F_ResultDTO>();
				do {
					F_ResultDTO dto = new F_ResultDTO();
					dto.setResult_num(rs.getInt("result_num"));
					dto.setLeague_num(rs.getInt("League_num"));
					dto.setMatchday(rs.getString("matchday"));
					dto.setMatchtime(rs.getString("matchtime"));
					dto.setHomeclubnum(rs.getInt("homeclubnum"));
					dto.setAwayclubnum(rs.getInt("awayclubnum"));
					dto.setHomescore(rs.getInt("homescore"));
					dto.setAwayscore(rs.getInt("awayscore"));
					dto.setState(rs.getInt("state"));
					resultList.add(dto);
				}while(rs.next());
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null) try { rs.close();}catch(Exception e) { e.printStackTrace(); }
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
		
		return resultList;
	}
	
	public void resultcomplete(int result_num, int homescore, int awayscore) { // 경기등록 완료
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "update f_result set homescore=?, awayscore=?, state=1 where result_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, homescore);
			pstmt.setInt(2, awayscore);
			pstmt.setInt(3, result_num);
			pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null) try { pstmt.close();}catch(Exception e) { e.printStackTrace(); }
			if(conn != null) try { conn.close();}catch(Exception e) { e.printStackTrace(); }
		}
	}
	
	
	

	
}
