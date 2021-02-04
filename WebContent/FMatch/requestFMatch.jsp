<%@page import="woodley.main.alert.AlertDTO"%>
<%@page import="woodley.main.alert.AlertDAO"%>
<%@page import="woodley.football.fmatch.FMatchDTO"%>
<%@page import="woodley.football.fmatch.FMatchDAO"%>
<%@page import="woodley.main.member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	// 요청버튼을 누르면 ref는 리그/동호회 신청번호 (필수-내용 작성에는 필요 없으나 null이면 error날듯)
	// receiver는 신청자 (필수)
	String sender = (String)session.getAttribute("memId");
	String receiver = request.getParameter("receiver");
	int ref = Integer.parseInt(request.getParameter("ref"));
	String request_match = "match";	//리그참가는 "league", 동호회 신청은 "club"
	// 알람창에 띄울 메시지 작성용 내용 가져오기
	// 각 요청에 맞게 변경할 것
	String tname = MemberDAO.getInstance().findTname(sender);
	String gamedate = FMatchDAO.getInstance().getFMatch(ref).getGamedate();
	String content = "["+tname+"]에서 "+gamedate+" 경기에 매치 신청을 하였습니다.";
	
	AlertDTO dto = new AlertDTO();
	dto.setSender(sender);
	dto.setReceiver(receiver);
	dto.setRef(ref);
	dto.setRequest(request_match);
	dto.setContent(content);
	
	if(AlertDAO.getInstance().requestAlert(dto)){
%>
		<script>
			alert("매치 신청을 하였습니다."); //리그참가는 "league", 동호회 신청은 "club"
			window.location="../FMatch/findFMatch.jsp?event=football&category=fmatch";
		</script>
<%
	}
%>
<body>

</body>
</html>