package woodley.football.comboard;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Free_BoardDAO {
	   
	   //싱글톤
	   private static Free_BoardDAO instance = new Free_BoardDAO();
	   private Free_BoardDAO() {}
	   public static Free_BoardDAO getInstance() { return instance; }
	   
	   
	   //db연결
	   private Connection getConnection() throws Exception{
	      Context ctx = new InitialContext();
	      Context env = (Context)ctx.lookup("java:comp/env");
	      DataSource ds = (DataSource)env.lookup("jdbc/orcl");
	      return ds.getConnection();
	   }
	   
	   
	   //게시글 저장
	   public void insertArticle(Free_BoardDTO article) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	   
	      try {
	         conn = getConnection();
	         String sql = "insert into FREE_BOARD values(free_board_num_seq.nextVal,?,?,?,sysdate,?,?)";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, article.getTitle());
	         pstmt.setString(2, article.getWriter());
	         pstmt.setString(3, article.getContent());
	         pstmt.setInt(4, 0);
	         pstmt.setString(5, article.getImg());
	         pstmt.executeUpdate();
	         
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	         if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	      }
	   }
	   
	  
	 //범위 주고 범위 내의 게시글들 가져오는 메서드
	   public List getArticles(int start,int end){
	      List articleList = null;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = getConnection();
	         String sql = "SELECT b.*, r FROM (SELECT a.*, rownum r FROM (SELECT * FROM free_board ORDER BY free_board_num desc) a ORDER BY r asc) b WHERE r>= ? AND r<=?";
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, start);
	         pstmt.setInt(2, end);
	         rs = pstmt.executeQuery();
	         if(rs.next()) {
	            articleList = new ArrayList();
	            do {
	            	Free_BoardDTO article = new Free_BoardDTO();
	            	article.setFree_board_num(rs.getInt("free_board_num"));
	            	article.setTitle(rs.getString("title"));
	            	article.setWriter(rs.getString("writer"));
	            	article.setReg(rs.getTimestamp("reg"));
	            	article.setReadcount(rs.getInt("readcount"));
	            	articleList.add(article);
	            }while(rs.next());
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	         if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	         if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	      }
	      return articleList;
	      
	   }
	   
	   
	//전체 글 개수 리턴 메서드
	public int getArticleCount() {
		int x = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
	   
		try {
		 conn = getConnection();
		 String sql = "select count(*) from free_board";
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
	
	//글 고유번호로 해당 글 내용 가져오는 메서드
	public Free_BoardDTO getArticle(int num) {
		Free_BoardDTO article = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
	         
	         //이 메서드가 호출된다는 건 글을 클릭했다는 거니까 조회수 우선 한 번 올리고 글 가져와야.
			String sql = "update free_board set readcount=readcount+1 where free_board_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
	        //글 가져오기
			sql = "select * from free_board where free_board_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new Free_BoardDTO();
	            article.setFree_board_num(num);    //( 또는 setNum(rs.getInt("num")) )
	            article.setTitle(rs.getString("title"));
	            article.setWriter(rs.getString("writer"));
	            article.setContent(rs.getString("content"));
	            article.setReg(rs.getTimestamp("reg"));
	            article.setReadcount(rs.getInt("readcount"));
	            article.setImg(rs.getString("img"));
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	         if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	         if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	      }
	      return article;
	   }
	
	
	//글 수정 메서드
	public boolean updateArticle(Free_BoardDTO article, int num) {
		boolean res = true;
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "update free_board set title=?, writer=?, content=?, reg=sysdate where free_board_num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getTitle());
			pstmt.setString(2, article.getWriter());
			pstmt.setString(3, article.getContent());
			pstmt.setInt(4, num);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
			return res;
		}
	
	   
	   // 글삭제 메서드
	   public boolean deleteArticle(int num) {
		   boolean result = false;
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      try {
		         conn = getConnection();
		         String sql = "delete from free_board where free_board_num=?";
		         pstmt = conn.prepareStatement(sql);
		         pstmt.setInt(1, num);
		         pstmt.executeUpdate();
		         result = true;
		      }catch(Exception e) {
		         e.printStackTrace();
		      }finally {
		         if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
		         if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		      }
		      System.out.println("삭제완료");
		      return result;
		  }
	   
	   
	   
	   //검색된 글의 개수 리턴하는 메서드
	   public int getSearchArticleCount(String sel, String search) {
	      int count = 0;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = getConnection();
	         String sql = "select count(*) from free_board where "+sel+" like '%"+search+"%'";
	         pstmt = conn.prepareStatement(sql);
	         rs = pstmt.executeQuery();
	         if(rs.next()) {
	            count = rs.getInt(1);
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	         if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	         if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	      }
	      return count;
	   }
	   
	   
	   
	 //검색 결과에 부합하는 글 목록 가져오는 메서드
	   public List getSearchArticles(int start, int end, String sel, String search) {
	      List articleList = null;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = getConnection();
	         if(sel.equals("content||title")) { //내용+제목 검색일경우 쿼리
	        	 String sql="select * from free_board where "+sel+" like '%"+search+"+'";
	         }
	         String sql = "SELECT free_board_num,title,writer,content,reg,readcount,img,r "
                     + "FROM (SELECT free_board_num,title,writer,content,reg,readcount,img,rownum r " 
                     + "FROM (SELECT free_board_num,title,writer,content,reg,readcount,img " 
                     + "FROM free_board where "+sel+" like '%"+search+"%' ORDER BY free_board_num desc) "
                     + "ORDER BY r asc) WHERE r >= ? AND r <= ?";

	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, start);
	         pstmt.setInt(2, end);
	         rs = pstmt.executeQuery();
	         if(rs.next()) {
	            articleList = new ArrayList();
	            do {
	               Free_BoardDTO article = new Free_BoardDTO();
	               article.setFree_board_num(rs.getInt("free_board_num"));
	               article.setTitle(rs.getString("title"));
	               article.setWriter(rs.getString("writer"));
	               article.setContent(rs.getString("content"));
	               article.setReg(rs.getTimestamp("reg"));
	               article.setReadcount(rs.getInt("readcount"));
	               article.setImg(rs.getString("img"));
	               article.setReadcount(rs.getInt("readcount"));
	               articleList.add(article);
	            }while(rs.next());
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         if(rs!=null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
	         if(pstmt!=null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
	         if(conn!=null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
	      }
	      return articleList;
	   }
		   
	   
	   
	
	
}
