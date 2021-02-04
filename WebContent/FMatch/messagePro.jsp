<%@page import="woodley.main.message.MessageDAO"%>
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
	// 친선경기용 쪽지는 보내기만
	request.setCharacterEncoding("utf-8"); 
	String function = request.getParameter("function");
	MessageDAO dao = MessageDAO.getInstance();
%>
	<jsp:useBean id="dto" class="woodley.main.message.MessageDTO"/>
	<jsp:setProperty property="*" name="dto"/>
<%
	String id = (String)session.getAttribute("memId");
	dto.setSender(id);
	if(dao.sendMessage(dto)){
%>
		<script>
			alert("쪽지를 보냈습니다.")
			window.close();
		</script>
<%
	}
%>
<body>

</body>
</html>