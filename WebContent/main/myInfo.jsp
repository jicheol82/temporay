<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
<title>My Info</title>
</head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
<%
	request.getParameter("UTF-8");
	
	String id = (String)session.getAttribute("memId");
	
	MemberDAO memdao = MemberDAO.getInstance();
	MemberDTO memdto = memdao.getMember(id);
	Club_ListDAO clubListDAO = Club_ListDAO.getInstance();
	String tname = clubListDAO.getTeamInfo(memdto.getClubnum());
	int count = 0;
	
%>



<body>
	<jsp:include page="../main/main.jsp"></jsp:include>	
	<br/><br/>
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="2"><h4>마이페이지</h4></th>
				</tr>
				</thead>
				<tr>
					<td style="text-align: left; border-right-style: solid; width: 120px; height: 150px"><img width="120px" height="150px" src="/woodley/save/<%=memdto.getProfile()%>" /> </td>
					<%if(tname.equals("")) { %> <td>가입된 동호회 없음 <br/><button class="btn btn-primary">회원정보 수정</button></td>
					<%}else{ %>
						<td style="text-align: left;">
							내가 가입한 동호회 : <%=tname%> <br/>
							<button class="btn btn-primary" onclick="window.location='../club/introClub.jsp?category=club&clubNum=<%=memdto.getClubnum()%>'">동호회페이지 이동</button> <br/>
							<button class="btn btn-primary" onclick="window.location='../League/myLeague.jsp?category=league&clubNum=<%=memdto.getClubnum()%>'">참여중인 리그 보기</button> <br/>
							<button class="btn btn-primary">회원정보 수정</button> <br/>
							<button class="btn btn-primary" onclick="window.location='../main/main.jsp'">뒤로</button> 
						</td>
							
						
						
					<%}%>
						
					
				</tr>
		</table>
	</div>
		
		
	
			
</body>
</html>
