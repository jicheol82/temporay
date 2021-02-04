<%@page import="woodley.fooball.club.Club_ReplyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>Insert title here</title>
</head>
<%	
	//게시판 몇번 글로 돌아가야 하니까 boardnum
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	String pageNum = request.getParameter("pageNum");
	String bpageNum = request.getParameter("bpageNum");
	
	//몇번 댓글 지울지 
	int num = Integer.parseInt(request.getParameter("num"));
	//target 댓글 삭제 
	String target = request.getParameter("target");
	
	if(target.equals("reply")){
		Club_ReplyDAO dao = Club_ReplyDAO.getInstance();
		if(dao.deleteReply(num)){
%>
		<script>
				alert("삭제완료");
				window.location="contentClub.jsp?category=club&boardnum=<%=boardnum%>&clubNum=<%=clubNum%>&pageNum=<%=pageNum%>&bpageNum=<%=bpageNum%>"
		</script>
<% 
		}
	}
%>
<body>

</body>
</html>