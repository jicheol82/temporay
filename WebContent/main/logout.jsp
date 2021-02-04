<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> logout page </title>
</head>
<%
if(session.getAttribute("memId") != null){
	session.invalidate();%>
	<script>
		alert("로그아웃이 되었습니다.");
		window.location="/woodley/main/main.jsp";
	</script>
<% 	}else{ 
	
	

%>
<body>
</body>
<%} %>
</html>