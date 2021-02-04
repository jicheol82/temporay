<%@page import="woodley.football.fmatch.FMatchDAO"%>
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
	int num = Integer.parseInt(request.getParameter("num"));
	if(FMatchDAO.getInstance().deleteFMatch(num)){
		%>
		<script>
				alert("삭제 성공하였습니다");
				window.location="../FMatch/findFMatch.jsp?event=football&category=fmatch";
		</script>
		<%
	}else{
		%>
		<script>
				alert("삭제하지 못하였습니다.");
				history.go(-1);
		</script>
		<%
	}
%>
<body>

</body>
</html>