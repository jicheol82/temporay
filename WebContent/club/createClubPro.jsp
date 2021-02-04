<%@page import="java.sql.Timestamp"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>createClubPro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="club" class="woodley.fooball.club.Club_CreateDTO"></jsp:useBean>
<jsp:useBean id="list" class="woodley.fooball.club.Club_ListDTO"></jsp:useBean>
<%

	String path = request.getRealPath("save");
	
	int max = 1024 * 1024 * 5;
	
	String enc = "UTF-8";
	
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	club.settName(mr.getParameter("tName"));
	club.settNum(Integer.parseInt(mr.getParameter("tNum")));
	club.setAvrAge(mr.getParameter("avrAge"));
	club.setClubEvent(mr.getParameter("clubEvent"));
	club.setSkill(mr.getParameter("skill"));
	club.settLocal(mr.getParameter("tLocal"));
	club.setGround(mr.getParameter("ground"));
	club.setEmblem(mr.getFilesystemName("emblem"));
	club.setBio(mr.getParameter("bio"));
	club.setHeadId(mr.getParameter("headId"));
	
	String id = (String)session.getAttribute("memId");
	
	//createClub 에서 입력한 정보를 club_create db로 넣는 메서드 
	Club_CreateDAO dao = Club_CreateDAO.getInstance();
	dao.insertClub(club);
	
	//club_create에 위에서  저장된  clubnum을 불러오는 메서드 
	int clubnum = dao.getClubNum(club);
	
	//list 부분
	// 회원 ID는 세션으로 받고 동호회 권한은 무조건 3(동호회장)이 들어가게
	list.setMemid(mr.getParameter("memId"));
	list.setClubNum(clubnum);
	list.setReg(new Timestamp(System.currentTimeMillis()));
	
	//list db에 정보 insert
	Club_ListDAO ldao = Club_ListDAO.getInstance();
	ldao.insertClubList(list,3);
	
	//멤버에 위에서 가입한 clubnum 넣어주기 
	ldao.insertMemclubnum(clubnum, id);
	
	response.sendRedirect("findClub.jsp?category=club");
	
%>
<body>

</body>
</html>