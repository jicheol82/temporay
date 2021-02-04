<%@page import="woodley.main.alert.AlertDAO"%>
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
<%
	String request1 = request.getParameter("request");
	int num	= Integer.parseInt(request.getParameter("num"));
	int ref	= Integer.parseInt(request.getParameter("ref"));
	int state	= Integer.parseInt(request.getParameter("state"));
	
	if(AlertDAO.getInstance().changeState(request1, ref, num, state)){
%>
		<script>
			alert("요청을 처리 하였습니다.");
			window.location="../main/alert.jsp?event=football&category=alert";
		</script>
<%
	}else{
%>
		<script>
			alert("요청이 처리되지 못하였습니다.");
			window.location="../main/alert.jsp?event=football&category=alert";
		</script>
<%		
	}
%>
<body>

</body>
</html>