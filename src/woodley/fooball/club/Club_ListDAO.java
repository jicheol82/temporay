package woodley.fooball.club;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import woodley.football.league.F_League_CreateDTO;
import woodley.main.member.MemberDTO;

public class Club_ListDAO {
		
		private static Club_ListDAO instance = new Club_ListDAO();
		private Club_ListDAO() {}
		public static Club_ListDAO getInstance() {return instance;}
		
		private Connection getConnection() throws Exception{
			Context ctx = new InitialContext();
			Context env = (Context)ctx.lookup("java:comp/env");
			DataSource ds = (DataSource)env.lookup("jdbc/orcl");
			return ds.getConnection(); 
		}
		
		//동호회 생성 되었을 때 동호회장 db에 넣는메서드 
		public void insertClubList(Club_ListDTO d, int auth) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql="insert into club_mem_list (clubnum, memid, authority)"
						+ "values (?,?,?)";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, d.getClubNum());
				pstmt.setString(2, d.getMemid());
				pstmt.setInt(3, auth);
				pstmt.executeUpdate();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
		}
		
		//동호회원의 권한을 올려주는 메서드 
		public void upgradeAuth(String memid, int auth) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql="update club_mem_list set authority=? where memid=?";
				pstmt= conn.prepareStatement(sql);
				pstmt.setInt(1, auth);
				pstmt.setString(2, memid);
			
				pstmt.executeUpdate();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
		}
		
		/*
		//일반회원이 동호회 신청 했을 때 준회원으로 db에  넣어주는 메서드 
				public void insertClubList0(Club_ListDTO d) {
					Connection conn = null;
					PreparedStatement pstmt = null;
					try {
						conn = getConnection();
						String sql="insert into club_mem_list (clubnum, memid, authority)"
								+ "values (?,?,?)";
						pstmt= conn.prepareStatement(sql);
						pstmt.setInt(1, d.getClubNum());
						pstmt.setString(2, d.getMemId());
						pstmt.setInt(3, 0);
						pstmt.executeUpdate();
						
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
				}
		*/
		
		//위에 두개 메서드 합칠까? 
		//동호회 생성 클릭 했을 때 clubnum 넣어주는 메서드 
		//clubNum을 가지고 생성 했을 때 members 에 clubnum 에  clubNum 넣어주기 
				public void insertMemclubnum(int clubnum, String id) {
					Connection conn = null;
					PreparedStatement pstmt = null;
					try {
						conn = getConnection();
						String sql = "update members set clubnum=? where id=?";
						pstmt= conn.prepareStatement(sql);
						pstmt.setInt(1, clubnum);
						pstmt.setString(2, id);
						pstmt.executeUpdate();
						
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
				}
				
				
		
		//동호회 정회원 auth 정보 뿌려주는 메서드 , 
		public List getClubMemAuth(int clubNum) {
			List authList = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				//club_mem_list 와 members 테이블 조인 후 clubnum 으로 해당 내용 가져온다. 
				String sql ="select cml.authority, m.id, m.reg from club_mem_list cml inner join members m"
						+ " on cml.memid = m.id where cml.clubnum=? and cml.authority > 0 "
						+ " order by m.reg desc";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, clubNum);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					//해당 테이블 이 있으면 list 객체 생성
					//auth 쪽 List
					authList = new ArrayList();
					do {
						Club_ListDTO auth = new Club_ListDTO();
						auth.setAuthority(rs.getInt("authority"));
						auth.setMemid(rs.getString(2));
						authList.add(auth);
					}while(rs.next());
					
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			return authList;
		}
		
		//동호회 예비회원 auth 정보 뿌려주는 메서드 , 
				public List getClubNMemAuth(int clubNum) {
					List authList = null;
					Connection conn = null;
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					try {
						conn = getConnection();
						//club_mem_list 와 members 테이블 조인 후 clubnum 으로 해당 내용 가져온다. 
						String sql ="select cml.authority, m.id, m.reg from club_mem_list cml inner join members m"
								+ " on cml.memid = m.id where cml.clubnum=? and cml.authority = 0 "
								+ " order by m.reg desc";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, clubNum);
						rs = pstmt.executeQuery();
						if(rs.next()) {
							//해당 테이블 이 있으면 list 객체 생성
							//auth 쪽 List
							authList = new ArrayList();
							do {
								Club_ListDTO auth = new Club_ListDTO();
								auth.setAuthority(rs.getInt("authority"));
								auth.setMemid(rs.getString(2));
								authList.add(auth);
							}while(rs.next());
							
						}
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
						if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
					return authList;
				}
		
		//동호회 정회원 mem 정보 뿌려주는 메서드 , 
				public List getClubMemIdReg(int clubNum) {
					List memList = null;
					Connection conn = null;
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					try {
						conn = getConnection();
						//club_mem_list 와 members 테이블 조인 후 clubnum 으로 해당 내용 가져온다. 
						String sql ="select cml.authority, m.id, m.reg from club_mem_list cml inner join members m"
								+ " on cml.memid = m.id where cml.clubnum=? and cml.authority > 0 "
								+ " order by m.reg desc";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, clubNum);
						rs = pstmt.executeQuery();
						if(rs.next()) {
							//해당 테이블 이 있으면 list 객체 생성
							//auth 쪽 List
							memList = new ArrayList();
							do {
								MemberDTO mem = new MemberDTO();
								mem.setId(rs.getString("id"));
								mem.setReg(rs.getTimestamp("reg"));
								memList.add(mem);
							}while(rs.next());
						}
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
						if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
					return memList;
				}
				
				//동호회 정회원 mem 정보 뿌려주는 메서드 , 
				public List getClubNMemIdReg(int clubNum) {
					List memList = null;
					Connection conn = null;
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					try {
						conn = getConnection();
						//club_mem_list 와 members 테이블 조인 후 clubnum 으로 해당 내용 가져온다. 
						String sql ="select cml.authority, m.id, m.reg from club_mem_list cml inner join members m"
								+ " on cml.memid = m.id where cml.clubnum=? and cml.authority = 0 "
								+ " order by m.reg desc";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, clubNum);
						rs = pstmt.executeQuery();
						if(rs.next()) {
							//해당 테이블 이 있으면 list 객체 생성
							//auth 쪽 List
							memList = new ArrayList();
							do {
								MemberDTO mem = new MemberDTO();
								mem.setId(rs.getString("id"));
								mem.setReg(rs.getTimestamp("reg"));
								memList.add(mem);
							}while(rs.next());
						}
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
						if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
					return memList;
				}
				
		//클럽 memlist에서 사람 지우기  memid 받아서 해당 열 삭제
		//memid 랑id 부분 정확히 확인 해야함 지금 중구 난방으로 되있어서 
		public void deleteClubMem(String memid) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				String sql = "delete from club_mem_list where memid=? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, memid);
				pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
		}
		
		//members에서 가입된 클럽 지우기 
		public void deleteAuthMem(String memid) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			try {
				conn=getConnection();
				String sql = "update members set clubnum=0 where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, memid);
				pstmt.executeUpdate();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
				if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
		}
		
		public Club_ListDTO checkMaster(String id) { // 동호회장인지 확인하는 메서드
	         Connection conn = null;
	         PreparedStatement pstmt = null;
	         ResultSet rs = null;
	         Club_ListDTO dto = null;
	         
	         try {
	            conn = getConnection();
	            String sql = "select * from club_mem_list where memid=?";
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, id);
	            rs = pstmt.executeQuery();
	            
	            if(rs.next()) {
	               dto = new Club_ListDTO();
	               dto.setClubNum(rs.getInt("clubnum"));
	               dto.setMemid(rs.getString("memid"));
	               dto.setAuthority(rs.getInt("authority"));
	               dto.setReg(rs.getTimestamp("reg"));
	            }
	            
	         }catch (Exception e) {
	            e.printStackTrace();
	         }finally {
	            if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	            if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	            if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	         }
	         return dto;
	      }
		
		public MemberDTO checkMember(String id) { // id로 멤버쪽 정보 가져오는 메서드 
	         Connection conn = null;
	         PreparedStatement pstmt = null;
	         ResultSet rs = null;
	         MemberDTO dto = null;
	         
	         try {
	            conn = getConnection();
	            String sql = "select * from members where id=?";
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, id);
	            rs = pstmt.executeQuery();
	            
	            if(rs.next()) {
	               dto = new MemberDTO();
	               dto.setId(rs.getString("id"));
	               dto.setPw(rs.getString("pw"));
	               dto.setName(rs.getString("name"));
	               dto.setPhone(rs.getString("phone"));
	               dto.setBirth(rs.getString("birth"));
	               dto.setEmail(rs.getString("email"));
	               dto.setLocation(rs.getString("location"));
	               dto.setPrefer(rs.getString("prefer"));
	               dto.setProfile(rs.getString("profile"));
	               dto.setReg(rs.getTimestamp("reg"));
	               dto.setClubnum(rs.getInt("clubnum"));
	            }
	            
	         }catch (Exception e) {
	            e.printStackTrace();
	         }finally {
	            if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	            if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	            if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	         }
	         return dto;
	      }
		
		//clubNum 받아서 members에 clubnum 채워주는 메서드 
				public void insertMemClub(int clubNum, String id) {
					Connection conn = null;
					PreparedStatement pstmt = null;
					try {
						conn=getConnection();
						String sql = "update members set clubnum=? where id=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, clubNum);
						pstmt.setString(2, id);
						pstmt.executeUpdate();
						
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
						if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
					}
				}
				
		// club_num 받아서 해당동호회 회원 동호회 팀이름 가져오기
		public String getTeamInfo(int club_num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Club_CreateDTO clubDTO = null;
			String tname = "";
			
			try {
				conn = getConnection();
				String sql = "select tname from club_create where clubnum=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, club_num);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					tname = rs.getString("tname");
				}
					
					
			}catch (Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	            if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	            if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
			}
			
			
			
			
			return tname;
			
		}
		
		
		
		
		
		
		
		
		
		
		
}
