<%@page import="woodley.football.league.F_Team_RecordDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.football.league.F_Team_RecordDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>teamRank</title>
</head>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<%
	request.setCharacterEncoding("UTF-8");
	int league_num = Integer.parseInt(request.getParameter("league_num"));
	
	F_Team_RecordDAO dao = F_Team_RecordDAO.getInstance();
	Club_CreateDAO dao2 = Club_CreateDAO.getInstance();
	List<F_Team_RecordDTO> teamRankList = dao.teamRankList(league_num);
	
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<br />
		<div align="center">
			<a href="../League/infoLeague.jsp?league_num=<%=league_num%>&category=league">리그정보</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
			<a href="../League/teamRank.jsp?league_num=<%=league_num%>&category=league">팀랭킹</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
			<a href="../League/indivRank.jsp?league_num=<%=league_num%>&category=league">개인기록</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
			<a href="../League/resultview.jsp?league_num=<%=league_num%>&category=league">경기일정/결과</a>
		</div>
	<br/>
	<h1 align="center">팀 순위</h1>
	
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
			<thead style="background-color: #90CAF9; text-align: center">
				<tr>
					<th>순위</th>
					<th>팀</th>
					<th>경기수</th>
					<th>승점</th>
					<th>승</th> 
					<th>무</th>
					<th>패</th>
					<th>득점</th>
					<th>실점</th>
					<th>득실차</th>
				</tr>
			</thead>
			<%if(teamRankList != null) {
				for(int i =0; i < teamRankList.size();i++) {
					F_Team_RecordDTO record = teamRankList.get(i);
					Club_CreateDTO dto = dao2.getClub(record.getClub_num());%>
					<tr>
						<td>#<%=record.getRanked()%></td>
						<td><img src="/woodley/save/<%=dto.getEmblem()%>" width="30" height="30" /><%=dto.gettName()%></td>
						<td><%=record.getPlayed() %></td>
						<td><%=record.getGf() %></td>
						<td><%=record.getWon() %></td>
						<td><%=record.getDrwn() %></td>
						<td><%=record.getLost() %></td>
						<td><%=record.getGoals() %></td>
						<td><%=record.getRuns() %></td>
						<td><%=record.getGd() %></td>
					</tr>
		      <%} // for문 끝
		      }else {%>
		      	<tr>
		      		<td colspan="10">아직 참가 신청팀이 없습니다.</td>
		      	</tr>
		     <%}%>
		</table>
</body>
</html>
		

			