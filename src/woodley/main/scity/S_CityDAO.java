package woodley.main.scity;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class S_CityDAO {
	private static final Object List = null;
	private static S_CityDAO singleton = new S_CityDAO();
	private S_CityDAO() {}
	public static S_CityDAO getInstance() {return singleton;}
	
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
	// 이거는 사용법을 모르겠음.
	// selection1에서 고른 값으로 해당 지방의 시/구 정보를 가져와야 하는데
	// javascipt에서 끝낼 수 없음. ajax?필요?
	// 그래서 table전체를 가져오는 메소드를 다시 아래에 만듦.
	public List getCities(int city_num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List cityList = new ArrayList();
		try {
			conn = getConnection();
			String sql = "select * from s_city where b_citynum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, city_num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				do {
					S_CityDTO dto = new S_CityDTO();
					dto.setB_cityNum(rs.getInt("b_citynum"));
					dto.setS_cityName(rs.getString("s_cityname"));
					dto.setS_cityNum(rs.getInt("s_citynum"));
					cityList.add(dto);
					
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, rs);
		}
		return cityList;
	}
	// 시군 전체 가져오기
	public List getAllCities() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List cityList = new ArrayList();
		try {
			conn = getConnection();
			String sql = "select * from s_city";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				cityList.add(rs.getString("s_cityname"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			close(conn, pstmt, rs);
		}
		return cityList;
	}
}
