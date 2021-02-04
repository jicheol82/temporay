<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가입승인</title>
</head>
<%
	//예비회원을 가입승인 시켜 권한을 0에서 1로 올려주는 메서드 
	String memid = request.getParameter("memid");
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	String pageNum = request.getParameter("pageNum");
	
	//System.out.println("mClubPass memid" + memid);
	//System.out.println("mClubPass clubNum" + clubNum);

	Club_ListDAO dao = Club_ListDAO.getInstance();
	dao.upgradeAuth(memid, 1);
	
	response.sendRedirect("../club/manageClubMem.jsp?pageNum="+pageNum+"&category=club&memtype=nmem&clubNum="+clubNum);
%>
<body>

</body>
</html>