package woodley.fooball.club;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class Club_BoardDAO {
	
	private static Club_BoardDAO instance = new Club_BoardDAO();
	private Club_BoardDAO() {}
	public static Club_BoardDAO getInstance() {return instance;}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		return ds.getConnection();
	}
	
	//글 db저장
	public void insertArticle(Club_BoardDTO d) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql ="insert into club_board(boardnum,title,writer,content,photo,clubnum)"
					+ "values(club_board_seq.nextVal,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, d.getTitle());
			pstmt.setString(2, d.getWriter());
			pstmt.setString(3, d.getContent());
			pstmt.setString(4, d.getPhoto());
			pstmt.setInt(5, d.getClubnum());
			
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	// 게시판에 글 뿌려주는 메서드
	public List getArticles(int clubNum, int start, int end) {
		List articleList = null; 
		Connection conn = null; 
		PreparedStatement pstmt =null; 
		ResultSet rs = null; 
		try { 
			conn = getConnection(); 
			String sql ="select boardnum,title,writer,content,photo,readcount,reg,clubnum, r from"
					+ " (select boardnum,title,writer,content,photo,readcount,reg,clubnum, rownum r from"
					+ " (select boardnum,title,writer,content,photo,readcount,reg,clubnum from club_board where clubnum=?"
					+ " order by reg desc)"
					+ " order by reg desc) where r>=? and r<=? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, clubNum); 
			pstmt.setInt(2, start); 
			pstmt.setInt(3, end); 
			rs = pstmt.executeQuery();
			//리스트에 글 한줄 담기
			if(rs.next()) { //rs 가 존재한다면 list 객체 생성해라
				articleList = new ArrayList(); //dto 객체 생성해서 값들을 세팅 해서 articleList에 add 해라 
				do { 
					 Club_BoardDTO club = new Club_BoardDTO(); 
				     club.setBoardnum(rs.getInt("boardnum"));
				     club.setTitle(rs.getString("title")); 
				     club.setWriter(rs.getString("writer"));
				     club.setContent(rs.getString("content"));
				     club.setPhoto(rs.getString("photo"));
				     club.setReadcount(rs.getInt("readcount"));
				     club.setReg(rs.getTimestamp("reg"));
				     club.setClubnum(rs.getInt("clubnum"));
				     articleList.add(club);
				 }while(rs.next()); 
			}
		 }catch(Exception e){ 
			 e.printStackTrace(); 
		 }finally { 
			 if(pstmt != null)try{pstmt.close();}catch(Exception e) {e.printStackTrace();} 
			 if(conn != null)try{conn.close();}catch(Exception e) {e.printStackTrace();} 
			 if(rs != null)try{rs.close();}catch(Exception e) {e.printStackTrace();} 
		} 
		return articleList;
		}
	
	//조건으로 게시판에 글 뿌려주기 
	public List getSearchArticles(int start, int end, String sel, String search) {
		List articleList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			String sql = "select boardnum,title,writer,content,photo,readcount,reg,r from"
					+ " (select boardnum,title,writer,content,photo,readcount,reg,rownum r from"
					+ " (select boardnum,title,writer,content,photo,readcount,reg from club_board where "+sel+" like '%" +search+ "%'"
					+ " order by reg desc)"
					+ " order by reg desc) where r>=? and r<=? ";
					
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				articleList = new ArrayList();
				do {
					Club_BoardDTO article = new Club_BoardDTO();
					article.setBoardnum(rs.getInt("boardnum"));
					article.setTitle(rs.getString("title")); 
					article.setWriter(rs.getString("writer"));
					article.setContent(rs.getString("content"));
					article.setPhoto(rs.getString("photo"));
					article.setReadcount(rs.getInt("readcount"));
					article.setReg(rs.getTimestamp("reg"));
					articleList.add(article);
				}while(rs.next());
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return articleList;
	}
	
	//동호회 게시판 글 수 세기 
	public int getArticleCount(int clubNum) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			//club_board에 몇개의 행이 있는지 구한다
			String sql = "select count(*) from club_board where clubNum = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, clubNum);
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
	
	//검색 조건으로 동호회 게시판 글 수 세기 
	public int getSearchArticleCount(int clubNum, String sel, String search) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn =  getConnection();
			String sql = "select count(*) from club_board where clubNum =? and " +sel+ " like '%" +search+ "%'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, clubNum);
			rs= pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return count;
	}
	
	// 글 고유 번호로 해당 글 1개 가져오는 메서드 
	public Club_BoardDTO getArticle(int boardnum) {
		Club_BoardDTO article = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = getConnection();
			//조회수 먼저 올림 
			String sql = "update club_board set readcount=readcount+1 where boardnum=?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			pstmt.executeQuery();
			
			//글 가져오기 
			sql = "select * from club_board where boardnum=? ";
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			rs= pstmt.executeQuery();
			if(rs.next()) {
				article = new Club_BoardDTO();
				article.setBoardnum(rs.getInt("boardnum"));
				article.setTitle(rs.getString("title"));
				article.setWriter(rs.getString("writer"));
				article.setContent(rs.getString("content"));
				article.setPhoto(rs.getString("photo"));
				article.setReadcount(rs.getInt("readcount"));
				article.setReg(rs.getTimestamp("reg"));
				article.setClubnum(rs.getInt("clubnum"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs != null)try {rs.close();}catch(Exception e) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return article;
	}
	
	// 게시판 글 수정 하는 메서드 
	public void updateArticle(Club_BoardDTO d) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql = "update club_board set title=?, content=?, photo=?  where boardnum =? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, d.getTitle());
			pstmt.setString(2, d.getContent());
			pstmt.setString(3, d.getPhoto());
			pstmt.setInt(4, d.getBoardnum());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	//게시판 글 삭제 메서드 
	public void deleteArticle(int boardnum) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = getConnection();
			String sql="delete from club_board where boardnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, boardnum);
			pstmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt != null)try {pstmt.close();}catch(Exception e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(Exception e) {e.printStackTrace();}
		}
	}
	
	
	
	
	
	
	
	
	
}
