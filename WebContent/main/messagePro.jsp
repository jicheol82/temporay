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
	String id = (String)session.getAttribute("memId");
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
	// 삭제와 쪽지쓰기를 한 페이지에서 실행
	request.setCharacterEncoding("utf-8"); 
	String function = request.getParameter("function");
	MessageDAO dao = MessageDAO.getInstance();
	if(function.equals("write")){
		
%>
		<jsp:useBean id="dto" class="woodley.main.message.MessageDTO"/>
		<jsp:setProperty property="*" name="dto"/>
<%
		//dto.setSender((String)session.getAttribute("userId"));
		dto.setSender(id);
		if(dao.sendMessage(dto)){
%>
			<script>
				alert("쪽지를 보냈습니다.")
				opener.document.location.reload();
				window.close();
			</script>
<%
		}
	}else if(function.equals("delete")){
		int[] num = {Integer.parseInt(request.getParameter("num"))};
		String cond = request.getParameter("cond");
		if(dao.deleteMessage(num, cond)){
%>
			<script>
				alert("쪽지를 삭제했습니다.")
				opener.document.location.reload();
				window.close();
			</script>
<%			
		}
	}
%>
<body>

</body>
</html>