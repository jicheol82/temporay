<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.fooball.club.Club_ListDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.main.member.MemberDAO"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
<title>동호회 소개 </title>
</head>
<%	
	//세션으로 아이디 값 받음 
	String id = (String)session.getAttribute("memId");
	String pageNum = request.getParameter("pageNum");
	
	//회원 아이디로 동호회 권한 확인 하는 메서드 
	Club_ListDAO ldao = Club_ListDAO.getInstance();
	Club_ListDTO ldto = ldao.checkMaster(id);
	
	//회원 아이디로 clubnum 확인 하는 메서드 
	MemberDTO mdto = ldao.checkMember(id);	
		
	//findClub 에서 타고 오는 clubNum을 받아서 해당 동호회의 정보를 보여줌 
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	
	Club_CreateDAO dao = Club_CreateDAO.getInstance();
	//clubNum으로 club 소개정보 가져오는 메서드 사용 
	Club_CreateDTO club = dao.getClub(clubNum);
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<%--배너 사진 --%>
	<div align="center">
	<h3 align="center"><a href="introClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 소개</a> | <a href="boardClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 게시판</a></h3>
			<img align="center" width="500" height="130"  src="/woodley/save/<%=club.getEmblem()%>" />

	<br /><br />
	<%--동호회 정보 --%>
	<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
		<tr>
			<td width="250px">지역: <%=club.gettLocal()%> </td>
			<td width="250px">활동구장: <%=club.getGround()%> </td>
		</tr>
		
		<tr>
			<td>연령: <%=club.getAvrAge()%> </td>
			<td>실력: <%=club.getSkill()%> </td>
		</tr>
		
		<tr>
			<td colspan="2" align="left">팀원 수 : <%=club.gettNum()%></td>
		</tr>

		<tr>
			<td>팀 소개 </td>
			<td><textarea rows="5" cols="50" readonly><%=club.getBio()%></textarea></td>
		</tr>

	<%--1. 로그인 된 상태 and 가입된 클럽이 없을 때 가입신청 버튼 뜸 
			해당 동호회에 신청한 준호원이면 신청 중이 떠야 함 
		2. 동호회 신청은 한 군데만 가능하게. mdto.getClubnum()==0
	--%>
		<tr>	
			<td colspan="2">
			<%if(ldto == null){%>
				
			<%}else if(session.getAttribute("memId") != null && mdto.getClubnum()==clubNum && ldto.getAuthority()==0){
			//로그인이 된 상태, 내가 속한 동호회가 여기 페이지 동호회 일 떄(members에서 받아온 clubnum 이랑 findclub에서 타고온  clubNum 이 같을 때)
			//동호회를 신청한 상태일 때 (권한이 0일 때 )
			%>
				<h3>승인 대기 중</h3>
			<%} %>
			
			<%if(session.getAttribute("memId") != null && mdto.getClubnum()==0){
			//로그인 된 상태, 가입된 클럽이 없을 때 (members에 clubnum이 0 일 때 )
			%>
		
			<button onclick="window.location='clubMemPro.jsp?category=club&clubNum=<%=clubNum%>'">가입신청</button>
			
			<%} %>
		
			<button onclick="window.location='findClub.jsp?category=club&pageNum=<%=pageNum%>'">동호회 목록</button>
		
			<%if(ldto == null){ //null 일 때 에러 방지 해주기 위해 %>
			
			<%}else if(ldto.getAuthority() >= 2 && mdto.getClubnum()==clubNum){ //권한이 2 이상이면서 자기가 속한 동호회 일떄 동호회 수정, 동호회 수정이 나오고 3일 때만 동호회 관리 나오게 %> 
		
						
						<button onclick="window.location='introClubModify.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>'">동호회 수정</button>
		
					<%if(ldto.getAuthority()==3){%>	
			
						<button onclick="window.location='manageClubMem.jsp?category=club&clubNum=<%=clubNum%>&pageNum=<%=pageNum%>'">동호회 관리</button>
			</td>
					<% } %>
			<%} //if(auth >= 2) 
			%>
		</tr>
	</table>
	</div>
</body>
</html>