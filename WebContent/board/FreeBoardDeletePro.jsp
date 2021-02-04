
<%@page import="woodley.football.comboard.Free_BoardReplyDAO"%>
<%@page import="woodley.football.comboard.Free_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete pro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	

	
	
	
	
	//DAO 통해서 글 삭제
	Free_BoardDAO dao = Free_BoardDAO.getInstance();
	boolean res = dao.deleteArticle(num);
	
	if(res){
		response.sendRedirect("freeBoard.jsp?category=comboard&pageNum=" + pageNum);
	}
%>	 
	
<body>

</body>
</html>