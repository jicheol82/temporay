<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleForm</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	
	int League_num = Integer.parseInt(request.getParameter("league_num")); 
	int authority = 0; // 0 = 리그 참가신청중인 팀 제외하고 다 가져온다
	F_LeagueListDAO dao = F_LeagueListDAO.getInstance(); // 리그 리스트 DAO 싱글턴 생성
	
	List<Club_CreateDTO> joinClubList = dao.getallList(League_num, authority);
	
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<br>
	<div align="center">
		<form action="../League/schedulePro.jsp?category=league" method="post">
			<input type="hidden" name="league_num" value=<%=League_num %>>
			<table>
				<tr>
					<td>경기일자 : </td>
					<td><input type="text" name="matchday" /></td>
				</tr>
				<tr>
					<td>경기시간 : </td>
					<td><input type="text" name="matchtime" /></td>
				</tr>
				<tr>
					<td> HOME팀 : </td>
					<td>
						<select name="homeclubnum">
							<%for(int i =0; i < joinClubList.size();i++) {
								Club_CreateDTO dto = joinClubList.get(i); // 리그 참가중인 팀들 셀렉트 포문%>
								<option value="<%=dto.getClubNum()%>"><%=dto.gettName()%></option>
							<%}%>
						</select>
					</td>
				</tr>
				<tr>
					<td> AWAY 팀 : </td>
					<td>
						<select name="awayclubnum">
							<%for(int i =0; i < joinClubList.size();i++) {
								Club_CreateDTO dto = joinClubList.get(i); // 리그 참가중인 팀들 셀렉트 포문%>
								<option value="<%=dto.getClubNum()%>"><%=dto.gettName()%></option>
							<%}%>
						</select>
					</td>
				</tr>
				<tr>
					<td><input type="submit" value="경기등록" /></td>
					<td><button type="button" onclick="window.location='../League/schedulemanage.jsp?league_num=<%=League_num%>&category=league'">뒤로</button></td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>