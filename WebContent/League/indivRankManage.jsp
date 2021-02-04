<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="woodley.football.league.F_Per_RecordDAO"%>
<%@page import="woodley.football.league.F_Per_RecordDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.main.member.MemberDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.football.league.F_LeagueListDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>indivRank</title>
<%
	request.setCharacterEncoding("UTF-8");
	int League_num = 89; // 일단 넣기
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null) {
		pageNum= "1";
	}
	int currPage = Integer.parseInt(pageNum);
	int pageSize = 5;
	int startRow = (currPage -1) * pageSize +1; 
	int endRow = currPage * pageSize;			
	int count = 0;
	
	F_LeagueListDAO listdao = F_LeagueListDAO.getInstance();
	int authority = 0; // 권한 0 이상인 리그참가중인 팀 목록불러오기
	List<Club_CreateDTO> allList = listdao.getallList(League_num, authority); // 리그 참가중인 팀들
	F_Per_RecordDAO perdao = F_Per_RecordDAO.getInstance();
	String allTeam = "";
	for(int i = 0; i < allList.size();i++) {
		Club_CreateDTO clubdto = allList.get(i);
		allTeam+= clubdto.getClubNum() + ",";
	}
	count = perdao.allCount(League_num);
	
	allTeam = allTeam.substring(0, allTeam.length()-1);
	List<F_Per_RecordDTO> allMemList = perdao.getPerRecord(League_num,startRow,endRow);
	
	
		
%>
</head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
<script src="../js/bootstrap.js"></script>




<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<h1 align="center">리그 관리</h1>
	
	<div align="center">
		<a href="../League/modifyLeague.jsp?league_num=<%=League_num%>&category=league">리그 정보 수정</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/schedulemanage.jsp?league_num=<%=League_num%>&category=league">경기일정/결과 관리</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a>개인기록 관리</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/manageLeagueTeam.jsp?league_num=<%=League_num%>&category=league">리그참가팀관리</a>
	</div>
	
	<br/><br/>
	
	<table class="table" style="text-align: center; border: 1px solid #dddddd;">
			<thead style="background-color: #90CAF9; text-align: center">
				<tr>
					<th>순위</th>
					<th>팀</th>
					<th>선수</th>
					<th>경기수</th>
					<th>득점</th>
					<th>도움</th>
				</tr>
			</thead>
			<tbody>
				<%for(int i=0; i < allMemList.size();i++) {
					F_Per_RecordDTO perdto = allMemList.get(i);%>
					<tr>
						<td><%=perdto.getRanked() %></td>
						
						<td><%=perdto.getTname() %></td> 
						<td width="300px">
							<img width="63px" height="88px" src="/woodley/save/<%=perdto.getProfile()%>" /> 
							<%=perdto.getName() %>
						</td>
						<td>
							<input type="text" name="played" value="<%=perdto.getPlayed() %>" />
						</td>
						<td><input type="text" name="goals" value="<%=perdto.getGoals() %>" /></td>
						<td><input type="text" name="assist" value="<%=perdto.getAssist() %>" /></td>
					</tr>
				<%}%>
			</tbody>	
		</table>
		<% 
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			// 보여줄 페이지 번호의 개수 지정
			int pageBlock = 5;	// 5
			// 현재 위치한 페이지에서 페이지뷰어 첫번째 숫자가 무엇인지 찾기.
			int startPage = (int)((currPage - 1)/pageBlock) * pageBlock + 1;
			// 현재 위치한 페이지에서 페이지뷰어 마지막 숫자가 무엇인지 찾기
			int endPage = startPage + pageBlock - 1;
			// 마지막에 보여지는 페이지 뷰어에, 페이지 개수가 10개 미만일 경우
			// 마지막 페이지 번호가 (endPage)가 총 페이지 수가 되게 만들어줌.
			if(endPage > pageCount) endPage = pageCount;%> 
			<div id="ajaxpage" align="center"><% 
				// 앞으로 가는 기호(11~20 보고 있을때 1~10으로 이동하는 버튼)
				if(startPage > pageBlock) {%>
					<a href="../League/indivRankManage.jsp?pageNum=<%=startPage - pageBlock %>&category=league"> 이전 </a>
		  	  <%}
		   		 for(int i = startPage; i <= endPage; i++) { %>
		    		<a href="../League/indivRankManage.jsp?category=league&pageNum=<%= i%>&category=league"> &nbsp;<%= i %> &nbsp; </a>
		  	   <%}
			    if(endPage < pageCount) { %>
			    	<a href="../League/indivRankManage.jsp?pageNum=<%= startPage+pageBlock %>&category=league"> 다음</a>
			  <%} %>	
	  	   </div>
		
		
		
	
</body>

</html>
	
	
	
	
	
	
	
	
	
	
	





	











