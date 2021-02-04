<%@page import="woodley.fooball.club.Club_ReplyDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>reply_pro</title>
</head>
<% 
	//댓글 받는 페이지
	request.setCharacterEncoding("UTF-8"); 
String pageNum = request.getParameter("pageNum");
String bpageNum = request.getParameter("bpageNum");
//System.out.println("pageNum pro = " + pageNum);
//System.out.println("bpageNum pro = " + bpageNum);
%>
<jsp:useBean id="dto" class="woodley.fooball.club.Club_ReplyDTO"></jsp:useBean>
<jsp:setProperty property="*" name="dto"/>
<%	
	Club_ReplyDAO dao = Club_ReplyDAO.getInstance();
	//본문의 댓글 일 때 
	if(dto.getRef_num()==-1){
		if(dao.insertReply(dto)){
			response.sendRedirect("contentClub.jsp?category=club&boardnum="+dto.getRef()+"&bpageNum="+ request.getParameter("bpageNum")+"&boardnum="+ request.getParameter("boardnum")+"&clubNum="+ request.getParameter("clubNum")+"&pageNum="+ request.getParameter("pageNum"));
		}
	//대댓글 일 때 	 
	}else{
		if(dao.insertReReply(dto)){
			response.sendRedirect("contentClub.jsp?category=club&boardnum="+dto.getRef()+"&bpageNum="+ request.getParameter("bpageNum")+"&boardnum="+ request.getParameter("boardnum")+"&clubNum="+ request.getParameter("clubNum")+"&pageNum="+ request.getParameter("pageNum"));
		}		
	}

	
%>
<body>

</body>
</html>