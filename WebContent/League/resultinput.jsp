<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>resultinput</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	int result_num = Integer.parseInt(request.getParameter("result_num"));
	
	int League_num = Integer.parseInt(request.getParameter("league_num"));
	int HomeTeam = Integer.parseInt(request.getParameter("hometeam"));
	int AwayTeam = Integer.parseInt(request.getParameter("awayteam"));
	Club_CreateDAO dao = Club_CreateDAO.getInstance();
	Club_CreateDTO ht = dao.getClub(HomeTeam);
	Club_CreateDTO at = dao.getClub(AwayTeam);
	
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<br/>
	<h1 align="center"> 경기결과 등록 </h1>
	<form action="../League/resultPro.jsp?category=league" method="post">
		<input type="hidden" value="<%=League_num%>" name="league_num" />
		<input type="hidden" value="<%=result_num%>" name="result_num" />
		<input type="hidden" value="<%=HomeTeam%>" name="hometeam" />
		<input type="hidden" value="<%=AwayTeam%>" name="awayteam" />
		
		<div align="center">
		<table>
			<tr>
				<td><%=ht.gettName()%><img src="/woodley/save/<%=ht.getEmblem()%>" /> <input type="text" name="homescore" value="0"/> : <input type="text" name="awayscore" value="0"/> 
								<img src="/woodley/save/<%=at.getEmblem() %>" /> <%=at.gettName()%> </td>
			</tr>
		</table>
		<br/><br/><br/>
		<input type="submit" value="경기결과등록" /> <button type="button" onclick="window.location=../League/schedulemanage.jsp?league_num=<%=League_num%>">뒤로</button>
		</div>
		
	</form>
</body>
</html>