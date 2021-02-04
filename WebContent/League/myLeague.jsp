<%@page import="java.util.ArrayList"%>
<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%
	request.setCharacterEncoding("UTF-8");
	int pageSize = 8;
	String pageNum = request.getParameter("pageNum"); 
	if(pageNum == null) {
		pageNum = "1";
	}
	int club_num = Integer.parseInt(request.getParameter("clubNum"));
	F_LeagueListDAO leagueListDAO = F_LeagueListDAO.getInstance();
	int currPage = Integer.parseInt(pageNum);
	int startRow = (currPage -1) * pageSize +1; 
	int endRow = currPage * pageSize;	
	int count = 0;
	count = leagueListDAO.myLeagueCount(club_num);
	List<F_League_CreateDTO> myListDTO = leagueListDAO.getMyLeagueList(club_num, startRow, endRow);
	
	
	
	
%>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<br /><br />
	
	
	<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<tr>
			<th style="background-color: #fafafa; text-align: center;">리그명</th>
			<th style="background-color: #fafafa; text-align: center;">지역</th>
			<th style="background-color: #fafafa; text-align: center;">참가팀수</th>
			<th style="background-color: #fafafa; text-align: center;">기간</th>
			<th style="background-color: #fafafa; text-align: center;">리그생성자</th>
			<th style="background-color: #fafafa; text-align: center;">리그진행현황</th>
		</tr>
		<%if(myListDTO != null) { %>
			<% for(int i =0; i < myListDTO.size(); i++) {
				F_League_CreateDTO dto = myListDTO.get(i);%>
			<tr>
			
				
			
				<td>
					<a href="../League/infoLeague.jsp?category=league&league_num=<%=dto.getLeague_num()%>"><%=dto.getLeague_name()%></a>
				</td>
				
				<td><%=dto.getLocation() %></td>
				<td><%=dto.getJointeam() %></td>
				<td><%=dto.getPeriod() %></td>
				<td><%=dto.getCreater() %></td>
				<td><%
					  String state = "";
					  if(dto.getLeagueing() == 0) { state = "모집중"; }
					  else if(dto.getLeagueing() == 1) { state = "진행중"; }
					  else if(dto.getLeagueing() == 2) { state = "종료"; } 
					  out.print(state);%>
				</td> 
			</tr>
			<%} // 포문 끝%> 
		<%}else {%>
			<tr>
				<td colspan="6">참가중인 리그가 없습니다 -_-;</td>
			</tr>
		<%}%>
	</table>
				  
	<% 
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			// 보여줄 페이지 번호의 개수 지정
			int pageBlock = 5;	
			// 현재 위치한 페이지에서 페이지뷰어 첫번째 숫자가 무엇인지 찾기.
			int startPage = (int)((currPage - 1)/pageBlock) * pageBlock + 1;
			// 현재 위치한 페이지에서 페이지뷰어 마지막 숫자가 무엇인지 찾기
			int endPage = startPage + pageBlock - 1;
			// 마지막에 보여지는 페이지 뷰어에, 페이지 개수가 10개 미만일 경우
			// 마지막 페이지 번호가 (endPage)가 총 페이지 수가 되게 만들어줌.
			if(endPage > pageCount) endPage = pageCount;
	%>	 <div align="center"><% 
			// 앞으로 가는 기호(11~20 보고 있을때 1~10으로 이동하는 버튼)
				if(startPage > pageBlock) {%>
					<a href="../League/myLeague.jsp?clubNum=<%=club_num %>&pageNum=<%=startPage - pageBlock %>&category=league"> 이전 </a>
			  <%}
			    for(int i = startPage; i <= endPage; i++) { %>
			    	<a href="../League/myLeague.jsp?clubNum=<%=club_num %>&pageNum=<%= i%>&category=league"> &nbsp;<%= i %> &nbsp; </a>
			  <%}
			    if(endPage < pageCount) { %>
			    	<a href="../League/myLeague.jsp?clubNum=<%=club_num %>&pageNum=<%= startPage+pageBlock %>&category=league"> 다음</a>
			  <%} %>	
		  </div>
	
	
	

</body>
</html>