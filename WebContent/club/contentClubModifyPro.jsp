<%@page import="woodley.fooball.club.Club_BoardDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동호회 게시판 글 수정 Pro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="article" class="woodley.fooball.club.Club_BoardDTO"></jsp:useBean>
<%
	
	String path = request.getRealPath("save");

	int max = 1024 * 1024 * 5;

	String enc = "UTF-8";

	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();

	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	//몇 번 글인지 받아오기 
	int boardnum = Integer.parseInt(mr.getParameter("boardnum"));
	int clubNum = Integer.parseInt(mr.getParameter("clubNum"));
	//System.out.println("contentModifyPro clubNum =" + clubNum);
	
	String pageNum = mr.getParameter("pageNum");
	String bpageNum = mr.getParameter("bpageNum");
	//boardnum을 세팅해주는 이유는 메서드에서 몇 번 글을 업데이트 할 지 찾아야 하기 때문!
	article.setBoardnum(boardnum);
	article.setTitle(mr.getParameter("title"));
	article.setContent(mr.getParameter("content"));
	article.setPhoto(mr.getFilesystemName("photo"));
	
	Club_BoardDAO dao = Club_BoardDAO.getInstance();
	dao.updateArticle(article);
	
	response.sendRedirect("contentClub.jsp?category=club&boardnum=" +boardnum+"&pageNum="+pageNum+"&bpageNum="+bpageNum+"&clubNum="+clubNum);
%>
<body>

</body>
</html>