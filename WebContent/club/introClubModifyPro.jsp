<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modify Pro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
%>	
<jsp:useBean id="club" class="woodley.fooball.club.Club_CreateDTO"></jsp:useBean>
<%

	String path = request.getRealPath("save");
	
	int max = 1024 * 1024 * 5;
	
	String enc = "UTF-8";
	
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	int clubNum = Integer.parseInt(mr.getParameter("clubNum"));
	String pageNum = mr.getParameter("pageNum");
	//System.out.println("Pro pageNum = " + pageNum);
	club.setClubNum(clubNum);
	//사진을 수정 안했을 때 수정form 페이지에서 hidden으로  origEmblem parameter를  받아서 처리 
	if(mr.getFilesystemName("emblem")==null){
		club.setEmblem(mr.getParameter("origEmblem"));
	}else{
		club.setEmblem(mr.getFilesystemName("emblem"));
	}
	club.settLocal(mr.getParameter("tLocal"));
	club.setGround(mr.getParameter("ground"));
	club.setAvrAge(mr.getParameter("avrAge"));
	club.setSkill(mr.getParameter("skill"));
	club.settNum(Integer.parseInt((mr.getParameter("tNum"))));
	club.setBio(mr.getParameter("bio"));
	
	Club_CreateDAO dao = Club_CreateDAO.getInstance();
	dao.updateIntroClub(club);
	
	response.sendRedirect("introClub.jsp?category=club&pageNum="+pageNum+"&clubNum=" +clubNum);
%>
<body>

</body>
</html>