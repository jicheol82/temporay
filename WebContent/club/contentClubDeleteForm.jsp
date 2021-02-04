<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>삭제 확인창</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//몇 번 게시글인 지 받는다
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	//clubNum을 받아 취소 할 때 돌아가지도록 한다. 
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	String pageNum = request.getParameter("pageNum");
	String bpageNum = request.getParameter("bpageNum");
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<form action="contentClubDeletePro.jsp" method="post">
		<input type="hidden" name="boardnum" value="<%=boardnum %>"/>
		<input type="hidden" name="clubNum" value="<%=clubNum%>" />
		<input type="hidden" name="pageNum" value="<%=pageNum%>" />
		<input type="hidden" name="bpageNum" value="<%=bpageNum%>" />
		<table>
			<tr>
				<td>정말 삭제 하시겠습니까?</td>
			</tr>
			<tr>
				<td>
					<input type="submit" value="예"/>
					<input type="button" value="아니오" onclick="window.location='contentClub.jsp?category=club&clubNum=<%=clubNum%>&boardnum=<%=boardnum%>'"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>