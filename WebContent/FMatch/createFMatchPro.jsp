<%@page import="woodley.football.fmatch.FMatchDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>createFMatchPro</title>
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
<% request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="dto" class="woodley.football.fmatch.FMatchDTO" />
<jsp:setProperty property="*" name="dto"/>
<%
	FMatchDAO dao = FMatchDAO.getInstance(); 
	System.out.println(dao.createFMatch(dto));
	response.sendRedirect("../FMatch/findFMatch.jsp?event=football&category=fmatch");
%>
<body>

</body>
</html>