<%@page import="woodley.football.comboard.Mercenary_ReplyDAO"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	String target = request.getParameter("target");
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	if(target.equals("content")){	//게시글 삭제
		Mercenary_BoardDAO dao = Mercenary_BoardDAO.getInstance();
		if(dao.deleteArticles(num)){
%>
			<script>				alert("삭제완료");
				window.location="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>"
			</script>
<%	
		}else{
%>
			<script>
				alert("삭제실패");
				window.location="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>"
			</script>
<%
		}
	}else if(target.equals("reply")){	//댓글 삭제
		Mercenary_ReplyDAO dao = Mercenary_ReplyDAO.getInstance();
		if(dao.deleteReply(num)){
%>
			<script>				alert("삭제완료");
				window.location="../board/recruitBoardCon.jsp?event=football&category=comboard&num=<%=request.getParameter("conNum")%>"
			</script>
<%	
		}else{
%>
			<script>
				alert("삭제실패");
				window.location="r../board/recruitBoardCon.jsp?event=football&category=comboard&num=<%=request.getParameter("conNum")%>"
			</script>
<%
		}
	}
%>

<body>

</body>
</html>