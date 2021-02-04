<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteForm</title>
	<link rel="stylesheet" href="../css/bootstrap.css">
</head>
<% 
	// 글 고유번호
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");

%>

<body>
<jsp:include page ="../main/main.jsp" flush="false"></jsp:include>
	<br/>
	<h1 align="center"> 삭제 </h1>
	<form action="FreeBoardDeletePro.jsp?pageNum=<%=pageNum%>" method="post">
		<%-- 글 고유번호 숨겨서 보내기 --%>
		<input type="hidden" name="num" value="<%=num %>" />
		<table align="center">
			<tr>
				<td>정말 삭제 하시겠습니까?</td>
			</tr>
			<tr>
				<td><input type="submit" value="삭제" />
				<td><input type="button" value="취소" onclick="window.location='freeBoard.jsp?category=comboard&pageNum=<%=pageNum%>'" />
			</tr>
		</table>
	
	</form>

</body>
</html>