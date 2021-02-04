<%@page import="woodley.football.fmatch.FMatchDTO"%>
<%@page import="woodley.football.fmatch.FMatchDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	int num = Integer.parseInt(request.getParameter("num"));
	FMatchDTO dto = FMatchDAO.getInstance().getFMatch(num);
%>
	<title>수정</title>
</head>
<body>
	<jsp:include page="../main/main.jsp"/>
	<form action="../FMatch/modifyFMatchPro.jsp" method="get" name="inputForm">
		<input type="hidden" name="num" value="<%=dto.getNum()%>" />
		<input type="hidden" name="id" value="<%=dto.getId()%>" />
		<table style="margin-left: auto; margin-right: auto">
			<tr>
				<td>경기일</td>
				<td><input type="date" name="gamedate" value="<%=dto.getGamedate()%>"/></td>
				<td><input type="time" name="gametime" value="<%=dto.getGametime()%>"/></td>
			</tr>
			<tr>
				<td>동호회이름</td>
				<td colspan="2"><input type="text" name="tname" value="<%=dto.getTname()%>"/></td>
			</tr>
			<tr>
				<td>경기장</td>
				<td colspan="2"><input type="text" name="homeground" value="<%=dto.getHomeground()%>"/></td>
			</tr>
			<tr>
				<td>유니폼색상</td>
				<td><input type="text" name="uniformcolor" value="<%=dto.getUniformcolor()%>"/></td>
			</tr>
			<tr>
				<td>경기 가능 지역</td>
				<td colspan="2">
					<input type="text" value="<%=dto.getLocation() %>" name="location" />
					<%--<input type="button" value="검색" onclick="findLocal(this.form)" />--%>
				</td>
			</tr>
			<tr>
				<td>내용입력</td>
				<td colspan="2"><textarea cols="40" rows="10" name="content"><%=dto.getContent() %></textarea></td>
			</tr>
			<tr>
				<td colspan="3" align="center"><input type="submit" value="수정"/><input type="button" value="취소" onclick="window.location='../FMatch/findFMatch.jsp?event=football&category=fmatch'"/></td>
			</tr>
		</table>
	</form>
</body>
</html>