<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LeaguelistaddPro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int League_num = Integer.parseInt(request.getParameter("league_num"));
	int club_num = Integer.parseInt(request.getParameter("club_num"));
	
	
	
	F_LeagueListDAO dao = F_LeagueListDAO.getInstance();
	
	dao.addLeagueList(League_num, club_num);
	response.sendRedirect("../League/infoLeague.jsp?league_num=" + League_num + "&category=league");
	
%>
<body>

</body>
</html>