<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> signup Pro</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="member" class= "woodley.main.member.MemberDTO" />

<%
	String path= request.getRealPath("save");
	int max = 1024*1024*5;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	member.setId(mr.getParameter("id"));
	member.setPw(mr.getParameter("pw"));
	member.setName(mr.getParameter("name"));
	member.setPhone(mr.getParameter("phone"));
	member.setBirth(mr.getParameter("birth"));
	member.setEmail(mr.getParameter("email"));
	member.setLocation(mr.getParameter("location"));
	member.setPrefer(mr.getParameter("prefer"));
	member.setProfile(mr.getFilesystemName("profile"));
	
	
	MemberDAO dao = MemberDAO.getInstance();
	dao.insertMember(member);
	
	response.sendRedirect("main.jsp");
	
%>

</body>
</html>