<%@page import="woodley.football.league.F_ResultDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>schedulePro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	
%>
<jsp:useBean id="dto" class="woodley.football.league.F_ResultDTO"></jsp:useBean>
<jsp:setProperty property="*" name="dto"/>
<%
	if(dto.getHomeclubnum() == dto.getAwayclubnum()) { %>
		<script>
			alert("같은팀끼리 대전할수 없습니다!");
			location="../League/scheduleForm.jsp?league_num=<%=dto.getLeague_num()%>&category=league";
		</script>
	<%}else {
		F_ResultDAO dao = F_ResultDAO.getInstance();
		dao.insertResult(dto);
		response.sendRedirect("../League/schedulemanage.jsp?league_num="+ dto.getLeague_num()+"&category=league");
	}
%>
<body>

</body>
</html>