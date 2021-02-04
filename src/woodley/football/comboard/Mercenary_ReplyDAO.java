package woodley.football.comboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Mercenary_ReplyDAO {
	private static Mercenary_ReplyDAO singleton = new Mercenary_ReplyDAO();
	private Mercenary_ReplyDAO() {}
	public static Mercenary_ReplyDAO getInstance() {return singleton;}
	
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
	// 해당글의 댓글 불러오기
	public List getReply(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List replyList = new ArrayList();
		Mercenary_ReplyDTO dto = null;
		try {
			conn = getConnection();
			String sql = "SELECT * FROM mercenary_reply WHERE ref=? ORDER BY ref_num ASC, reg ASC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new Mercenary_ReplyDTO();
				dto.setNum(rs.getInt("num"));
				dto.setRef(rs.getInt("ref"));
				dto.setRef_num(rs.getInt("ref_num"));
				dto.setRef_step(rs.getInt("ref_step"));
				dto.setReplyto(rs.getString("replyto"));
				dto.setWriter(rs.getString("writer"));
				dto.setContent(rs.getString("content"));
				dto.setReg(rs.getTimestamp("reg"));
				replyList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return replyList;
	}
	
	// 게시글의 댓글 입력/대댓글 입력 통합
	public boolean insertReply(Mercenary_ReplyDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			int number=0;
			String sql;
			//게시글의 댓글일 경우 ref_num에 들어갈 숫자 구하기
			if(dto.getRef_num()==-1) { 
				sql = "select max(num) from mercenary_reply";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()) number = rs.getInt(1) + 1;
				else number = 1;
			}
			// 댓글 입력
			sql = "INSERT INTO mercenary_reply VALUES (mercenary_reply_seq.nextVal, ?, ?, ?, ?, ?, ?, sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getRef());
			pstmt.setInt(2, (dto.getRef_num()==-1) ? number : dto.getRef_num());
			pstmt.setInt(3, dto.getRef_step());
			pstmt.setString(4, dto.getReplyto());
			pstmt.setString(5, dto.getWriter());
			pstmt.setString(6, dto.getContent());
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return false;
	}
		
	// 댓글의 삭제
	public boolean deleteReply(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "delete from mercenary_reply where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// 게시글의 모든 댓글의 삭제-Mercenary_BoardDAO에서 게시글 지워질때 같이 지워짐
	public boolean deleteAllReply(int ref) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "delete from mercenary_reply where ref=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ref);
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
}
