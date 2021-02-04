package woodley.main.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class MemberDAO {
	
	
	private static MemberDAO instance = new MemberDAO();
	private MemberDAO() {}
	public static MemberDAO getInstance() {return instance;}
	
	// 커넥션 메서드
		private Connection getConnection() throws Exception{
			Context ctx = new InitialContext();
			Context env = (Context)ctx.lookup("java:comp/env");
			DataSource ds = (DataSource)env.lookup("jdbc/orcl");
			return ds.getConnection();
		}
		
		
		public int idCheck(String id) {
			PreparedStatement pstmt = null;
			Connection conn = null;
			ResultSet rs = null;
			String sql = "select * from members where id =?";
			try {
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					return 0;	// 이미 존재하는 회원
				}else {
					return 1;	// 가입 가능한 회원 아이디
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return -1; // 데이터베이스 오류
		}	// 회원중복 체크 class
		
		// 회원가입 메서드 signup method
		public void insertMember(MemberDTO dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql = "insert into members values(?,?,?,?,?,?,?,?,?,sysdate,?)";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, dto.getId());
				pstmt.setString(2, dto.getPw());
				pstmt.setString(3, dto.getName());
				pstmt.setString(4, dto.getPhone());
				pstmt.setString(5, dto.getBirth());
				pstmt.setString(6, dto.getEmail());
				pstmt.setString(7, dto.getLocation());
				pstmt.setString(8, dto.getPrefer());
				pstmt.setString(9, dto.getProfile());
				pstmt.setInt(10, dto.getClubnum());
				
				pstmt.executeUpdate();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
				
			}
		} //insertMember
		
		
		// 아이디 패스워드 확인	// idCh pwCh
		public boolean idPwCheck(String id, String pw) {
			boolean res = false;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "select * from members where id=? and pw=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, pw);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					res = true;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			
			return res;
		}	//idpwcheck class
		
		//아이디 찾기 findId : name, email
		public String findId(String name, String email) {
			String id = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql="select id from members where name=? and email=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,name);
				pstmt.setString(2,email);
				
				rs = pstmt.executeQuery();
				
				if(rs.next())
					id = rs.getString("memId");
				else {
					return null;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally{
				if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return id;
			
		}	// 아이디 찾기 class
		
		// 비밀번호 찾기 findPw
		public String findPw(String memId, String name, String email) {
			String pw = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql="select pw from members where memId=? and name=? and email=?";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, memId);
				pstmt.setString(2, name);
				pstmt.setString(2, email);
				
				rs = pstmt.executeQuery();
				
				if(rs.next())
					pw = rs.getString("memPw");
				else {
					return null;
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return pw;
		
		}	// findPw class
		
		// 내정보 보여주기 
		public MemberDTO getMember(String id)  {
			MemberDTO dto = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = getConnection();
				String sql = "select * from members where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					dto = new MemberDTO();
					dto.setId(rs.getString("id"));
					dto.setName(rs.getString("name"));
					dto.setBirth(rs.getString("birth"));
					dto.setEmail(rs.getString("email"));
					dto.setLocation(rs.getString("location"));
					dto.setPrefer(rs.getString("prefer"));
					dto.setProfile(rs.getString("profile"));
					dto.setReg(rs.getTimestamp("reg"));
					dto.setClubnum(rs.getInt("clubnum"));
				}
				
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return dto;
		}	// myinfo class
		
		// 회원정보 수정 modifyMember
		public void updateMember(MemberDTO member){
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = getConnection();
				String sql = "update members set pw=?, phone=?, birth=?, email=?, location=?, prefer=?, profile=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, member.getPw());
				pstmt.setString(2, member.getPhone());
				pstmt.setString(3, member.getBirth());
				pstmt.setString(4, member.getEmail());
				pstmt.setString(5, member.getLocation());
				pstmt.setString(6, member.getPrefer());
				pstmt.setString(7, member.getProfile());
				
				pstmt.executeUpdate();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			
		}	// updateMember class
	
		public void deleteMember(String pw) {
			Connection conn= null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				String sql = "delete from members where pw=?";
				pstmt.setString(1, pw);
				pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
		}	// resign class
	
		
	
	//회원 id로 소속 동호회명(tname)가져오기
		//recruitBoardWritePro에서 사용하기 위해 작성 by cjc
		public String findTname(String id) {
			Connection conn= null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String tname="";
			try {
				conn = getConnection();
				String sql = "SELECT tname FROM (SELECT m.id, c.tname FROM MEMBERS m, CLUB_CREATE c WHERE c.CLUBNUM = m.CLUBNUM) WHERE id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					tname = rs.getString(1);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null) try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null) try {conn.close();}catch(Exception e) {e.printStackTrace();}
				if(rs != null) try {rs.close();}catch(Exception e) {e.printStackTrace();}
			}
			return tname;
		}
		
		
		
	
		
	}


	

