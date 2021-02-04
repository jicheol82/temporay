<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.football.league.F_ResultDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@page import="woodley.football.league.F_ResultDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>schedulemanage</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int League_num = Integer.parseInt(request.getParameter("league_num"));
	F_ResultDAO dao = F_ResultDAO.getInstance();
 	Club_CreateDAO dao2 = Club_CreateDAO.getInstance();
 	List<F_ResultDTO> resultList = dao.getResult(League_num);
%>
	 
	
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<h1 align="center">리그 관리</h1>
	<div align="center">
	<a href="../League/modifyLeague.jsp?league_num=<%=League_num%>&category=league">리그 정보 수정</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
	<a href="../League/schedulemanage.jsp?league_num=<%=League_num%>&category=league">경기일정/결과 관리</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
	<a>개인기록 관리</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
	<a href="../League/manageLeagueTeam.jsp?league_num=<%=League_num%>&category=league">리그참가팀관리</a>
	</div>
	<br/><br/><br/>
	<h1 align="center">리그 일정/결과</h1>
	<div align="center">
		<table border="1">
			<th>날짜</th>
			<th>장소</th>
			<th>경기</th>
			<th>경기상태</th>
		<%if(resultList == null) { %>
			<tr>
				<td colspan="4">등록된 경기 일정이 없습니다 -_-;</td>
			</tr>
		<%}else { 
				for(int i = 0; i < resultList.size();i++) {
					F_ResultDTO result = resultList.get(i);
					Club_CreateDTO HomeTeam = dao2.getClub(result.getHomeclubnum());
					Club_CreateDTO AwayTeam = dao2.getClub(result.getAwayclubnum());
					if(result.getState() == 0) {%>
						<tr>
							<td><%=result.getMatchday()%></td>
							<td><%=HomeTeam.getGround() %></td>
							<td><%=HomeTeam.gettName()%><img src="/woodley/save/<%=HomeTeam.getEmblem()%>" /> VS
								<img src="/woodley/save/<%=AwayTeam.getEmblem() %>" /> <%=AwayTeam.gettName()%>
							</td>
							<td align="center">
								경기전<br/>
								<button onclick="window.location='resultinput.jsp?result_num=<%=result.getResult_num()%>&league_num=<%=League_num%>&hometeam=<%=HomeTeam.getClubNum()%>&awayteam=<%=AwayTeam.getClubNum()%>&category=league'">경기결과등록</button>
							</td>
							
					<%}else {%>			
						<tr>
							<td><%=result.getMatchday()%></td>
							<td><%=HomeTeam.getGround() %></td>
							<td>
								<%=HomeTeam.gettName()%><img src="/woodley/save/<%=HomeTeam.getEmblem()%>" /> <%=result.getHomescore() %> : 
								<%=result.getAwayscore() %><img src="/woodley/save/<%=AwayTeam.getEmblem() %>" /> <%=AwayTeam.gettName()%>
							</td>
							<td align="center">
								경기완료<br/>
							</td>
						</tr>
				    <%}// else 끝
			   	} // for문 끝
			 }%>
		</table>
		<div align="center"><button onclick="window.location='../League/scheduleForm.jsp?league_num=<%=League_num%>&category=league'">경기일정등록</button></div>
	</div>
			
		

</body>
</html>