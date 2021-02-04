<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.fooball.club.Club_CreateDAO"%>
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
	request.setCharacterEncoding("UTF-8");	

	//findClub -> introClub 에서 타고온 pageNum
	String pageNum= request.getParameter("pageNum");
	//System.out.println("introClubModify pageNum= " + pageNum);
	
	//introClub 에서 clubNum 받아서 해당 클럽 정보 받아온다. 
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	//System.out.println("introClubModify clubNum= " + clubNum);
	
	Club_CreateDAO dao = Club_CreateDAO.getInstance();
	Club_CreateDTO introClub = dao.getClub(clubNum);
%>
<body>
<jsp:include page="../main/main.jsp"></jsp:include>
<form action="introClubModifyPro.jsp" method="post" enctype="multipart/form-data">
<input type="hidden" name="clubNum" value="<%=clubNum%>" />
<input type="hidden" name="pageNum" value="<%=pageNum%>" />
<input type="hidden" name="origEmblem" value="<%=introClub.getEmblem()%>"/>
<%--배너 사진 --%>
	<table align="center">
		<tr>
			<td align="center">
				<img src="/woodley/save/<%=introClub.getEmblem()%>" width="500" height="100" />
			</td>
			<td>
				사진 수정<input type="file" name="emblem"/>
			</td>
		</tr>
	</table>
	<br /><br />
	<%--동호회 정보 --%>
	<table align="center">
		<tr>
			<td>지역: </td>
			<td><input type="text" name="tLocal" value="<%=introClub.gettLocal()%>"/></td>
			<td>활동구장: </td>
			<td><input type="text" name="ground" value="<%=introClub.getGround()%>"/></td>
		</tr>
		<tr>
			<td>연령:<%=introClub.getAvrAge()%> </td>
			<td>
				<select name="avrAge">
					<option value="10대">10대</option>
					<option value="20대">20대</option>
					<option value="30대">30대</option>
					<option value="40대">40대</option>
					<option value="50대">50대</option>
					<option value="60대">60대</option>
				</select>
			</td>
			<td>실력:<%=introClub.getSkill()%> </td>
			<td>
					<input type="radio" name="skill" value="상" checked> 상
					<input type="radio" name="skill" value="중"> 중
					<input type="radio" name="skill" value="하"> 하
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">팀원 수 : </td>
			<td><input type="text" name="tNum" value="<%=introClub.gettNum()%>"/></td>
		</tr>
	</table>
	<br />
	<%--동호회 소개 --%>
	<table align="center">
		<tr>
			<td>팀 소개 </td>
			<td><textarea rows="20" cols="80" name="bio"><%=introClub.getBio() %></textarea></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" value="수정" />
				<input type="button" value="취소" onclick="window.location='introClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>'"/>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>