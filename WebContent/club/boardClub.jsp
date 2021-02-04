<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.fooball.club.Club_ListDTO"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.fooball.club.Club_BoardDTO"%>
<%@page import="woodley.fooball.club.Club_BoardDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>동호회 게시판</title>
</head>
<%	
	//세션으로 아이디 값 받음 
	String id = (String)session.getAttribute("memId");
	//System.out.println("boardclub page id =" + id);
	//회원 아이디로 동호회 권한 확인 하는 메서드 
	Club_ListDAO ldao = Club_ListDAO.getInstance();
	Club_ListDTO ldto = ldao.checkMaster(id);

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");


	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	//System.out.println("board clubNum =" + clubNum);
	// 한 페이지에 보여줄 게시글의 수 
	int pageSize = 3;

	// 게시글 정보 담기, findClub pageNum
	//findClub page 번호 
	String pageNum = request.getParameter("pageNum");
	
	//동호회 클릭 해서 바로 들어왔을 때는 1page 로 설정 해줌
	//pageNum 두개 만들어야 함 게시판용 pageNum
	String bpageNum = request.getParameter("bpageNum");
	if(bpageNum == null){
		bpageNum = "1";
	}
	// 현재 페이지에 보여줄 게시글의 첫 글과 마지막글 정보 세팅 
	// 현재 페이지를 int 로 형변환
	int currPage = Integer.parseInt(bpageNum);
	//해당 페이지의 첫 번째 글 구하기 
	int startRow = (currPage-1)*pageSize+1;
	//해당 페이지의 마지막 글 구하기 
	int endRow = currPage*pageSize;
	//화면에 뿌려줄 번호 첫 번째 번호만 구하고 나머지는 1씩 감소하면서 출력 해줌
	int number =0;
	//전체 글의 수 count 변수 미리 선언, 분기 처리 해주기 위해서 
	int count=0;
	//글을 반복해서 뿌려줄 수 있도록 list 미리 생성
	List articleList = null;
	
	Club_BoardDAO dao  = Club_BoardDAO.getInstance();
	//sel=어떤 종류 검색 할 것인지(제목, 작성자, 내용) search=검색한 내용
	 	String sel = request.getParameter("sel");
	 	String search = request.getParameter("search");
	 	//System.out.println("boardClub sel= " +sel);
	 	//System.out.println("boardClub search= " +search);
	 	
	 if(sel != null && search !=null){
		count = dao.getSearchArticleCount(clubNum, sel, search);  //검색된 글 전체 개수
		if(count>0){
			articleList = dao.getSearchArticles(startRow,endRow,sel,search); 
			}
		}else {//sel, search 가 null일때 검색 안했을 때는 일반 동호회 게시판
			// 전체 동호회 게시판 페이지 요청
			//DB에 저장된 게시글의 전체 개수를 먼저 가져오기
			count = dao.getArticleCount(clubNum);  //DB에 저장된 전체 글의 개수를 저장할 변수 
			//System.out.println("boardClub no sel count = " + count);
			if(count > 0){//db에 글이 하나라도 있으면
				//글 가져오기, 글이 없는데 굳이 db한테 일을 시킬 이유가 없다. 
			//System.out.println("start = " + startRow);
			//System.out.println("end = " + endRow);
			//System.out.println("clubNum = " + clubNum);
			articleList = dao.getArticles(clubNum, startRow, endRow);
			//System.out.println("boardClub articlelistsize = " + articleList.size());
			}
	}
		
	number = count - (currPage-1)*pageSize;
