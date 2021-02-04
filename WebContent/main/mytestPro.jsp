<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	String location = request.getParameter("location");
	System.out.println("location"+location);
	System.out.println("location is null: "+(location==null));
	String search = request.getParameter("search");
	System.out.println("search"+search);
	System.out.println("search is null: "+(search==null));
	int Ilocation = Integer.parseInt(location);
%>
<body>

</body>
</html>