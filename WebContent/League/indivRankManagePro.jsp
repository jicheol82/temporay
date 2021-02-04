<%@page import="woodley.football.league.F_Per_RecordDTO"%>
<%@page import="woodley.football.league.F_Per_RecordDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>indivRankManagePro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	
	int League_num = Integer.parseInt(request.getParameter("league_num"));
	String[] names = request.getParameterValues("names");
	String[] played = request.getParameterValues("played");
	String[] goals = request.getParameterValues("goals");
	String[] assist = request.getParameterValues("assist");
	String[] clubNum = request.getParameterValues("clubNum");
	F_Per_RecordDAO perdao = F_Per_RecordDAO.getInstance();
	
	
	
	
	for(int i =0; i < names.length;i++) {
		F_Per_RecordDTO dto = new F_Per_RecordDTO();
		dto.setLeague_num(League_num);
		dto.setName(names[i]);
		dto.setPlayed(Integer.parseInt(played[i]));
		dto.setGoals(Integer.parseInt(goals[i]));
		dto.setAssist(Integer.parseInt(assist[i]));
		dto.setClub_num(Integer.parseInt(clubNum[i]));
		perdao.modifyPerRecord(dto);
	}
		
	response.sendRedirect("indivRankManage.jsp?category=league&league_num=" + League_num);
	
%>
<body>
	
</body>
</html>