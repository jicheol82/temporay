package woodley.main.alert;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import woodley.football.fmatch.FMatchDAO;
import woodley.main.message.MessageDAO;
import woodley.main.message.MessageDTO;

public class AlertDAO {
	private static AlertDAO singleton = new AlertDAO();
	private AlertDAO() {}
	public static AlertDAO getInstance() {return singleton;}
	
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
	
	// 알람 생성
	public boolean requestAlert(AlertDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "insert into alert values(alert_seq.nextVal, default, ?, ?, ?,?,?,default, sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getSender());
			pstmt.setString(2, dto.getReceiver());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getRequest());
			pstmt.setInt(5, dto.getRef());
			if(pstmt.executeUpdate()>0) return true;
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
	
	// 알람가져오기
	public List getMyAlertList(String id) {
		List alertList = null;
		AlertDTO dto = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			alertList = new ArrayList();
			conn = getConnection();
			String sql="select * from alert where receiver=? order by reg";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto = new AlertDTO();
				dto.setNum(rs.getInt("num"));
				dto.setChecked(rs.getInt("checked"));
				dto.setSender(rs.getString("sender"));
				dto.setReceiver(rs.getString("receiver"));
				dto.setContent(rs.getString("content"));
				dto.setRequest(rs.getString("request"));
				dto.setRef(rs.getInt("ref"));
				dto.setState(rs.getInt("state"));
				dto.setReg(rs.getTimestamp("reg"));
				alertList.add(dto);
			}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, rs);}
		return alertList;
	}
	
	// 수락/거부 상태 바꾸기
	public boolean changeState(String request, int ref, int num, int state) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql;
			boolean result = false;
			if("match".equals(request) && state==1) {	// 수락한 경우에만 fmatch db에 state를 변경한다
				result = FMatchDAO.getInstance().changeState(ref);
			}else if(false) {	// 수락한 경우에만 해당 request db에 state를 변경한다
				// 동호회 참가 요청
			}else if(false) {	// 수락한 경우에만 해당 request db에 state를 변경한다
				// 리그 참가 요청
			}
			sql = "update alert set checked=1, state=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, state);
			pstmt.setInt(2, num);
			if(pstmt.executeUpdate()>0 && result) {return true;}
		}catch(Exception e) {e.printStackTrace();}
		finally {close(conn, pstmt, null);}
		return false;
	}
}
