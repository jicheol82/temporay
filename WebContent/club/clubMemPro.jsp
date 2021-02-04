<%@page import="java.sql.Timestamp"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>clubMemPro</title>
<jsp:useBean id="list" class="woodley.fooball.club.Club_ListDTO"></jsp:useBean>
<%	
	//introClub 에서 신청 했을 때 club_mem_list에 추가하는 page 입니다!
	request.setCharacterEncoding("UTF-8");
	//introClub 에서 clubNum 받아옴 
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	String id = (String)session.getAttribute("memId");
	
	//list 세팅 해서 insert 메서드에 넣어준다. 
	list.setMemid(id);
	list.setClubNum(clubNum);
	list.setReg(new Timestamp(System.currentTimeMillis()));
	//신청한 사람을 club_mem_list에 authority 0 으로 넣는 메서드 
	//reg 를 추가해서 예비 회원 정렬하는데 쓴다 
	
	Club_ListDAO ldao = Club_ListDAO.getInstance();
	ldao.insertClubList(list,0);
	
	//clubNum을 members에 채워주는 메서드
	ldao.insertMemClub(clubNum, id);
	
	response.sendRedirect("../club/findClub.jsp?category=club");
%>
</head>
<body>

</body>
</html>