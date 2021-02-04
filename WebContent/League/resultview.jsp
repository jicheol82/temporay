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
<title>resultview</title>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
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
	<br />
	<div align="center">
		<a href="../League/infoLeague.jsp?league_num=<%=League_num%>&category=league">리그정보</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/teamRank.jsp?league_num=<%=League_num%>&category=league">팀랭킹</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/indivRank.jsp?league_num=<%=League_num%>&category=league">개인기록</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/resultview.jsp?league_num=<%=League_num%>&category=league">경기일정/결과</a>
	</div>
	
	<h1 align="center">리그 일정/결과</h1>
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
			
			<thead style="background-color: #90CAF9; text-align: center;"> 
				<th>날짜</th>
				<th>장소</th>
				<th>경기</th>
				<th>경기상태</th>
			</thead>
			<%if(resultList != null) {  // 경기일정 결과가 하나라도 있으면
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
							<td>
								경기전<br/>
							</td>
								
					<%}else {%>			
						<tr>
							<td><%=result.getMatchday()%></td>
							<td><%=HomeTeam.getGround() %></td>
							<td>
								<%=HomeTeam.gettName()%><img src="/woodley/save/<%=HomeTeam.getEmblem()%>" /> <%=result.getHomescore() %> : 
								<%=result.getAwayscore() %><img src="/woodley/save/<%=AwayTeam.getEmblem() %>" /> <%=AwayTeam.gettName()%>
							</td>
							<td>
								경기완료<br/>
							</td>
						</tr>
				    <%}// else 끝%>	
			   <%} // for문 끝
			   }else { // 한개도 없으면 %>
			   	<tr>
			   		<td colspan="4">등록된 경기 일정이 없습니다 -_-;</td>
			   	</tr>
			  <%}%>
		</table>
</body>
</html>
			
		
