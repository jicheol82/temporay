<%@page import="woodley.football.comboard.Free_BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.comboard.Free_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<link rel="stylesheet" href="../css/bootstrap.css">
<title>자유게시판</title>
<%
	String event = request.getParameter("event");
	if(event == null) {
		event = "football";
	}
	String category = request.getParameter("category");
%>
</head>
<% 
	String id = (String)session.getAttribute("memId");
 	session.setAttribute("memId", id);

	int pageSize = 5;//글 5개씩 나열 

	//페이지 정보
	String pageNum = request.getParameter("pageNum");
	if(pageNum==null){   //자유게시판 들어왔을때
	pageNum = "1";   // 1페이지 보여주기
	}
	
	
	int currPage = Integer.parseInt(pageNum);   //연산을 해야 하므로 현재 게시판 페이지를 정수형으로 형변환해놓기
	int startRow = (currPage-1)*pageSize+1;      //현재페이지가 1페이지라면 1, 2페이지라면 11
	int endRow = currPage*pageSize; 
	int count = 0;

	Free_BoardDAO dao = Free_BoardDAO.getInstance();
	List articleList = null;
	
	//검색 관련
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");

	//검색으로 들어온건지 구분
	if(sel!=null && search!=null){ 
	      count = dao.getSearchArticleCount(sel,search);
	      if(count>0){
	         articleList = dao.getSearchArticles(startRow,endRow,sel,search);
	      }
	}else{
	count = dao.getArticleCount();   //db에 저장된 전체 글의 개수 가져오는 메서드 
		if(count>0){   //db에 글이 있으면 가져온다
			articleList = dao.getArticles(startRow, endRow);
		}
	}
	
	int number = count - (currPage-1)*pageSize;  //게시판에 뿌려줄 번호
%>

<body>
	<jsp:include page ="/main/main.jsp" flush="false"></jsp:include>
	<br />
	<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<tr>
			<td>
				<a href="../board/noticeBoard.jsp?category=board">공지사항	|</a>
				<a href="../board/freeBoard.jsp?category=board">자유게시판	|</a>
				<a href="../board/recruitBoard.jsp?category=board">모집게시판</a>
			</td>
		</tr>
	</table>
	
	
<%	if(count==0){ // 게시글이 하나도 없을ㅐ
		if(id != null){ //로그인 했을때 %> 
			<button class="btn btn-primary" onclick="window.location='freeWriteForm.jsp?category=comboard'">글쓰기</button>
	<% 			
		}		
	%>
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<tr>
				<td>번호</td>
				<td>제목</td>
				<td>글쓴이</td>
				<td>작성일</td>
				<td>조회수</td>
			</tr>
			<tr>
				<td colspan="5" align="center">게시글이 없습니다</td>
			</tr>
		</table>
	   <%}else{ //글이 1개이상 있고 로그인으로 
	   		if(id != null){ //로그인 했을때 %> 
			<button class="btn btn-primary" onclick="window.location='freeWriteForm.jsp?category=comboard'">글쓰기</button>
	<% 			
		}		
	%>
	   
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
			<tr>
				<td><b>번호</b></td>
				<td><b>제목</b></td>
				<td><b>글쓴이</b></td>
				<td><b>작성일</b></td>
				<td><b>조회수</b></td>
			</tr>
<%
			//게시글 가져와서 뿌리기
			for(int i = 0; i < articleList.size(); i++){  
				Free_BoardDTO article = (Free_BoardDTO)articleList.get(i);
%>
			<tr>
				<td><%= number-- %></td>
				<td>
<%				if(id == null){ %>
					<%= article.getTitle() %>			
<%				}else{ 	%>
				<a href="freeBoardCon.jsp?category=comboard&num=<%=article.getFree_board_num()%>&pageNum=<%=pageNum%>"><%= article.getTitle() %></a></td>
<%				} %>
				<td><%= article.getWriter() %></td>
				<td><%= article.getReg() %></td>
				<td><%= article.getReadcount() %></td>
			</tr>
<%			}
%>
		</table>
		<div align="center">
		<h4>현재 페이지: <%=pageNum%></h4>
<% 
		int pageCount = (count/pageSize)+(count%pageSize==0 ? 0 : 1); // 카운트가 총 글의갯수 // 8/2      총 4페이지
		int pageBlock = 5;   //밑에 페이지뷰 5개씩 
		int startPage = (int)(((currPage-1)/pageBlock)*pageBlock+1); 
		int endPage = startPage+pageBlock-1;   
		if(endPage>pageCount){  
	        endPage = pageCount;
	     }
	
		if(startPage>pageBlock){  // < 기호%> 
	    <a href="freeBoard.jsp?pageNum=<%=startPage-pageBlock%>&category=comboard" class="pageNums"> &lt; </a>      <%-- &lt; → "<" 기호를 화면에 출력하고 싶을 때 --%>
<%	 	}
		
		if(sel!=null && search!=null){ 
		      //  화면에 숫자 뿌려주자
			for(int i = startPage ; i<=endPage ; i++){   %>
				<a href="freeBoard.jsp?pageNum=<%=i%>&category=comboard&sel=<%=sel%>&search=<%=search%>" class="pageNums"> &nbsp; <%=i%> &nbsp; </a>      <%-- &nbsp; → 한 칸 띄어쓰기 --%>
		               <%-- pageNum을 파라미터로 넘겨주면서 클릭할 수 있게  --%>
<%			}
		 }else{
			for(int i = startPage ; i<=endPage ; i++){   //페이지 번호 뿌려줌  %>
				<a href="freeBoard.jsp?pageNum=<%=i%>&category=comboard" class="pageNums"> &nbsp; <%=i%> &nbsp; </a>      <%-- &nbsp; → 한 칸 띄어쓰기 --%>
<%			}
		 }
		
		if(endPage<pageCount){   // > 기호%>  
			<a href="freeBoard.jsp?pageNum=<%=startPage+pageBlock%>&category=comboard" class="pageNums"> &gt; </a>      <%-- &gt; → ">" 기호를 화면에 출력하고 싶을 때 --%>
<%		} %>
		</div>
<% 	} //if(count==0) 닫음
%>

	<!-- 검색창 -->
	<div align="center">
	<form action="freeBoard.jsp?category=comboard">
 		<select name="sel">
			<option value="writer" selected>작성자</option>
			<option value="content" >내용</option>
			<option value="title" >제목</option>
			<option value="content||title">내용+제목</option>
        </select>
        <input type="text" name="search" value="${param.search}"/>  <!-- value="${param.search}" 검색창에 검색어를 보여줌  -->
        <input type="submit" value="검색" class="btn btn-primary"/>
	</form>
</body>
</html>