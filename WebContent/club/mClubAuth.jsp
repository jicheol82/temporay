<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>권한 부여</title>
</head>
<%
	//권한이 1인 동호회원에게 권한2를 준다. (동호회 수정 가능 )
	String memid = request.getParameter("memid");
	String pageNum = request.getParameter("pageNum");
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	
	Club_ListDAO dao = Club_ListDAO.getInstance();
	dao.upgradeAuth(memid,2);
	
	response.sendRedirect("../club/manageClubMem.jsp?pageNum="+pageNum+"&category=club&memtype=rmem&clubNum="+clubNum);

%>
<body>


</body>
</html>