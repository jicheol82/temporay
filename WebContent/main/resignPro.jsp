<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>resign Pro</title>
</head>
<% 	request.setCharacterEncoding("UTF-8"); %>
<% 	
	String pw = request.getParameter("pw");
	
	//세션에서 아이디를 resig.jsp에서 입력받은 비밀 번호를 가져온다.
	// 가져온 결과를 가지고 회원을 삭제한다.
	MemberDAO dao = MemberDAO.getInstance();
	
	
	
%>
<body>

</body>
</html>