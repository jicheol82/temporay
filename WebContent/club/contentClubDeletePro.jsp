<%@page import="woodley.fooball.club.Club_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 글 삭제 Pro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//몇 번 글 삭제하는지 
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	String pageNum = request.getParameter("pageNum");
	String bpageNum = request.getParameter("bpageNum");
	Club_BoardDAO dao = Club_BoardDAO.getInstance();
	dao.deleteArticle(boardnum);
	
	//pageNum 처리 해야함 
	response.sendRedirect("boardClub.jsp?category=club&clubNum="+clubNum+"&pageNum="+pageNum);
%>
<body>

</body>
</html>