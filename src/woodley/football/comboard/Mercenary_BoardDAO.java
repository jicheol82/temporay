package woodley.football.comboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Mercenary_BoardDAO {
	private static Mercenary_BoardDAO singleton = new Mercenary_BoardDAO();
	private Mercenary_BoardDAO() {}
	public static Mercenary_BoardDAO getInstance() {return singleton;}
	
	private Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		Context env = (Context) ctx.lookup("java:comp/env");
		DataSource ds = (DataSource) env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs!=null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
		if(pstmt!=null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
		if(conn!=null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
	}
	
	// 현재 페이지에 표시할 글목록 가져오기
	public List getArticles(int startRow, int endRow) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List articleList = new ArrayList();
		Mercenary_BoardDTO dto = null;
		try {
			conn = getConnection();
			String sql = "SELECT * FROM (SELECT a.*, rownum r FROM (SELECT * FROM mercenary_board ORDER BY reg DESC) a) WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new Mercenary_BoardDTO();
				dto.setNum(rs.getInt("num"));
				dto.setBulletPoint(rs.getString("bulletpoint"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setTname(rs.getString("tname"));
				dto.setContent(rs.getString("content"));
				dto.setImg(rs.getString("img"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setReg(rs.getTimestamp("reg"));
				articleList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return articleList;
	}
	
	// 현재 페이지에 표시할 검색된 글목록 가져오기
	public List getArticles(int startRow, int endRow, String sel, String search) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List articleList = new ArrayList();
		Mercenary_BoardDTO dto = null;
		try {
			conn = getConnection();
			String sql;
			if("title_content".equals(sel)) {
				sql = "SELECT * FROM (SELECT a.*, rownum r FROM (SELECT * FROM mercenary_board WHERE (title || content) LIKE '%"+search+"%' ORDER BY reg DESC) a) WHERE r>=? AND r<=?";
			}else {
				sql = "SELECT * FROM (SELECT a.*, rownum r FROM (SELECT * FROM mercenary_board WHERE "+sel+" LIKE '%"+search+"%' ORDER BY reg DESC) a) WHERE r>=? AND r<=?";
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new Mercenary_BoardDTO();
				dto.setNum(rs.getInt("num"));
				dto.setBulletPoint(rs.getString("bulletpoint"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setTname(rs.getString("tname"));
				dto.setContent(rs.getString("content"));
				dto.setImg(rs.getString("img"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setReg(rs.getTimestamp("reg"));
				articleList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return articleList;
	}

	// Mercenary_Board에 있는 모든 게시글의 수
	public int getNumOfArticles() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select count(*) from mercenary_board";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {return rs.getInt(1);}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return -1;
	}
	
	// Mercenary_Board에 있는 검색 글의 갯수
	public int getNumOfArticles(String sel, String search) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql;
			if(sel.equals("title_content")) {
				sql = "select count(*) from mercenary_board where (title || content) like '%"+sel+"%'";
			}else {
				sql = "select count(*) from mercenary_board where "+sel+" like '%"+sel+"%'";
			}
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {return rs.getInt(1);}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return -1;
	}
	
	// mercenary_board에서 선택된 글을 삭제한다.
	public boolean deleteArticles(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "delete from mercenary_board where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			if(pstmt.executeUpdate()>0) {
				if(Mercenary_ReplyDAO.getInstance().deleteAllReply(num))
					return true;
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// recruitBoardWriteForm에서 작성된 글을 등록한다.
	public boolean insertArticle(Mercenary_BoardDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "INSERT INTO MERCENARY_BOARD VALUES (mercenary_seq.nextVal,?,?,?,?,?,?,default,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBulletPoint());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getWriter());
			pstmt.setString(4, dto.getTname());
			pstmt.setString(5, dto.getContent());
			pstmt.setString(6, dto.getImg());
			if(0<pstmt.executeUpdate()) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
		
	// 선택된 num의 글의 내용을 가져온다.
	public Mercenary_BoardDTO getArticle(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Mercenary_BoardDTO dto = null;
		try {
			conn = getConnection();
			// 조회수 증가
			String sql = "update mercenary_board set readcount=readcount+1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			boolean result = pstmt.executeUpdate()>0?true:false;
			// 글가져오기
			dto = new Mercenary_BoardDTO();
			sql = "select * from mercenary_board where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while(rs.next() && result) {
				dto.setNum(rs.getInt("num"));
				dto.setBulletPoint(rs.getString("bulletpoint"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setTname(rs.getString("tname"));
				dto.setContent(rs.getString("content"));
				dto.setImg(rs.getString("img"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return dto;
	}
	
	// mercenaryBoardModifyForm에서 수정된 글을 등록한다.
	public boolean modifyArticle(Mercenary_BoardDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "UPDATE MERCENARY_BOARD SET bulletpoint=?, title=? ,content=?, img=?, readcount=readcount+1 where writer=? and num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getBulletPoint());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getImg());
			pstmt.setString(5, dto.getWriter());
			pstmt.setInt(6, dto.getNum());
			if(0<pstmt.executeUpdate()) {return true;}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
}