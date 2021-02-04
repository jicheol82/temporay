package woodley.main.message;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MessageDAO {
	private static MessageDAO singleton = new MessageDAO();
	private MessageDAO() {}
	public static MessageDAO getInstance() {return singleton;}
	
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
	
	// 쪽지 보내기(등록)
	public boolean sendMessage(MessageDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into message values(message_seq.nextVal, default, ?, ?, ?, sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getSender());
			pstmt.setString(2, dto.getReceiver());
			pstmt.setString(3, dto.getContent());
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// 쪽지 리스트 가져오기
	public List getMyMessageList(String id, String cond) {
		List messageList = new ArrayList();
		MessageDTO dto = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql="";
			if("sender".equals(cond)) { // 보낸쪽지
				sql = "select * from message where sender=? order by reg";
			}else if("receiver".equals(cond)) { // 내가 지운 받은쪽지(state=2)은 표시 안함
				sql = "select * from message where receiver=? and state!=2 order by reg";
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new MessageDTO();
				dto.setNum(rs.getInt("num"));
				dto.setState(rs.getInt("state"));
				dto.setSender(rs.getString("sender"));
				dto.setReceiver(rs.getString("receiver"));
				dto.setContent(rs.getString("content"));
				dto.setReg(rs.getTimestamp("reg"));
				messageList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return messageList;
	}
	
	// 쪽지 가져오기
	public MessageDTO getMessage(int num) {
		MessageDTO dto = new MessageDTO();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql="select * from message where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto.setNum(rs.getInt("num"));
				dto.setState(rs.getInt("state"));
				dto.setSender(rs.getString("sender"));
				dto.setReceiver(rs.getString("receiver"));
				dto.setContent(rs.getString("content"));
				dto.setReg(rs.getTimestamp("reg"));
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return dto;
	}

	// 쪽지 읽음 상태 변경하기
	public boolean changeState(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "update message set state=1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// 쪽지 삭제
	public boolean deleteMessage(int[] num, String cond) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql="";
			int count=0;
			if(cond.equals("sender")) { // 상대방이 쪽지를 안읽었을 때(state=0)와 상대방이 쪽지를 지웟을 때 (state=2)만 삭제 가능
				sql = "delete from (select * from message where num=?) where state=0 or state=2";
			}else if(cond.equals("receiver")) { // 쪽지를 받은이는 언제든 지울 수 있다(state=2로 바꾼다)
				sql = "update message set state=2 where num=?";
			}
			pstmt = conn.prepareStatement(sql);
			//쪽지 한번에 여러개 지우는건 구현 안했음.
			for(int i:num) {
				pstmt.setInt(1, i);
				if(pstmt.executeUpdate()>0) count++;
			}
			if(count==num.length) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
}
