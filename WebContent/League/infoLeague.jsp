<%@page import="com.sun.org.apache.xalan.internal.xsltc.compiler.sym"%>
<%@page import="woodley.football.league.F_LeagueListDTO"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@page import="woodley.fooball.club.Club_ListDTO"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Info League</title>
</head>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
<%
	request.setCharacterEncoding("UTF-8");
	
	if(session.getAttribute("memId") == null) { %>
		<script>
			alert("비정상적인 접근입니다!");
			location="../main/main.jsp";
		</script>	
			
  <% }else{
	
		String id = (String)session.getAttribute("memId"); // 세션 아이디값 받기
		int league_num = Integer.parseInt(request.getParameter("league_num")); // 리그번호받기 
		Club_ListDAO clublistdao = Club_ListDAO.getInstance(); // 클럽리스트디에이오 생성
		Club_ListDTO clubListdto = clublistdao.checkMaster(id); // 동호회 리스트에 결과값 있으면 객체 생성 3이면 동호회장 
		F_LeagueListDAO LeagueListdao = F_LeagueListDAO.getInstance(); // 리그리스트 디에이오
		F_LeagueListDTO LeagueListdto = null; 
		
		if(clubListdto != null) { // 동호회 리스트에 결과값 있으면 들어오는곳
			LeagueListdto = LeagueListdao.checkjoinLeague(league_num, clubListdto.getClubNum());
		}
		F_League_CreateDAO dao = F_League_CreateDAO.getInstance(); // 리그 생성디에이오
		F_League_CreateDTO dto = dao.getInfoLeague(league_num); // 리그정보 불러오기
  		
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
	
	<div align="center">
		
		<img width="300px" align="center" src="/woodley/save/<%=dto.getBanner()%>"> <br />
		
		<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
			<tr> 
				<td>리그이름</td>  
				<td><%=dto.getLeague_name()%></td> 
			</tr>
			<tr> 
				<td>참가팀수</td>  
				<td> <%=dto.getJointeam() %></td> 
			</tr>
			<tr> 
				<td>리그기간</td>  
				<td> <%=dto.getPeriod() %></td> 
			</tr>
			<tr> 
				<td>리그소개</td>  
				<td><textarea readonly style="width:100%;" rows="5" ><%=dto.getContent() %></textarea></td> 
			</tr>
			 <tr>
			 	<td colspan="2">
			 		
					<%if(clubListdto != null && !dto.getCreater().equals(id) && LeagueListdto == null) { // 리그 생성자가 아닐때 참가요청버튼 보임 
					if(clubListdto.getAuthority() == 3 && dto.getLeagueing() == 0 && LeagueListdto == null) { // 동호회장이면서 리그 모집중일때이거나 참가요청 한번도 안눌렀을때 참가요청버튼 보임 %>
					<button class="btn btn-primary" onclick="window.location='../League/leaguelistaddPro.jsp?league_num=<%=league_num%>&club_num=<%=clubListdto.getClubNum()%>'">리그 참가 요청</button>
			  	   <%}
				
			 		 }else if(dto.getCreater().equals(id)) { // 리그 생성자이면 리그관리버튼 보이게끔 설정 %>
						<button class="btn btn-primary" type="button" onclick="window.location='../League/modifyLeague.jsp?league_num=<%=league_num%>&category=league'">리그 관리</button>
					<%}else if(LeagueListdto != null && clubListdto != null) { 
						 if(clubListdto.getClubNum() == LeagueListdto.getClub_num() && LeagueListdto.getAuthority() == 0) { // 참가요청중일때 %>
						<button class="btn btn-primary">참가수락대기중</button>
			   			<%}else if(clubListdto.getClubNum() == LeagueListdto.getClub_num() && LeagueListdto.getAuthority() == 1) { // 리그 참가중 %>	
	              		<button class="btn btn-primary">리그참가중</button>	  
					   <%}
					  }%>
					  <button class="btn btn-primary" type="button" onclick="window.location='../League/findLeague.jsp?category=league'">뒤로</button>
			 	</td>
			 </tr>
		  </table> 
	</div>
	
	
</body>
	<% } // else문 끝 %>
</html>