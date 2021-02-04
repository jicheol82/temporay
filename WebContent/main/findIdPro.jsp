<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>findId Pro</title>
</head>
<% request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="member" class="woodley.main.member.MemberDTO"/>
<jsp:setProperty property="" name="member"/>
<%
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	
	MemberDAO dao = MemberDAO.getInstance();
	
	String id = dao.findId(name, email);
%>
<%	if(id == null){ %>
		<script type="text/javascript">
			alert("계정이 존재 하지 않습니다.");
			history.go(-1);
		</script>
<% }else{ %>
		<script type="text/javascript">
			alert("찾으시는 계정은 <%=id%> 입니다.");
			location.href="loginForm.jsp";
		</script>
<% }%>


<body>

</body>
</html>