<%@page import="java.util.List"%>
<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.football.league.F_Per_RecordDAO"%>
<%@page import="woodley.football.league.F_Team_RecordDAO"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>leagueacceptPro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int League_num = Integer.parseInt(request.getParameter("league_num")); // 리그넘버 받아온거
	int club_num = Integer.parseInt(request.getParameter("club_num")); // 클럽번호 받아온거
	String type = request.getParameter("type");
	
	F_LeagueListDAO dao = F_LeagueListDAO.getInstance(); // 리그리스트 DAO 싱글턴생성
	F_Team_RecordDAO dao2 = F_Team_RecordDAO.getInstance();
	if(type.equals("accept")) {
		dao.acceptLeague(League_num, club_num); // 리그 참가 수락
		dao2.createRecord(League_num, club_num); // 팀랭킹 디비에 추가
		F_Per_RecordDAO perdao = F_Per_RecordDAO.getInstance();
		List<MemberDTO> memList = perdao.getUserInfo(club_num);
		
		for(int i =0; i < memList.size();i++) { // 리그 생성 동호회 동호회원 모두 기록에 입력
			MemberDTO memdto = memList.get(i);
			perdao.inputPer_Record(League_num, club_num, memdto.getName());
		}
	}else {
		dao.leagueban(League_num, club_num);
	}
	
	
	response.sendRedirect("../League/manageLeagueTeam.jsp?league_num="+League_num+"&club_num=" + club_num +"&clubtype=nclub&category=league");
%>
<body>

</body>
</html>