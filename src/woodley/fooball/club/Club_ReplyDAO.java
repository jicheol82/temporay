package woodley.fooball.club;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class Club_ReplyDAO {
	
	private static Club_ReplyDAO instance = new Club_ReplyDAO();
	private Club_ReplyDAO() {}
	public static Club_ReplyDAO getInstance() {return instance;}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection(); 
	}
	
	
	//댓글 db에 insert
	public boolean insertReply(Club_ReplyDTO d){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//ref_num에 들어갈 숫자 구하기 (댓글 끼리 그룹핑 해주는 변수) 
			conn = getConnection();
			String sql = "select max(num) from club_reply";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			int number;
			//첫 댓글이 아니면  ref_num = num + 1 
			if(rs.next())number = rs.getInt(1) +1 ;
			//첫 댓글일 때 1
			else number =1;
			
			sql = "insert into club_reply values(club_reply_seq.nextVal, ?, ?, ?, ?, ?, ?, sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, d.getRef());
			//ref_num 값에 위에서 구한 number 넣어줌 
			pstmt.setInt(2, number);
			pstmt.setInt(3, d.getRef_step());
			pstmt.setString(4, d.getReplyto());
			pstmt.setString(5, d.getWriter());
			pstmt.setString(6, d.getContent());
			//물어볼 것 !
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return false;
	}
	
	
	//대댓글 입력
	public boolean insertReReply(Club_ReplyDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into club_reply values (club_reply_seq.nextVal, ?, ?, ?, ?, ?, ?, sysdate) ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getRef()); //몇 번 게시글인지
			pstmt.setInt(2, dto.getRef_num()); //
			pstmt.setInt(3, dto.getRef_step());
			pstmt.setString(4, dto.getReplyto());
			pstmt.setString(5, dto.getWriter());
			pstmt.setString(6, dto.getContent());
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return false;
	}
	
	// 해당글의 댓글 불러오기
		public List getReply(int num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			List replyList = new ArrayList();
			Club_ReplyDTO dto = null;
			try {
				conn = getConnection();
				String sql = "SELECT * FROM club_reply WHERE ref=? ORDER BY ref_num ASC, reg ASC";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					dto = new Club_ReplyDTO();
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
			}catch(Exception e) {
				e.printStackTrace();
			}finally{
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return replyList;
		}
		
		//댓글의 삭제 
		public boolean deleteReply(int num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql = "delete from club_reply where num=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, num);
				if(pstmt.executeUpdate()>0) return true;
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return false;
			
		}
	
}
