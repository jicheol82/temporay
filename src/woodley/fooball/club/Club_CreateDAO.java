package woodley.fooball.club;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Club_CreateDAO {
	private static Club_CreateDAO instance = new Club_CreateDAO();
	private Club_CreateDAO() {}
	public static Club_CreateDAO getInstance() {return instance;}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	//클럽 생성 메서드
	public void insertClub(Club_CreateDTO d) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql ="insert into club_create(clubNum,tName,tNum,tLocal,avrAge,clubEvent,skill,ground,emblem,bio,headId)"
					+ "values(club_create_seq.nextVal,?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, d.gettName());
			pstmt.setInt(2, d.gettNum());
			pstmt.setString(3, d.gettLocal());
			pstmt.setString(4, d.getAvrAge());
			pstmt.setString(5, d.getClubEvent());
			pstmt.setString(6, d.getSkill());
			pstmt.setString(7, d.getGround());
			pstmt.setString(8, d.getEmblem());
			pstmt.setString(9, d.getBio());
			pstmt.setString(10, d.getHeadId());
			
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	//클럽  수 구하는 메서드 
	public int getClubCount() {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			//club_create에 몇개의 행이 있는지 구한다
			String sql = "select count(*) from club_create";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			//결과가 있으면 count 변수에  count(*)의 값을 넣는다.
			if(rs.next()) {
				count = rs.getInt(1);
			}
					
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
		}
		
		return count;
	}
	
	//검색된 클럽 수 구하는 메서드 
	public int getSearchClubCount(String age, String name) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			//club_create에 몇개의 행이 있는지 구한다
			String sql = "select count(*) from club_create where avrAge=? and (tName LIKE '%" +name+ "%' or tLocal like '%" +name+ "%' ) ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, age);
			rs = pstmt.executeQuery();
			//결과가 있으면 count 변수에  count(*)의 값을 넣는다.
			if(rs.next()) {
				count = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
		}
		return count;
	}
	   
	// 범위 주고 게시글 가져오기 (시작글, 마지막 글) 
	public List getClublist(int start, int end) {
			List clubList = null; 
			Connection conn = null; 
			PreparedStatement pstmt =null; 
			ResultSet rs = null; 
			try { 
				conn = getConnection(); 
				String sql ="select clubNum,tName,tNum,tLocal,avrAge,clubEvent,skill,ground,emblem,bio,headId,reg,r from"
						+ " (select clubNum,tName,tNum,tLocal,avrAge,clubEvent,skill,ground,emblem,bio,headId,reg, rownum r from"
						+ " (select clubNum,tName,tNum,tLocal,avrAge,clubEvent,skill,ground,emblem,bio,headId,reg from club_create"
						+ " order by reg desc)"
						+ " order by reg desc) where r>=? and r<=? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start); 
				pstmt.setInt(2, end); 
				rs = pstmt.executeQuery();
				//리스트에 글 한줄 담기
				if(rs.next()) { //rs 가 존재한다면 list 객체 생성해라
					clubList = new ArrayList(); //dto 객체 생성해서 값들을 세팅 해서 articleList에 add 해라 
					do { 
						 Club_CreateDTO club = new Club_CreateDTO(); 
					     club.setClubNum(rs.getInt("clubNum"));
					     club.settName(rs.getString("tName")); 
					     club.settNum(rs.getInt("tNum"));
					     club.settLocal(rs.getString("tLocal"));
					     club.setAvrAge(rs.getString("avrAge"));
					     club.setClubEvent(rs.getString("clubEvent"));
					     club.setSkill(rs.getString("skill"));
					     club.setGround(rs.getString("ground"));
					     club.setEmblem(rs.getString("emblem"));
					     club.setBio(rs.getString("bio"));
					     club.setHeadId(rs.getString("headId")); 
					     club.setReg(rs.getTimestamp("reg")); 
					     clubList.add(club);
					 }while(rs.next()); 
				}
			 }catch(Exception e){ 
				 e.printStackTrace(); 
			 }finally { 
				 if(pstmt != null)try{pstmt.close();}catch(Exception e) {e.printStackTrace();} 
				 if(conn != null)try{conn.close();}catch(Exception e) {e.printStackTrace();} 
				 if(rs != null)try{rs.close();}catch(Exception e) {e.printStackTrace();} 
			} 
			return clubList;
			}
	
	// 범위+ 조건 주고 게시글 가져오기 (시작글, 마지막 글) 
		public List getSearchClublist(int start, int end, String age, String name) {
				List clubList = null; 
				Connection conn = null; 
				PreparedStatement pstmt =null; 
				ResultSet rs = null; 
				try { 
					conn = getConnection(); 
					String sql ="select clubNum,tName,tNum,tLocal,avrAge,clubEvent,skill,ground,emblem,bio,headId,reg,r "
							+ "from(select clubNum,tName,tNum,tLocal,avrAge,clubEvent,skill,ground,emblem,bio,headId,reg, rownum r "
							+ "from(select clubNum,tName,tNum,tLocal,avrAge,clubEvent,skill,ground,emblem,bio,headId,reg "
							+ "from club_create where avrAge=? and (tName LIKE '%" +name+ "%' or tLocal like '%" +name+ "%') order by reg desc)"
							+ " order by reg desc) where r>=? and r<=? ";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, age); 
					pstmt.setInt(2, start); 
					pstmt.setInt(3, end); 
					rs = pstmt.executeQuery();
					//리스트에 글 한줄 담기
					if(rs.next()) { //rs 가 존재한다면 list 객체 생성해라
						clubList = new ArrayList(); //dto 객체 생성해서 값들을 세팅 해서 articleList에 add 해라 
						do { 
							 Club_CreateDTO club = new Club_CreateDTO(); 
						     club.setClubNum(rs.getInt("clubNum"));
						     club.settName(rs.getString("tName")); 
						     club.settNum(rs.getInt("tNum"));
						     club.settLocal(rs.getString("tLocal"));
						     club.setAvrAge(rs.getString("avrAge"));
						     club.setClubEvent(rs.getString("clubEvent"));
						     club.setSkill(rs.getString("skill"));
						     club.setGround(rs.getString("ground"));
						     club.setEmblem(rs.getString("emblem"));
						     club.setBio(rs.getString("bio"));
						     club.setHeadId(rs.getString("headId")); 
						     club.setReg(rs.getTimestamp("reg")); 
						     clubList.add(club);
						 }while(rs.next()); 
					}
				 }catch(Exception e){ 
					 e.printStackTrace(); 
				 }finally { 
					 if(pstmt != null)try{pstmt.close();}catch(Exception e) {e.printStackTrace();} 
					 if(conn != null)try{conn.close();}catch(Exception e) {e.printStackTrace();} 
					 if(rs != null)try{rs.close();}catch(Exception e) {e.printStackTrace();} 
				} 
				return clubList;
		}
		
		//한 개 클럽 정보 가져오기 introClub에서 사용
		public Club_CreateDTO getClub(int clubNum) {
			Club_CreateDTO club = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				//clubNum 이 일치하는 행 가지고 오기 
				String sql="select * from club_create where clubNum=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, clubNum);
				rs = pstmt.executeQuery();
				//clubNum 일치하는 행에 CreateDTO 객체 만들어서 넣어 주기 
				if(rs.next()) {
					club = new Club_CreateDTO();
					club.setClubNum(rs.getInt("clubNum"));
				    club.settName(rs.getString("tName")); 
				    club.settNum(rs.getInt("tNum"));
				    club.settLocal(rs.getString("tLocal"));
				    club.setAvrAge(rs.getString("avrAge"));
				    club.setClubEvent(rs.getString("clubEvent"));
				    club.setSkill(rs.getString("skill"));
				    club.setGround(rs.getString("ground"));
				    club.setEmblem(rs.getString("emblem"));
				    club.setBio(rs.getString("bio"));
				    club.setHeadId(rs.getString("headId")); 
				    club.setReg(rs.getTimestamp("reg")); 
					
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				 if(pstmt != null)try{pstmt.close();}catch(Exception e) {e.printStackTrace();} 
				 if(conn != null)try{conn.close();}catch(Exception e) {e.printStackTrace();} 
				 if(rs != null)try{rs.close();}catch(Exception e) {e.printStackTrace();} 
			}
			return club;
		}
		
		//clubNum을 불러오는 메서드 . 이 메서드를 실행하기 전에 insert 하면서 clubnum이 시퀀스로 생겼기 때문에 
		//clubnum 중에 가장 큰 값을 가져오면 방금 만든 클럽임 ! 
		public int getClubNum(Club_CreateDTO d) {
			int clubNum = 0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select max(clubnum) from club_create";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					clubNum = rs.getInt(1);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				 if(pstmt != null)try{pstmt.close();}catch(Exception e) {e.printStackTrace();} 
				 if(conn != null)try{conn.close();}catch(Exception e) {e.printStackTrace();} 
				 if(rs != null)try{rs.close();}catch(Exception e) {e.printStackTrace();} 
			}
			
			return clubNum;
		}
		
		//introClub을 수정하는 메서드 
		public void updateIntroClub(Club_CreateDTO d) {
			Connection conn= null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql = "update club_create set emblem=?, tLocal=?, ground=?, avrAge=?, skill=?, tNum=?, bio=? where clubNum =? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, d.getEmblem());
				pstmt.setString(2, d.gettLocal());
				pstmt.setString(3, d.getGround());
				pstmt.setString(4, d.getAvrAge());
				pstmt.setString(5, d.getSkill());
				pstmt.setInt(6, d.gettNum());
				pstmt.setString(7, d.getBio());
				pstmt.setInt(8, d.getClubNum());
				pstmt.executeUpdate();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				 if(pstmt != null)try{pstmt.close();}catch(Exception e) {e.printStackTrace();} 
				 if(conn != null)try{conn.close();}catch(Exception e) {e.printStackTrace();} 
			}
		}
		
		//동호회명 중복확인 메서드 
		public boolean confirmtName(String tName) {
			boolean result = false;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select tName from club_create where tName=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, tName);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					result = true;
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs != null)try{rs.close();}catch(Exception e) {e.printStackTrace();} 
				if(pstmt != null)try{pstmt.close();}catch(Exception e) {e.printStackTrace();} 
				if(conn != null)try{conn.close();}catch(Exception e) {e.printStackTrace();} 
			}
			return result;
		}
		
		
		
		
		
		
		
}
