<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ModifyLeaguePro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	F_League_CreateDTO dto = new F_League_CreateDTO(); // 리그 객체 생성
	String path = request.getRealPath("save");
	int league_num = Integer.parseInt(request.getParameter("league_num"));
	 
	
	int max = 1024 * 1024 * 5;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	
	
	dto.setLeague_name(mr.getParameter("league_name"));
	dto.setPeriod(mr.getParameter("period1") +" ~ " + mr.getParameter("period2"));
	dto.setJointeam(Integer.parseInt(mr.getParameter("jointeam")));
	dto.setLeagueing(Integer.parseInt(mr.getParameter("leagueing")));
	dto.setContent(mr.getParameter("content"));
	dto.setLocation(mr.getParameter("location"));
	
	
	if(mr.getFilesystemName("banner") == null) {
		dto.setBanner(mr.getParameter("exbanner"));
		
	}else {
		dto.setBanner(mr.getFilesystemName("banner"));
	}
		
	dto.setLeague_num(Integer.parseInt(mr.getParameter("League_num")));
	
	
	F_League_CreateDAO dao = F_League_CreateDAO.getInstance();
	dao.LeagueModify(dto);
%>
<script type="text/javascript">
	alert("리그 수정 완료!");
	location="../League/infoLeague.jsp?league_num=<%=league_num%>&category=league";
</script>
	
	
	
	
	
	
<body>

</body>
</html>