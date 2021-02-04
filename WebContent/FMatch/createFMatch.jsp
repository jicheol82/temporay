<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>친선경기 만들기</title>
</head>
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
	//로그인 처리부	-쿠키 사용하지 않음
	String id = (String)session.getAttribute("memId");
	// 위 아이디로 소속 동호회 가져옴
	MemberDAO mdao = MemberDAO.getInstance();
	String tname = mdao.findTname(id);
%>
<script>
	function findLocal(inputForm){
		var url = "findCity.jsp";
		open(url, "confirm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=300, height=200");
	}
</script>

<body>
	<jsp:include page="../main/main.jsp"/>
	<form action="../FMatch/createFMatchPro.jsp" method="get" name="inputForm">
		<input type="hidden" name="id" value="<%=id%>" />
		<input type="hidden" name="tname" value="<%=tname%>" />
		<table style="margin-left: auto; margin-right: auto">
			<tr>
				<td>경기일</td>
				<td><input type="date" name="gamedate"/></td>
				<td><input type="time" name="gametime"/></td>
			</tr>
			<tr>
				<td>경기장</td>
				<td colspan="2"><input type="text" name="homeground" placeholder="경기장입력"/></td>
			</tr>
			<tr>
				<td>유니폼색상</td>
				<td><input type="text" name="uniformcolor"/></td>
			</tr>
			<tr>
				<td>경기 가능 지역</td>
				<td colspan="2">
					<input type="text" placeholder="ex)충청북도 청주시" name="location" />
					<%--<input type="button" value="검색" onclick="findLocal(this.form)" />--%>
				</td>
			</tr>
			<tr>
				<td>내용입력</td>
				<td colspan="2"><textarea cols="40" rows="10" name="content"></textarea></td>
			</tr>
			<tr>
				<td colspan="3" align="center"><input type="submit" value="저장"/><input type="button" value="목록" onclick="window.location='../FMatch/findFMatch.jsp?event=football&category=fmatch'"/></td>
			</tr>
		</table>
	</form>
</body>
</html>