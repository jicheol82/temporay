<%@page import="woodley.main.member.MemberDAO"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강퇴</title>
</head>
<%
	//동호회원,예비회원을 강퇴하는 메서드 memtype으로 돌아가는 화면만 조정해줌 
	// members에서 clubnum을 0으로 만들고, club_mem_list에서 아예 지워야함 
	String memtype = request.getParameter("memtype");
	String memid = request.getParameter("memid");
	String pageNum = request.getParameter("pageNum");
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	
	//club_mem_list에서 아예 삭제 
	Club_ListDAO dao = Club_ListDAO.getInstance();
	dao.deleteClubMem(memid);

	//members에서 clubnum0으로 만들어줌, 어차피 memid랑 id가 같음 
	dao.deleteAuthMem(memid);	
	
	response.sendRedirect("../club/manageClubMem.jsp?pageNum="+pageNum+"&category=club&memtype="+memtype+"&clubNum="+clubNum);
%>
<body>

</body>
</html>