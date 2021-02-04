package woodley.football.fmatch;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class FMatchDAO {
	private static FMatchDAO singleton = new FMatchDAO();
	private FMatchDAO() {}
	public static FMatchDAO getInstance() {return singleton;}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context) ctx.lookup("java:comp/env");
		DataSource ds = (DataSource) env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs!=null) try {rs.close();} catch(Exception e){e.printStackTrace();}
		if(pstmt!=null) try {pstmt.close();} catch(Exception e){e.printStackTrace();}
		if(conn!=null) try {conn.close();} catch(Exception e){e.printStackTrace();}
	}
	
	// 친선경기 등록
	public boolean createFMatch(FMatchDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into fmatch values (fmatch_seq.nextVal,?,?,default,?,?,?,?,?,?,default)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getTname());
			pstmt.setString(3, dto.getGamedate());
			pstmt.setString(4, dto.getGametime());
			pstmt.setString(5, dto.getHomeground());
			pstmt.setString(6, dto.getUniformcolor());
			pstmt.setString(7, dto.getLocation());	
			pstmt.setString(8, dto.getContent());
			if(0<pstmt.executeUpdate()) return true;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, null);
		}
		return false;
	}
	
	// 친선경기 검색(1. 특정일 & 지역)
	public List findFMatch(String selectDate, String location) {
		List fmatchList = null;
		FMatchDTO dto = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			fmatchList = new ArrayList();
			conn = getConnection();
			String sql = "select * from (SELECT * FROM fmatch WHERE gamedate=?) WHERE location LIKE '%"+location+"%' order by gamedate";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, selectDate);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new FMatchDTO();
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setTname(rs.getString("tname"));
				dto.setState(rs.getInt("state"));
				dto.setGamedate(rs.getString("gamedate"));
				dto.setGametime(rs.getString("gametime"));
				dto.setHomeground(rs.getString("homeground"));
				dto.setUniformcolor(rs.getString("uniformcolor"));
				dto.setLocation(rs.getString("location"));
				dto.setContent(rs.getString("content"));
				dto.setReg(rs.getTimestamp("reg"));
				fmatchList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return fmatchList;
	}
	
	// 친선경기 검색(2. 기간 & 지역)
	public List findFMatch(String fromDate, String toDate, String location) {
		List fmatchList = null;
		FMatchDTO dto = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			fmatchList = new ArrayList();
			conn = getConnection();
			String sql = "SELECT * FROM (SELECT * FROM fmatch WHERE gamedate>? and gamedate<?) WHERE location LIKE "+"'%"+location+"%' order by gamedate";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, fromDate);
			pstmt.setString(2, toDate);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new FMatchDTO();
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setTname(rs.getString("tname"));
				dto.setState(rs.getInt("state"));
				dto.setGamedate(rs.getString("gamedate"));
				dto.setGametime(rs.getString("gametime"));
				dto.setHomeground(rs.getString("homeground"));
				dto.setUniformcolor(rs.getString("uniformcolor"));
				dto.setLocation(rs.getString("location"));
				dto.setContent(rs.getString("content"));
				dto.setReg(rs.getTimestamp("reg"));
				fmatchList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return fmatchList;
	}
	
	// 친선경기내용 가져오기
	public FMatchDTO getFMatch(int num) {
		FMatchDTO dto = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select * from fmatch WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto = new FMatchDTO();
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setTname(rs.getString("tname"));
				dto.setState(rs.getInt("state"));
				dto.setGamedate(rs.getString("gamedate"));
				dto.setGametime(rs.getString("gametime"));
				dto.setHomeground(rs.getString("homeground"));
				dto.setUniformcolor(rs.getString("uniformcolor"));
				dto.setLocation(rs.getString("location"));
				dto.setContent(rs.getString("content"));
				dto.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return dto;
	}
	
	// 친선경기 내용 수정(진행상황 변경 불포함)
	// 작성자 중간에 동호회 바뀌는것 고려 안함
	public boolean modifyFMatch(FMatchDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "update fmatch set gamedate=?, gametime=?, homeground=?, "
					+ "uniformcolor=?, location=?, content=?, tname=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getGamedate());
			pstmt.setString(2, dto.getGametime());
			pstmt.setString(3, dto.getHomeground());
			pstmt.setString(4, dto.getUniformcolor());
			pstmt.setString(5, dto.getLocation());	
			pstmt.setString(6, dto.getContent());
			pstmt.setString(7, dto.getTname());
			pstmt.setInt(8, dto.getNum());
			if(0<pstmt.executeUpdate()) {return true;}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// 친선경기 삭제
	// 이 메소드가 실행되는건 자기가 생성한 게임에서만
	public boolean deleteFMatch(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "delete from fmatch where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			if(0<pstmt.executeUpdate()) {return true;}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, null);
		}
		return false;
	}
	
	// 수락 후 경기 상태 바꾸기
	public boolean changeState(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "update fmatch set state=1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			if(0<pstmt.executeUpdate()) {return true;}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// tname으로 emblem가져오기
	// 원래는 club_createDAO에 있어야 함
	public String findEmblem(String tname) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select emblem from club_create where tname=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, tname);
			rs = pstmt.executeQuery();
			if(rs.next()) {return rs.getString(1);}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return null;
	}
}
