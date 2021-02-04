<%@page import="woodley.football.comboard.Free_BoardReplyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<% 
int num = Integer.parseInt(request.getParameter("num")); ///freeBoardCon에서 댓글넘버(Free_board_reply_num) 가져옴
String pageNum = request.getParameter("pageNum");   //freeBoardCon에서 게시글넘버 (Free_board_num)가져옴

String target = request.getParameter("target");

	//댓글 삭제
	if(target.equals("reply")){	
		Free_BoardReplyDAO dao = Free_BoardReplyDAO.getInstance();
		if(dao.deleteReply(num)){
%>
			<script>				alert("삭제완료");
				window.location="freeBoardCon.jsp?category=comboard&num=<%=pageNum%>"
			</script>
<%	
		}else{
%>
			<script>
				alert("삭제실패");
				window.location="freeBoard.jsp?category=comboard&pageNum=<%=pageNum%>"
			</script>
<%
		}
	}
	
	%>
<body>

</body>
</html>