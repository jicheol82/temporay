<%@page import="woodley.football.fmatch.FMatchDTO"%>
<%@page import="woodley.football.fmatch.FMatchDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.main.message.MessageDAO"%>
<%@page import="woodley.main.message.MessageDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%	
	// url 접근 방지
	String referer = request.getHeader("referer");
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
	request.setCharacterEncoding("utf-8");
	// 친선경기용 쪽지는 한페이지에서 해결
	int num = Integer.parseInt(request.getParameter("num"));
	FMatchDTO dto = FMatchDAO.getInstance().getFMatch(num);
%>
	<title>쪽지 보내기</title>
	</head>
	<body>
		<form action="../FMatch/messagePro.jsp" method="post">
			<input type="hidden" name="function" value="write" />
			<input type="hidden" name="receiver" value="<%=request.getParameter("receiver")%>" />
			<input type="hidden" name="cond" value="sender" />
			<table>
				<tr>
					<td>받는 사람 : <%=request.getParameter("receiver")%></td>
				</tr>
				<tr>
					<td width="150px" height="170px"><textarea rows="10" cols="30" name="content">#<%=dto.getNum()%> #경기신청! <%=dto.getGamedate()%> 경기를 신청합니다.</textarea></td>
				</tr>
				<tr>
					<td><input type="submit" value="보내기" /><input type="button" value="취소" onclick="window.close()"></td>
				</tr>
			</table>
		</form>
	</body>
</html>