%>
<body>
<jsp:include page="../main/main.jsp"></jsp:include>
<h3 align="center"><a href="introClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 소개</a> | <a href="boardClub.jsp?category=club&bpageNum=<%=bpageNum%>&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 게시판</a></h3>
	<%if(count ==0 ){ %>
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
				<%if (ldto == null){%>
			
				<%}else if(session.getAttribute("memId") != null && ldto.getAuthority() > 0 && ldto.getClubNum()==clubNum ){ //권한이 1부터, 동호회 회원 부터 글쓰기 가능%>
			<tr>
				<td colspan="5" align = "center"><button onclick ="window.location='writeFormClub.jsp?category=club&clubNum=<%=clubNum%>&pageNum=<%=pageNum%>'">글쓰기</button></td>
			</tr>
				<%} %>
			<tr>
				<td align="center">게시글이 없습니다. </td>
			</tr>
			<tr>
				<td><button onclick="window.location='findClub.jsp?category=club&pageNum=<%=pageNum%>'">동호회 목록</button></td>
			</tr>
			
		</table>
	<% }else{ //게시글이 하나라도 있을 경우%>
	<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<tr>
			<th style="background-color: #fafafa; text-align: center;">No.</th>
			<th style="background-color: #fafafa; text-align: center;">제목</th>
			<th style="background-color: #fafafa; text-align: center;">작성자</th>
			<th style="background-color: #fafafa; text-align: center;">작성일</th>
			<th style="background-color: #fafafa; text-align: center;">조회수</th>
		</tr>
	<%--동호회 글 반복으로 뿌려주기 --%>
	<%
		for(int i = 0; i < articleList.size(); i++){
			Club_BoardDTO article = (Club_BoardDTO)articleList.get(i);%>
			<tr>
				<td><%=number-- %></td>
				<td><b><a href="../club/contentClub.jsp?category=club&clubNum=<%=clubNum%>&boardnum=<%=article.getBoardnum()%>&pageNum=<%=pageNum%>&bpageNum=<%=bpageNum%>"><%=article.getTitle() %></a></b></td>
				<td><%=article.getWriter() %></td>
				<td><%=sdf.format(article.getReg())%></td>
				<td><%=article.getReadcount() %></td>
			</tr>
	 <%}%>
	</table>
	<br />
	<%--페이지 번호 부여 --%>
		<div align="center">
			<%
				//총 몇 페이지가 나오는지 계산, 계산이 딱 떨어지면 page 추가 안된다는 뜻 
				int pageCount = count/pageSize + (count%pageSize == 0 ? 0:1);
				// 몇 개의 페이지 씩 보여줄지 설정
				int pageBlock = 2;
				// 현재 위치한 페이지에서 페이지 뷰어 첫 번째 숫자가 무엇인지 찾기 
				// 앞자리 구하고 +1
				int startPage=(int)((currPage-1)/pageBlock) * pageBlock +1;
				// 현재 위치한 페이지에서 페이지 뷰어 마지막 숫자가 
				int endPage= startPage + pageBlock - 1;
				// 마지막 보여지는 페이지 뷰어에 페이지 수가 꽉차는게 아니라면
				// 마지막 페이지 번호가 페이지 수가 되게 만들어줌
				if(endPage>pageCount) endPage = pageCount;
				//  < 6 7 8 9 10
				//앞으로 가는 기호
				if(startPage>pageBlock){%>
				<a href="../club/boardClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>&bpageNum=<%=startPage-pageBlock%>"> &lt;</a>
		 	 <%}
				//조건 검색 일 때 
				if(sel != null && search !=null){
					for(int i = startPage; i <= endPage; i++){%>
						<a href="../club/boardClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>&bpageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>">&nbsp; <%=i%> &nbsp;</a>	
			  	  <%}%>
			  <%}else{		
				//조건 검색이 아닐때 
				for(int i = startPage; i <= endPage; i++){%>
					<a href="../club/boardClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>&bpageNum=<%=i%>">&nbsp; <%=i%> &nbsp;</a>
			  <%}
			  	}
		    
			//뒤로 가는 기호 
			if(endPage < pageCount){%>
				 <a href="../club/boardClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>&bpageNum=<%=startPage + pageBlock%>">&gt;</a>
			<%}%>
			<br />
			<%--작성자/내용 검색 --%>
			<form action="../club/boardClub.jsp">
				<input type="hidden" name="category" value="club"/>
				<input type="hidden" name="pageNum" value="<%=pageNum %>"/>
				<input type="hidden" name="clubNum" value="<%=clubNum %>"/>
			<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
					<tr>
						<td>
							<select name="sel">
								<option value="title">제목</option>
								<option value="writer">작성자</option>
								<option value="content">내용</option>
							</select>
						</td>
						<td><input type="text" name="search" /></td>
						<td colspan="2">
							<input type="submit" value="검색" />	
						
					<%if (ldto == null){%>
					
					<%}else if(session.getAttribute("memId") != null && ldto.getAuthority() > 0 && ldto.getClubNum()==clubNum ){ //권한이 1부터, 동호회 회원 부터 글쓰기 가능%>
					
					
							<input type="button" value="글쓰기" onclick="window.location='../club/writeFormClub.jsp?category=club&clubNum=<%=clubNum%>&pageNum=<%=pageNum%>'"/>	
						</td>
					</tr>
					
						
					<%} %>
			</table>
			</form>
				
							<button onclick="window.location='findClub.jsp?category=club&pageNum=<%=pageNum%>'">동호회 목록</button>
				
		</div>
		<%}//else %>
</body>
</html>