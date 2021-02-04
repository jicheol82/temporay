<%@page import="woodley.fooball.club.Club_ListDTO"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">

<title>Find League</title>
 
 
 
</head>
<%	
	// url 접근 방지
	String referer = request.getHeader("referer");
	if(referer == null){ 
%>
		<script>
			alert("비정상적인 접근입니다.");
			location="../main/main.jsp"
		</script>
<%	
	}
%>
<%
	String id = (String)session.getAttribute("memId");
	int pageSize = 8;
	String pageNum = request.getParameter("pageNum"); 
	Club_ListDAO clubdao = Club_ListDAO.getInstance(); 
	Club_ListDTO clubdto = clubdao.checkMaster(id); // 동호회장인지 체크
	
		
	if(pageNum == null) { 
		pageNum = "1";
	}
	int currPage = Integer.parseInt(pageNum); 
	int startRow = (currPage -1) * pageSize +1; 
	int endRow = currPage * pageSize;			
	int count = 0;					
	
	
	// 리그 리스트 가져오기
	F_League_CreateDAO dao = F_League_CreateDAO.getInstance();
	List<F_League_CreateDTO> leagueList = null;
	count = dao.LeagueCount(); // 총 글 몇개인지 확인
	// 검색 키워드
	
	String location = request.getParameter("location");
	if("".equals(location)) location = null; 
	String ing = request.getParameter("ing");
	String search = request.getParameter("search");
	if("".equals(search)) search = null;
	
	
	// 검색조건
	
	if(location == null && ing == null) { // 아무조건없을때 불러오기 //모든 글 불러오기
		// 처음 모든 글 불러오기
		leagueList = dao.getF_League_List(startRow, endRow);
		if(search!=null){
			// 메인에서 검색만 했을 때
			leagueList = dao.getF_League_List(search);
		}
	}else if(location != null && ing == "") { // 지역만 검색했을때
		System.out.println("지역 검색어");
		leagueList = dao.getF_League_List(location, search);	
	}else if(location == null && ing != "") { // 모집중 만 선택했을때
		System.out.println("진행 검색어");
		leagueList = dao.getF_League_List(Integer.parseInt(ing), search);
	}else if(location == null && ing == ""){
		System.out.println("3번째검색어");
		leagueList = dao.getF_League_List(search);
	}
	
	
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<br />
	
	
	<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<tr>
			<th style="background-color: #fafafa; text-align: center;">리그명</th>
			<th style="background-color: #fafafa; text-align: center;">지역</th>
			<th style="background-color: #fafafa; text-align: center;">참가팀수</th>
			<th style="background-color: #fafafa; text-align: center;">기간</th>
			<th style="background-color: #fafafa; text-align: center;">리그생성자</th>
			<th style="background-color: #fafafa; text-align: center;">리그진행현황</th>
		</tr>
		<% for(int i =0; i < leagueList.size(); i++) {
			F_League_CreateDTO dto = leagueList.get(i);%>
		<tr>
		<%if(session.getAttribute("memId") == null) { // 로그아웃 상태면 글클릭 못함%>
			<td>
				<%=dto.getLeague_name()%>
			</td>
		<%}else { // 로그인 상태면 글 클릭 가능%>
			<td>
				<a href="../League/infoLeague.jsp?category=league&league_num=<%=dto.getLeague_num()%>"><%=dto.getLeague_name()%></a>
			</td>
		<%}%>	
			<td><%=dto.getLocation() %></td>
			<td><%=dto.getJointeam() %></td>
			<td><%=dto.getPeriod() %></td>
			<td><%=dto.getCreater() %></td>
			<td><%
				  String state = "";
				  if(dto.getLeagueing() == 0) { state = "모집중"; }
				  else if(dto.getLeagueing() == 1) { state = "진행중"; }
				  else if(dto.getLeagueing() == 2) { state = "종료"; } 
				  out.print(state);%>
			</td> 
		</tr>
		<%} // 포문 끝%> 
	</table>
				  
	<% 
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			// 보여줄 페이지 번호의 개수 지정
			int pageBlock = 5;	// 5
			// 현재 위치한 페이지에서 페이지뷰어 첫번째 숫자가 무엇인지 찾기.
			int startPage = (int)((currPage - 1)/pageBlock) * pageBlock + 1;
			// 현재 위치한 페이지에서 페이지뷰어 마지막 숫자가 무엇인지 찾기
			int endPage = startPage + pageBlock - 1;
			// 마지막에 보여지는 페이지 뷰어에, 페이지 개수가 10개 미만일 경우
			// 마지막 페이지 번호가 (endPage)가 총 페이지 수가 되게 만들어줌.
			if(endPage > pageCount) endPage = pageCount;
	%> <div align="center"><% 
			// 앞으로 가는 기호(11~20 보고 있을때 1~10으로 이동하는 버튼)
			if(startPage > pageBlock) {%>
				<a href="../League/findLeague.jsp?pageNum=<%=startPage - pageBlock %>&category=league"> 이전 </a>
		  <%}
		    for(int i = startPage; i <= endPage; i++) { %>
		    	<a href="../League/findLeague.jsp?category=league&pageNum=<%= i%>&category=league"> &nbsp;<%= i %> &nbsp; </a>
		  <%}
		    if(endPage < pageCount) { %>
		    	<a href="../League/findLeague.jsp?pageNum=<%= startPage+pageBlock %>&category=league"> 다음</a>
		  <%} %>	
		  </div>
	
	<%if(clubdto == null) { // 결과값 없으면 아무것도 안보여주기 %>
		
    <%}else { // 결과값 있으면 보여주느대~ 
    	if(clubdto.getAuthority() == 3) { // 동호회장만 리그 생성 버튼 보이게한다~%>
		<div align="center">
			<form action="../League/createLeague.jsp?category=league" method="post" name="createLeague" >
				<input type="hidden" name="creater" value="<%=clubdto.getMemid()%>" />
				<input type="hidden" name="club_num" value="<%=clubdto.getClubNum()%>" />
				<input type="submit" class="btn btn-primary" value="리그생성" name="createLeague">
			</form>	
		</div>
	  <% } // else문 안의 if 문 끝
	 } // else 문 끝%>
	 <div align="center">
		<form action="../League/findLeague.jsp?" method="get" name="inputForm">
			<input type="hidden" name="pageNum" value="<%=pageNum%>" />
			<input type="hidden" name="category" value="league" />
			지역 : <input type="text" name="location" />
			상태 		<select name="ing">
						<option value="">선택안함</option>
						<option value="0">모집중</option>
						<option value="1">진행중</option>
						<option value="2">종료</option>
					</select>
			리그이름 : <input type="text" name="search" />
			<input type="submit" value="검색"/>
		</form>
	</div>
		
	
</body>
</html>
		
		