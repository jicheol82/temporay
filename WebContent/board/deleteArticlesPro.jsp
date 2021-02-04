<%@page import="woodley.football.comboard.Notice_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteArticle</title>
</head>
<%
	String[] deleteList = request.getParameterValues("delete");
	String pageNum = request.getParameter("pageNum");
	Notice_BoardDAO dao = Notice_BoardDAO.getInstance();
	if(deleteList==null){
%>
		<script>
		alert("아무것도 선택되지 않았습니다.");
		history.go(-1)
		</script>	
<%
	}
%>
<%
	if(dao.deleteArticles(deleteList)){
%>
		<script>
			alert("삭제완료");
			window.location="../board/noticeBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>"
		</script>
<%	
	}else{
%>
		<script>
			alert("삭제실패");
			window.location="../board/noticeBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>"
		</script>
<%
	}
%>
<body>

</body>
</html>