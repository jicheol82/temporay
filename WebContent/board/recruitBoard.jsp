<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모집게시판</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<script>
	function check1(){
		var input = document.search;
		if(input.sel.value=="" || input.search.value==""){
			alert("검색범위와 검색어를 입력해주세요.");
			return false;
		}
	}
</script>
</head>
<%
	//로그인 처리부	-쿠키 사용하지 않음
	String id = (String)session.getAttribute("memId");
	boolean loggedin = false;	// login 상태 확인
	boolean admin = false;	// 관리자 파악
	if(id!=null){
		loggedin = true;
		if(id.equals("admin")) admin=true;
	}
	
	//글불러올 인스턴스들 생성
	Mercenary_BoardDAO dao = Mercenary_BoardDAO.getInstance();
	Mercenary_BoardDTO dto = new Mercenary_BoardDTO();
	List articlesList = null;
	
	//검색관련 처리
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	
	//페이지 관련 설정
	int numOfArticle = 5;	// 한페이지에 보여줄 게시글의 수
	int numOfAllArticles = (sel==null && search==null)? dao.getNumOfArticles(): dao.getNumOfArticles(sel, search);	// notice_board에 있는 모든(검색) 게시글의 수
	int numOfPage = 3;	// 한줄에 보여줄 페이지의 갯수
	int pageNum;	// 현재 페이지 번호
	int numOfAllPages = (numOfAllArticles%numOfArticle==0) ? (numOfAllArticles/numOfArticle) : (numOfAllArticles/numOfArticle)+1;	// 전체게시글이 표시될 페이지의 갯수
	if(numOfAllPages==0) numOfAllPages=1;	//게시글이 하나도 없는 경우만 예외적으로 endpage를 정의
	if(request.getParameter("pageNum")==null){	// 처음 noticeBoard.jsp가 호출됐을때
		pageNum = 1;
	}else{	// 다른 페이지에서 호출되어 넘어왔을때
		pageNum = Integer.parseInt(request.getParameter("pageNum"));
	}
	int startRow = (pageNum - 1) * numOfArticle + 1;	// 현재 페이지에서 시작하는 첫번째 글의 번호
	int endRow = startRow + numOfArticle - 1;		// 현재 페이지에서 끝나는 마지막 글의 번호
	
	int startPage = (((pageNum-1)/numOfPage) * numOfPage) + 1;	// 현재 페이지에서 시작하는 첫번째 페이지의 번호
	int endPage = (startPage + numOfPage - 1) >= numOfAllPages ? numOfAllPages : (startPage + numOfPage - 1);	// 현재 페이지에서 끝나는 마지막 페이지의 번호
	int articleNum = numOfAllArticles - ((pageNum - 1) * numOfArticle);	// 목록에 표시될 글의 번호
	
	
%>
<body>
	<jsp:include page="../main/main.jsp"/>
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
	<form action="../board/deleteArticlesPro.jsp" method="get">
		<input type="hidden" name="from" value="recruit" />
		<input type="hidden" name="pageNum" value="<%=pageNum%>"/>
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
			<tr>
<%
				if(admin){
%>
				<th style="background-color: #fafafa; text-align: center;">선    택</th>
<%
				}
%>
				<th style="background-color: #fafafa; text-align: center;">번   호</th>
				<th style="background-color: #fafafa; text-align: center;">말머리</th> <!-- 말머리 검색은 ajax로 구현해야 함 -->
				<th style="background-color: #fafafa; text-align: center;">글쓴이</th>
				<th style="background-color: #fafafa; text-align: center;">제   목</th>
				<th style="background-color: #fafafa; text-align: center;">작성일</th>
				<th style="background-color: #fafafa; text-align: center;">조회수</th>
			</tr>
<%
			//for문을 이용하여 notice_board에서 글 가져오기
			articlesList = (sel==null && search==null)?dao.getArticles(startRow, endRow):dao.getArticles(startRow, endRow, sel, search);	// 현재페이지에 표시할 글 가져오기
			for(int i=0;i<articlesList.size();i++){
				dto = (Mercenary_BoardDTO)articlesList.get(i);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>	
				<tr>
<%
				if(admin){
%>
					<td> <input type="checkbox" name="delete" value="<%=dto.getNum()%>"/> </td>
<%
				}
%>
					<td><%=articleNum--%></td>
					<td><%=dto.getBulletPoint() %>
					<td><%=dto.getWriter()%></td>
					<td>
<%				
				if(loggedin){ 
%>
						<a href="../board/recruitBoardCon.jsp?event=football&category=comboard&num=<%=dto.getNum()%>&pageNum=<%=pageNum%>"><%=dto.getTitle()%></a>
<%
				}else{
%>
						<%=dto.getTitle()%>
<%
				}
%>
					</td>
					<td><%=sdf.format(dto.getReg())%></td>
					<td><%=dto.getReadcount()%></td>
				</tr>
<%		
			}
%>
			<tr>
				<td colspan="7" align="right">
<%
				if(admin){
%>
					<input type="submit" value="글삭제"/>
<%
				}else if(loggedin){
%>
					<input type="button" onclick="location='../board/recruitWriteForm.jsp?event=football&category=comboard&pageNum=<%=pageNum%>'" value="글쓰기">
<%					
				}
%>
					
				</td>
			</tr>
		</table>
	</form>
	<div align="center">
<%
		//if 문으로 이전 페이지 넘어가게 처리
		if(startPage!=1){
%>
			<a href="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=1%>">≪&nbsp;</a>
			<a href="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=startPage-numOfPage<1?1:startPage-numOfPage%>">＜&nbsp;</a>
<%
		}
		// 페이지 번호 처리
		for(int i=startPage; i<=endPage; i++){
%>		
			<a href="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=i%>"><%=i%>&nbsp;</a>	
<%		
		}
		//if 문으로 이후 페이지 넘어가게 처리
		if(endPage!=numOfAllPages){
%>
			<a href="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=endPage+1>numOfAllPages?numOfAllPages:endPage+1%>">＞&nbsp;</a>
			<a href="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=numOfAllPages%>">≫</a>
<%
		}
%>
		<form action="../board/recruitBoard.jsp?" name="search" onsubmit="return check1()">
			<input type="hidden" name="event" value="football"/>
			<input type="hidden" name="category" value="comboard"/>
			<select name="sel">
				<option value="">선택하세요</option>
				<option value="writer">작성자</option>
				<option value="title">제목</option>
				<option value="content">내용</option>
				<option value="title_content">제목+내용</option>
			</select>
			<input type="text" name="search" />
			<input type="submit" value="검색" />
		</form>
	</div>
</body>
</html>