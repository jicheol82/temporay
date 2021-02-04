<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.football.league.F_LeagueListDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>manageLeagueTeam</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	
	String num = request.getParameter("league_num"); // 리그번호 넘어온거
	int League_num = Integer.parseInt(num); // 변환
	String clubtype = request.getParameter("clubtype"); // 리그참가팀인지 대기상태인지 확인하는변수
	F_LeagueListDAO dao = F_LeagueListDAO.getInstance(); // 싱글턴 생성
	List<Club_CreateDTO> clubList = null; 
	
	
	
	if(clubtype == null) { // 처음엔 무조건 참가팀 나열
		clubtype="rclub";
	}
	
	if(clubtype.equals("rclub")) { // 리그참가중인 팀 나열
		int authority = 1;
		clubList = dao.getclubList(League_num, authority);
	}
	else if(clubtype.equals("nclub")) { // 리그참가 대기팀 나열
		int authority = 0;
		clubList = dao.getclubList(League_num, authority);
	}
		
	
	
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
	<div align="center">
		<a href="../League/manageLeagueTeam.jsp?league_num=<%=League_num%>&clubtype=rclub&category=league">리그참가팀</a> | 
		<a href="../League/manageLeagueTeam.jsp?league_num=<%=League_num%>&clubtype=nclub&category=league">참가신청팀</a>
	</div>
	<br/><br/><br/>
	<div align="center">
		<table border="1">
			<th>팀명</th>
			<th>동호회원수</th>
			<th>지역</th>
			<th>평균연령</th>
			<th>실력</th>
			<th>동호회장</th>
			<%if(clubList == null) { %>
				<%if(clubtype.equals("rclub")) { %>
				<tr>
					<td colspan="6">참가중인 팀이 없습니다 -_-;</td>
				</tr>
				<%}else {%>
				<tr>
					<td colspan="6">리그 참가 신청팀이 없습니다 -_-;</td>
				</tr>
				<%}%>
			<%}else { 
				for(int i = 0; i < clubList.size();i++) {
					Club_CreateDTO dto = clubList.get(i);%>
					<tr>
						<td><img src="/woodley/save/<%=dto.getEmblem()%>"/><%=dto.gettName()%></td>
						<td><%=dto.gettNum()%></td>
						<td><%=dto.gettLocal()%></td>
						
						<td><%=dto.getAvrAge()%></td>
						<td><%=dto.getSkill()%></td>
						<td><%=dto.getHeadId()%></td>
						<%if(clubtype.equals("rclub")) { // 참여중인 팀 강퇴버튼 %>
							<td><button onclick="window.location='../League/leaguebanPro.jsp?league_num=<%=num%>&club_num=<%=dto.getClubNum()%>&category=league'">리그추방</button></td>
						<%}else { // 신청중인 팀 수락버튼 %>
							<td><button onclick="window.location='../League/leagueacceptPro.jsp?league_num=<%=num%>&club_num=<%=dto.getClubNum()%>&type=accept&category=league'">신청수락</button></td>
							<td><button onclick="window.location='../League/leagueacceptPro.jsp?league_num=<%=num%>&club_num=<%=dto.getClubNum()%>&type=reject&category=league'">신청거부</button></td>
							
						<%}// else 끝%>
					</tr>
				<% } // for문 끝
			} // else 끝%>
		</table>
	</div>
</body>
</html>
				
				
			
				
				
				