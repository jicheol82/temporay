<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pro</title>
</head>
<%	
	//manageClubMem에서 체크된 아이디를 배열로 받는다. 
	String [] id = request.getParameterValues("check");
	
	Club_ListDAO dao = Club_ListDAO.getInstance();
	
	
	for(int i = 0; i < id.length; i++){
		dao.deleteClubMem(id[i]);
		dao.deleteAuthMem(id[i]);
	}
	
	
%>
<body>

</body>
</html>