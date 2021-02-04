
<%@page import="woodley.football.comboard.Free_BoardDTO"%>
<%@page import="woodley.football.comboard.Free_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
<title>글 수정</title>
</head>
<% 
	// 글 고유번호, 페이지번호
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	// DB에서 글 고유번호로 해당 글 모든 내용 받아오기
	Free_BoardDAO dao = Free_BoardDAO.getInstance();
	Free_BoardDTO article = dao.getArticle(num);
	
	// 화면에 뿌려주기
%>
<body>
<jsp:include page ="../main/main.jsp" flush="false"></jsp:include>
	<br />
	<h1 align="center"> 수정</h1>
	<form action="modifyProFreeBoard.jsp?pageNum=<%=pageNum%>" method="post">
		<%-- 글 고유번호 숨겨서 보내기 --%>
		<input type="hidden" name="num" value="<%=num%>" />
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<tr>
				<td>작성자</td>
				<td align="left"><input type="text" name="writer" value="<%=article.getWriter()%>" style="background-color:transparent;border:0 solid black;text-align:right;" onfocus="this.blur()" readonly /></td>
			</tr>
			<tr>
				<td>제 목</td>
				<td align="left"><input type="text" name="title" value="<%=article.getTitle()%>" /></td>
			</tr>
			<tr>
				<td>내용 </td>
				<td align="left"><textarea rows="20" cols="70" name="content" ><%=article.getContent()%></textarea></td>
			</tr>
			
			
			<tr>
			<td colspan="2">
<%
					if(article.getImg()==null){
%>
						<img src="https://concrete.store/Content/images/not-available.jpg" width="100" /><br/>
<%					
					}else{
%>
						<img src="/woodley/save/<%=article.getImg()%>" width="100" /><br/>
<%					
					}
%>						<input type="hidden" name="oldimg" value="<%=article.getImg()%>"/>
						<input type="file" name="img" />
			 </td>
		</tr>
		
		
			<tr>
				<td colspan="2">
					<input type="submit" value="수정" />
					<input type="button" value="취소" onclick="window.location='freeBoard.jsp?pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>