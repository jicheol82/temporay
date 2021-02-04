<%@page import="woodley.fooball.club.Club_BoardDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>writeProClub</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="cboard" class="woodley.fooball.club.Club_BoardDTO"></jsp:useBean>
<%
	String path = request.getRealPath("save");
	//System.out.println("path " + path);
	int max = 1024*1024*5;
	
	String enc = "UTF-8";
	
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
			
	cboard.setTitle(mr.getParameter("title"));
	cboard.setWriter(mr.getParameter("writer"));
	cboard.setContent(mr.getParameter("content"));
	cboard.setPhoto(mr.getFilesystemName("photo"));
	cboard.setClubnum(Integer.parseInt(mr.getParameter("clubNum")));
	String pageNum = mr.getParameter("pageNum");
	Club_BoardDAO dao = Club_BoardDAO.getInstance();
	dao.insertArticle(cboard);
	
	//System.out.println("writePro clubNum =" + mr.getParameter("clubNum"));
	response.sendRedirect("boardClub.jsp?pageNum="+pageNum+"&category=club&clubNum="+ Integer.parseInt(mr.getParameter("clubNum")));
	
%>
<body>

</body>
</html>