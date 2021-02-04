<%@page import="woodley.football.league.F_Team_RecordDAO"%>
<%@page import="woodley.football.league.F_Team_RecordDTO"%>
<%@page import="woodley.football.league.F_ResultDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>resultPro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int result_num = Integer.parseInt(request.getParameter("result_num"));
	
	int League_num = Integer.parseInt(request.getParameter("league_num"));
	int homescore = Integer.parseInt(request.getParameter("homescore"));
	int awayscore = Integer.parseInt(request.getParameter("awayscore"));
	int hometeam = Integer.parseInt(request.getParameter("hometeam"));
	int awayteam = Integer.parseInt(request.getParameter("awayteam"));
	
	F_ResultDAO dao = F_ResultDAO.getInstance();
	F_Team_RecordDAO dao2 = F_Team_RecordDAO.getInstance();
	dao.resultcomplete(result_num, homescore, awayscore);
	
	
	if(homescore > awayscore) { // 홈팀이 이길시
		F_Team_RecordDTO homerank = new F_Team_RecordDTO();
		F_Team_RecordDTO awayrank = new F_Team_RecordDTO();
		homerank.setLeague_num(League_num);
		homerank.setClub_num(hometeam);
		homerank.setPlayed(1);
		homerank.setGf(3);
		homerank.setWon(1);
		homerank.setDrwn(0);
		homerank.setLost(0);
		homerank.setGoals(homescore);
		homerank.setRuns(awayscore);
		System.out.println("실점 : " + homerank.getRuns());
		homerank.setGd(homescore - awayscore);
		
		awayrank.setLeague_num(League_num);
		awayrank.setClub_num(awayteam);
		awayrank.setPlayed(1);
		awayrank.setGf(0);
		awayrank.setWon(0);
		awayrank.setDrwn(0);
		awayrank.setLost(1);
		awayrank.setGoals(awayscore);
		awayrank.setRuns(homescore);
		awayrank.setGd(awayscore - homescore);
		
		dao2.updateTeamRank(homerank);
		dao2.updateTeamRank(awayrank);
	}else if(homescore == awayscore) { // 비겻을시
		F_Team_RecordDTO homerank = new F_Team_RecordDTO();
		F_Team_RecordDTO awayrank = new F_Team_RecordDTO();
		homerank.setLeague_num(League_num);
		homerank.setClub_num(hometeam);
		homerank.setPlayed(1);
		homerank.setGf(1);
		homerank.setWon(0);
		homerank.setDrwn(1);
		homerank.setLost(0);
		homerank.setGoals(homescore);
		homerank.setRuns(awayscore);
		homerank.setGd(homescore - awayscore);
		
		awayrank.setLeague_num(League_num);
		awayrank.setClub_num(awayteam);
		awayrank.setPlayed(1);
		awayrank.setGf(1);
		awayrank.setWon(0);
		awayrank.setDrwn(1);
		awayrank.setLost(0);
		awayrank.setGoals(awayscore);
		awayrank.setRuns(homescore);
		awayrank.setGd(awayscore - homescore);
		
		dao2.updateTeamRank(homerank);
		dao2.updateTeamRank(awayrank);
	}else if(awayscore > homescore) { // 어웨이팀 승리시
		F_Team_RecordDTO homerank = new F_Team_RecordDTO();
		F_Team_RecordDTO awayrank = new F_Team_RecordDTO();
		homerank.setLeague_num(League_num);
		homerank.setClub_num(hometeam);
		homerank.setPlayed(1);
		homerank.setGf(0);
		homerank.setWon(0);
		homerank.setDrwn(0);
		homerank.setLost(1);
		homerank.setGoals(homescore);
		homerank.setRuns(awayscore);
		homerank.setGd(homescore - awayscore);
		
		awayrank.setLeague_num(League_num);
		awayrank.setClub_num(awayteam);
		awayrank.setPlayed(1);
		awayrank.setGf(3);
		awayrank.setWon(1);
		awayrank.setDrwn(0);
		awayrank.setLost(0);
		awayrank.setGoals(awayscore);
		awayrank.setRuns(homescore);
		awayrank.setGd(awayscore - homescore);
		
		dao2.updateTeamRank(homerank);
		dao2.updateTeamRank(awayrank);
	}
	response.sendRedirect("../League/schedulemanage.jsp?league_num="+ League_num + "&category=league");
	
	
%>
<body>

</body>
</html>