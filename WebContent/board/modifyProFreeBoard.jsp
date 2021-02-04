<%@page import="woodley.football.comboard.Free_BoardDAO"%>
<%@page import="woodley.football.comboard.Free_BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyProFreeBoard</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="article" class="woodley.football.comboard.Free_BoardDTO" />
<jsp:setProperty property="*" name="article"/>
<%

	String pageNum = request.getParameter("pageNum");
	int num = Integer.parseInt(request.getParameter("num"));

	Free_BoardDAO dao = Free_BoardDAO.getInstance();
	dao.updateArticle(article, num);
	response.sendRedirect("freeBoard.jsp?category=comboard&pageNum=" + pageNum);
 %>
	
<body>
</body>
</html>