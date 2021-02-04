<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.football.league.F_Per_RecordDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_Per_RecordDAO"%>
<%@page import="woodley.main.member.MemberDAO"%>
<%@page import="woodley.football.league.F_Team_RecordDAO"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
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
<title>Create League Pro</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	F_League_CreateDTO dto = new F_League_CreateDTO(); // 리그 객체 생성
	String path = request.getRealPath("save");
	
	int max = 1024 * 1024 * 5;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	
	
	dto.setCreater(mr.getParameter("creater"));
	dto.setLeague_name(mr.getParameter("league_name"));
	dto.setPeriod(mr.getParameter("period1") + " ~ " + mr.getParameter("period2"));
	dto.setJointeam(Integer.parseInt(mr.getParameter("jointeam")));
	dto.setLocation(mr.getParameter("location"));
	dto.setBanner(mr.getFilesystemName("banner"));
	dto.setContent(mr.getParameter("content"));
	
	
	
	int club_num = Integer.parseInt(mr.getParameter("club_num"));
	F_League_CreateDAO dao = F_League_CreateDAO.getInstance();
	F_LeagueListDAO dao2 = F_LeagueListDAO.getInstance();
	dao.create_League(dto); // 리그생성
	int authority = 3; // 리그 생성자 권한주기
	int League_num = dao.getLeaguemaxnum();  // 리그번호부여
	dao2.addLeagueList(League_num, club_num, authority); // 리그리스트에 생성자 권한으로 저장
	F_Team_RecordDAO dao3 = F_Team_RecordDAO.getInstance(); // 팀레코드
	dao3.createRecord(League_num, club_num); // 리그생성하면 최초 생성자 팀기록에 올라감
	F_Per_RecordDAO perdao = F_Per_RecordDAO.getInstance();
	List<MemberDTO> memList = perdao.getUserInfo(club_num);
	
	for(int i =0; i < memList.size();i++) { // 리그 생성 동호회 동호회원 모두 기록에 입력
		MemberDTO memdto = memList.get(i);
		perdao.inputPer_Record(League_num, club_num, memdto.getName());
	}
	%>
	
	
	
	
	
	<script type="text/javascript">
		alert("리그 생성완료!");
		location="../League/findLeague.jsp?event=football&category=league";
	</script>	

	
	
	
	
	
	
	
	
	
	
	
	
	
<body>

</body>
</html>