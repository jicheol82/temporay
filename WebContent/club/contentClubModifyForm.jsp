<%@page import="woodley.fooball.club.Club_BoardDTO"%>
<%@page import="woodley.fooball.club.Club_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>본문 글 수정 </title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//contentClub 에서 해당 글 번호를 받아온다. 
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	//clunNum을 content에서 받아옴
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	//System.out.println("contentModify clubNum =" + clubNum);
	
	String pageNum = request.getParameter("pageNum");
	String bpageNum = request.getParameter("bpageNum");
	
	Club_BoardDAO dao = Club_BoardDAO.getInstance();
	//boardnum 으로 글 가져오는 메서드 
	Club_BoardDTO article = dao.getArticle(boardnum);
%>
<body>
<jsp:include page="../main/main.jsp"></jsp:include>
<form action="contentClubModifyPro.jsp" method="post" enctype="multipart/form-data">
<input type="hidden" name="boardnum" value="<%=boardnum%>" />
<input type="hidden" name="clubNum" value="<%=clubNum%>" />
<input type="hidden" name="pageNum" value="<%=pageNum%>" />
<input type="hidden" name="bpageNum" value="<%=bpageNum%>" />
<div align="center">
<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
		<tr>
			<td colspan="2">제목 <input type="text" name="title" value="<%=article.getTitle()%>" /></td>
		</tr>
		<tr>
			<td>본문</td>
			<td><textarea rows="20" cols="50" name="content"><%=article.getContent()%></textarea></td>
		</tr>
		<tr>
			<td >
				<img src="/woodley/save/<%=article.getPhoto()%>" width="100" height="100" />
			</td>
			<td>
				사진 수정 <input type="file" name="photo"/>
			</td>
		</tr>
		<tr>
			<td>
				<input type="submit" value="수정"/>
				<input type="button" value="취소" onclick="window.location='contentClub.jsp?category=club&clubNum=<%=clubNum%>&boardnum=<%=boardnum %>'"/>
			</td>
			
	</table>
</div>
</form>
</body>
</html>