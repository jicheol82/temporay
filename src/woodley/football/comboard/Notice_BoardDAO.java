package woodley.football.comboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Notice_BoardDAO {
	private static Notice_BoardDAO singleton = new Notice_BoardDAO();
	private Notice_BoardDAO() {}
	public static Notice_BoardDAO getInstance() {return singleton;}
	
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
		Notice_BoardDTO dto = null;
		try {
			conn = getConnection();
			String sql = "SELECT * FROM (SELECT a.*, rownum r FROM (SELECT * FROM notice_board ORDER BY reg DESC) a) WHERE r>=? AND r<=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new Notice_BoardDTO();
				dto.setNotice_board_num(rs.getInt("notice_board_num"));
				dto.setTitle(rs.getString("title"));
				dto.setId(rs.getString("writer"));
				dto.setReg(rs.getTimestamp("reg"));
				dto.setReadCount(rs.getInt("readcount"));
				dto.setPic(rs.getString("pic"));
				articleList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return articleList;
	}

	// notice_board에 있는 모든 게시글의 수
	public int getNumOfArticles() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select count(*) from notice_board";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) return rs.getInt(1);
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return 0;
	}
	
	// notice_board에서 선택된 글을 삭제한다.
	public boolean deleteArticles(String[] deleteList) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		if(deleteList==null) return false;
		int result=0;
		try {
			conn = getConnection();
			for(String num:deleteList) {
				String sql = "delete from notice_board where notice_board_num=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, num);
				result += pstmt.executeUpdate();
			}
			if(result==deleteList.length) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// noticeBoardWriteForm에서 작성된 글을 등록한다.
	public boolean insertArticle(Notice_BoardDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "INSERT INTO NOTICE_BOARD VALUES (notice_board_num_seq.nextVal, ?, ?, sysdate, 0, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getId());
			pstmt.setString(3, dto.getPic());
			pstmt.setString(4, dto.getContent());
			if(0<pstmt.executeUpdate()) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// 선택된 num의 글의 내용을 가져온다.
	public Notice_BoardDTO getArticle(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Notice_BoardDTO dto = null;
		try {
			conn = getConnection();
			// 조회수 증가
			String sql = "update notice_board set readcount=readcount+1 where notice_board_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			boolean result = pstmt.executeUpdate()>0?true:false;
			// 글가져오기
			dto = new Notice_BoardDTO();
			sql = "select * from notice_board where notice_board_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while(rs.next() && result) {
				dto.setTitle(rs.getString("title"));
				dto.setId(rs.getString("writer"));
				dto.setReg(rs.getTimestamp("reg"));
				dto.setReadCount(rs.getInt("readcount"));
				dto.setPic(rs.getString("pic"));
				dto.setContent(rs.getString("content"));
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return dto;
	}
	
	// noticeBoardModifyForm에서 수정된 글을 등록한다.
	public boolean modifyArticle(Notice_BoardDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "UPDATE NOTICE_BOARD SET title=? , readcount=readcount+1, pic=?, content=? where writer=? and notice_board_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getPic());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getId());
			pstmt.setInt(5, dto.getNotice_board_num());
			if(0<pstmt.executeUpdate()) {return true;}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
}
