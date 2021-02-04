<%@page import="woodley.football.comboard.Mercenary_ReplyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%	
	// url 접근 방지
	String referer = request.getHeader("referer");
	if(referer == null){
%>
		<script>
			alert("비정상적인 접근입니다.");
			history.go(-1);
		</script>
<%	
	}
%>
<%	request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="dto" class="woodley.football.comboard.Mercenary_ReplyDTO"></jsp:useBean>
<jsp:setProperty property="*" name="dto"/>
<%
	Mercenary_ReplyDAO dao = Mercenary_ReplyDAO.getInstance();
	if(dao.insertReply(dto)){
		response.sendRedirect("../board/recruitBoardCon.jsp?event=football&category=comboard&num="+dto.getRef()+"&pageNum="+request.getParameter("pageNum"));
	}else{
%>
		<script>
			alert("댓글작성 실패하였습니다.");
			history.go(-1);
		</script>
<%	
	}


	
%>
<body>

</body>
</html>