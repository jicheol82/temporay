<%@page import="woodley.football.comboard.Free_BoardReplyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%	request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="dto" class="woodley.football.comboard.Free_BoardReplyDTO"></jsp:useBean>
<jsp:setProperty property="*" name="dto"/>
<%
	Free_BoardReplyDAO dao = Free_BoardReplyDAO.getInstance();
	if(dto.getRef_num()==-1){
		// 본문의 댓글
		if(dao.insertReply(dto)){
			response.sendRedirect("freeBoardCon.jsp?category=comboard&num="+dto.getRef()+"&pageNum="+request.getParameter("pageNum"));
		}
	}else{
		if(dao.insertReReply(dto)){
			response.sendRedirect("freeBoardCon.jsp?category=comboard&num="+dto.getRef()+"&pageNum="+request.getParameter("pageNum"));
		}
	}
%>
<body>

</body>
</html>