<%@page import="woodley.football.league.F_Team_RecordDAO"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>leaguebanPro</title>
</head>
<%
	int League_num = Integer.parseInt(request.getParameter("league_num"));
	int club_num = Integer.parseInt(request.getParameter("club_num"));
	
	F_LeagueListDAO dao = F_LeagueListDAO.getInstance();
	F_Team_RecordDAO dao2 = F_Team_RecordDAO.getInstance();
	dao2.deleteTeamRank(League_num, club_num);
	dao.leagueban(League_num, club_num);
	
	response.sendRedirect("../League/manageLeagueTeam.jsp?league_num="+League_num+"&club_num="+club_num+"clubtype=rclub&category=league");
%>
<body>
	
</body>
</html>