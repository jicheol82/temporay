package woodley.main.bcity;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class B_CityDAO {
	private static B_CityDAO singleton = new B_CityDAO();
	private B_CityDAO() {}
	public static B_CityDAO getInstance() {return singleton;}
	
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
	// 각 지방 정보 호출
	public List callBcity() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List dtoList = null;
		B_CityDTO dto = null;
		try {
			conn = getConnection();
			String sql = "select * from b_city";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			dtoList = new ArrayList();
			while(rs.next()) {
				dto = new B_CityDTO();
				dto.setCity_name(rs.getString("city_name"));
				dto.setCity_num(rs.getInt("city_num"));
				dtoList.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, rs);
		}
		return dtoList;
	}
	
	
}
