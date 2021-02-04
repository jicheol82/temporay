<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.fooball.club.Club_ListDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>동호회원 관리</title>
</head>

<%
	request.setCharacterEncoding("UTF-8");
	//introClub에서 넘어오는 clubNum을 받음. 해당 번호의 동호회 관리 페이지 나오게 함 
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	String pageNum = request.getParameter("pageNum");
	//System.out.println("");
	//System.out.println("manageClub Num= "+clubNum);
	//동호회원 인지 예비 회원인지 확인하는 변수 
	String memtype= request.getParameter("memtype");
	//싱글톤 생성
	Club_ListDAO dao = Club_ListDAO.getInstance();
	
	//club_mem_list 에서 auth 받아오는 list 메서드 
	List authList =null;
	//members 에서 id, reg 찾아오는  메서드 
	List memList = null;
	
	//예비회원과 동호회원을 나눠야한다. 
	//auth = 0 , auth<0
	
	//처음에 들어왔을 때는 동호회원 
	if(memtype==null){
		memtype="rmem";
	}
	if(memtype.equals("rmem")){
		authList = dao.getClubMemAuth(clubNum);
		memList = dao.getClubMemIdReg(clubNum);
	}
	else if(memtype.equals("nmem")){
		authList = dao.getClubNMemAuth(clubNum);
		memList = dao.getClubNMemIdReg(clubNum);
	}
	
	//보이는 번호 설정
	int number = 1;
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<h2 align="center">동호회원 관리 </h2>
	<div align="center">
	<h5><a href="../club/manageClubMem.jsp?category=club&clubNum=<%=clubNum%>&memtype=rmem&pageNum=<%=pageNum%>">동호회원</a> | 
		<a href="../club/manageClubMem.jsp?category=club&clubNum=<%=clubNum%>&memtype=nmem&pageNum=<%=pageNum%>">예비회원</a></h5>
	
	
	<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
		<tr>
			<td>번호</td>
			<td>상태</td>
			<td>회원아이디</td>
			<td>가입일</td>
			<td>action</td>
		</tr>
		<%--반복 뿌려주는 테이블 
		같은 조건의 sql문 사용 했기 때문에 authList, memList 사이즈 같은 것임.
		 --%>
			<%if(authList==null){	%>
				<%if(memtype.equals("rmem")){%>
				<tr>
					<td colspan="5"><h5 align = "center">가입된 회원이 없습니다 </h5></td>
				</tr>
				<tr>
					<td colspan="5">
						<button onclick="window.location='../club/introClub.jsp?pageNum=<%=pageNum%>&category=club&clubNum=<%=clubNum%>'">동호회로 돌아가기</button>
					</td>
				</tr>
				<%}else{ %>
				<tr>
					<td colspan="5"><h5 align = "center">가입 신청 회원이 없습니다 </h5></td>
				</tr>
				<tr align="center">
					<td colspan="5" >
						<button onclick="window.location='../club/introClub.jsp?pageNum=<%=pageNum%>&category=club&clubNum=<%=clubNum%>'">동호회로 돌아가기</button>
					</td>
				</tr>
				<%} %>
			<%}else{
			for(int i = 0; i <authList.size(); i++){
				Club_ListDTO auth = (Club_ListDTO)authList.get(i);
				MemberDTO mem = (MemberDTO)memList.get(i);
			%>
		
		<tr>
			<td><%=number++%></td>
			<td><%=auth.getAuthority()%></td>
			<td><%=mem.getId()%></td>
			<td><%=mem.getReg()%></td>
			<%if(memtype.equals("rmem")){//동호회원 일 때 강퇴, 권한부여 
			//자기 자신에게는 버튼 안나오게, 권한부여는 auth가 1일 때만 가능 하게 	%>
				<%if(auth.getAuthority()==3){ %>
					<td>동호회장</td>
				<%}else{ %>
					<%if(auth.getAuthority()==1){ //권한이 1일 때만 부여 할 수 있게 %>
					<td><button onclick="window.location='../club/mClubAuth.jsp?pageNum=<%=pageNum%>&category=club&memid=<%=auth.getMemid()%>&clubNum=<%=clubNum%>'">권한 부여</button></td>
					<%} %>
					<td><button onclick="window.location='../club/mClubBan.jsp?pageNum=<%=pageNum%>&category=club&memid=<%=auth.getMemid()%>&clubNum=<%=clubNum%>&memtype=<%=memtype%>'">동호회 강퇴</button></td>
				<%} %>
			<%}else{//예비회원일 때 %>
				<td><button onclick="window.location='../club/mClubPass.jsp?pageNum=<%=pageNum%>&category=club&memid=<%=auth.getMemid()%>&clubNum=<%=clubNum%>'">가입 승인</button></td>
				<td><button onclick="window.location='../club/mClubBan.jsp?pageNum=<%=pageNum%>&category=club&memid=<%=auth.getMemid()%>&clubNum=<%=clubNum%>&memtype=<%=memtype%>'">가입 거절</button></td>
			<%} %>
		</tr>
		<%}%>
		<tr>
			<td colspan="5" align="center">
				<button onclick="window.location='../club/introClub.jsp?pageNum=<%=pageNum%>&category=club&clubNum=<%=clubNum%>'">동호회로 돌아가기</button>
			</td>
		</tr>
		
	</table>
	</div>
	<%}//else %>
</body>
</html>