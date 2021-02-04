<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>findPw Pro</title>
</head>
<% request.setCharacterEncoding("utf-8"); %>
<jsp:useBean id="member" class="woodley.main.member.MemberDTO"/>
<jsp:setProperty property="" name="member"/>
<%
	String memId = request.getParameter("memId");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	
	MemberDAO dao = MemberDAO.getInstance();
	String pw = dao.findPw(memId, name, email);  
	request.setAttribute("pw", pw);

%>
<%	if(pw == null){ %>
		<script type="text/javascript">
			alert("계정이 존재 하지 않습니다.");
			history.go(-1);
		</script>
<% }else{ %>
		<script type="text/javascript">
			alert("찾으시는 비밀번호는 <%=pw%> 입니다.");
			location.href="loginForm.jsp";
		</script>
<% } 	// 수정 예정 %>


<body>

</body>
</html>