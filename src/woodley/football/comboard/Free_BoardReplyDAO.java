package woodley.football.comboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Free_BoardReplyDAO {
	
	//싱글톤
	private static Free_BoardReplyDAO instance = new Free_BoardReplyDAO();
	private Free_BoardReplyDAO() {}
	public static Free_BoardReplyDAO getInstance() { return instance; }
	   
	   
	//db연결
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if(rs!=null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
		if(pstmt!=null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
		if(conn!=null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
	}
	
	//댓글 불러오기
	public List getReply(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List replyList = new ArrayList();
		Free_BoardReplyDTO dto = null;
		try {
			conn = getConnection();
			String sql = "SELECT * FROM free_board_reply WHERE ref=? ORDER BY ref_num ASC, reg ASC";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new Free_BoardReplyDTO();
				dto.setFree_board_reply_num(rs.getInt("free_board_reply_num"));
				dto.setRef(rs.getInt("ref"));
				dto.setRef_num(rs.getInt("ref_num"));
				dto.setRef_step(rs.getInt("ref_step"));
				dto.setReplyto(rs.getString("replyto"));
				dto.setWriter(rs.getString("writer"));
				dto.setContent(rs.getString("content"));
				dto.setReg(rs.getTimestamp("reg"));
				replyList.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally{
			if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return replyList;
	}
	
	//댓글 갯수 리턴하는 메서드
	public int getReplyCount() {
		int x = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			   
		try {
			conn = getConnection();
			String sql = "select count(*) from free_board_reply";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				x = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return x;
	}
	
	// 게시글의 댓글 입력
		public boolean insertReply(Free_BoardReplyDTO dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				// ref_num에 들어갈 숫자 구하기
				conn = getConnection();
				String sql = "select max(free_board_reply_num) from free_board_reply";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				int number;
				if(rs.next()) number = rs.getInt(1) + 1;
				else number = 1;
			
				// 댓글 입력
				sql = "INSERT INTO free_board_reply VALUES (free_board_reply_seq.nextVal, ?, ?, ?, ?, ?, ?, sysdate)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getRef());
				pstmt.setInt(2, number);
				pstmt.setInt(3, dto.getRef_step());
				pstmt.setString(4, dto.getReplyto());
				pstmt.setString(5, dto.getWriter());
				pstmt.setString(6, dto.getContent());
				
				if(pstmt.executeUpdate()>0) return true;
			}catch(Exception e) {e.printStackTrace();}
			finally {close(conn, pstmt, rs);}
			System.out.println("댓글입력되냐");
			return false;
		}
		
		// 댓글의 댓글
		public boolean insertReReply(Free_BoardReplyDTO dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql = "INSERT INTO free_board_reply VALUES (free_board_reply_seq.nextVal, ?, ?, ?, ?, ?, ?, sysdate)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getRef());
				pstmt.setInt(2, dto.getRef_num());
				pstmt.setInt(3, dto.getRef_step());
				pstmt.setString(4, dto.getReplyto());
				pstmt.setString(5, dto.getWriter());
				pstmt.setString(6, dto.getContent());
				if(pstmt.executeUpdate()>0) return true;
			}catch(Exception e) {e.printStackTrace();}
			finally {close(conn, pstmt, null);}
			return false;
		}
		
		// 댓글의 삭제
		public boolean deleteReply(int num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql = "delete from free_board_reply where free_board_reply_num=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				if(pstmt.executeUpdate()>0) return true;
			}catch(Exception e) {e.printStackTrace();}
			finally {close(conn, pstmt, null);}
			return false;
		}
		
		// 게시글의 모든 댓글의 삭제
			public boolean deleteAllReply(int ref) {
				Connection conn = null;
				PreparedStatement pstmt = null;
				try {
					conn = getConnection();
					String sql = "delete from free_board_reply where ref=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, ref);
					if(pstmt.executeUpdate()>0) return true;
				}catch(Exception e) {e.printStackTrace();}
				finally {close(conn, pstmt, null);}
				return false;
			}

}
