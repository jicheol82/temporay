<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login Pro</title>
</head>
<%	request.setCharacterEncoding("UTF-8"); %>

<%  if(session.getAttribute("memId") != null){ %>
		<script>
			alert("이미 로그인 되었습니다.");
			window.location="woodley/main/main.jsp";
		</script>
<% }else{ %>
<%
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String auto = request.getParameter("auto");	
	

	//쿠키가 있다면 다시 꺼내기
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie c : cookies){
			if(c.getName().equals("autoId")) id = c.getValue();
			if(c.getName().equals("autoPw")) id = c.getValue();
			if(c.getName().equals("autoCh")) id = c.getValue();
		}
	}
	
	// 로그인 체크해주기 >> id랑 pw 가 일치 하는지 확인
	MemberDAO dao = MemberDAO.getInstance();
	boolean res = dao.idPwCheck(id, pw);
	
	if(res){
		if(auto != null){
			Cookie c1= new Cookie("autoId", id);
			Cookie c2= new Cookie("autoPw", id);
			c1.setMaxAge(60*60*24);
			c2.setMaxAge(60*60*24);
			response.addCookie(c1);
			response.addCookie(c2);
		}
		// id pw 일치 일때 로그인 상태 유지 해주기
		session.setAttribute("memId", id);
		response.sendRedirect("main.jsp");
	}else{ %>
	<script>
		alert("아이디 혹은 비밀번호가 일치 하지 않습니다.");
		history.go(-1);
	</script>
<% } %>		
	
<body>
<% } %> 
</body>
</html>


	

	
	
	
	
	
