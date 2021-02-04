<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.fooball.club.Club_ListDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리그 검색</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<script>
	function check2(){
		var inputs = document.searchForm;
		//console.log(inputs.)
		if(inputs.location.value=="" && inputs.search.value=="" && inputs.ing.value=="-1"){
			alert("적어도 하나의 조건은 입력해 주세요");
			return false;
		}
		if(inputs.oldIng.value!=inputs.ing.value){
			document.getElementById('pageNum').value="1";
		}
	}
</script>
</head>
<%
	//로그인 처리부	-쿠키 사용하지 않음
	String id = (String)session.getAttribute("memId");
	boolean loggedin = false;	// login 상태 확인
	boolean admin = false;	// 관리자 파악
	boolean isMaster = false; // 동호회장 확인
	if(id!=null){
		loggedin = true;
		if(id.equals("admin")) {admin=true;}
		Club_ListDTO dto = Club_ListDAO.getInstance().checkMaster(id);
		if(dto!=null?dto.getAuthority()==3:false){ isMaster = true;}
	}
	
	//글불러올 인스턴스들 생성
	F_League_CreateDAO dao = F_League_CreateDAO.getInstance();
	F_League_CreateDTO dto = new F_League_CreateDTO();
	List leagueList = null;
	
	//검색관련 처리
	System.out.println("location "+ request.getParameter("location"));
	System.out.println("location is null? "+ request.getParameter("location")==null);
	System.out.println("ing "+ request.getParameter("ing"));
	System.out.println("ing is null? "+ request.getParameter("ing")==null);
	System.out.println("search "+ request.getParameter("search"));
	System.out.println("search is null? "+ request.getParameter("search")==null);
	/* String location = "null".equals(request.getParameter("location")) ? "location" :request.getParameter("location");
	String ing = "null".equals(request.getParameter("ing")) ? null:request.getParameter("ing");
	String search = "null".equals(request.getParameter("search")) ? null:request.getParameter("search"); */
	String location = request.getParameter("location");
	String ing = request.getParameter("ing");
	String search = request.getParameter("search");
	System.out.println("location "+ location);
	System.out.println("location is null? "+ location==null);
	System.out.println("ing "+ ing);
	System.out.println("ing is null? "+ ing==null);
	System.out.println("search "+ search);
	System.out.println("search is null? "+ search==null);
	
	//페이지 관련 설정
	int numOfLeague = 10;	// 한페이지에 보여줄 게시글의 수
	//int numOfLeagues = (location==null && ing==null && search==null)? dao.LeagueCount(): dao.LeagueCount(location, Integer.parseInt(ing), search);	// notice_board에 있는 모든(검색) 게시글의 수
	int numOfLeagues = dao.LeagueCount(location, Integer.parseInt(ing), search);	// notice_board에 있는 모든(검색) 게시글의 수
	int numOfPage = 3;	// 한줄에 보여줄 페이지의 갯수
	int pageNum;	// 현재 페이지 번호
	int numOfAllPages = (numOfLeagues%numOfLeague==0) ? (numOfLeagues/numOfLeague) : (numOfLeagues/numOfLeague)+1;	// 전체게시글이 표시될 페이지의 갯수
	if(numOfAllPages==0) numOfAllPages=1;	//게시글이 하나도 없는 경우만 예외적으로 endpage를 정의
	if(request.getParameter("pageNum")==null){	// 처음 noticeBoard.jsp가 호출됐을때
		pageNum = 1;
	}else{	// 다른 페이지에서 호출되어 넘어왔을때
		pageNum = Integer.parseInt(request.getParameter("pageNum"));
	}
	int startRow = (pageNum - 1) * numOfLeague + 1;	// 현재 페이지에서 시작하는 첫번째 글의 번호
	int endRow = startRow + numOfLeague - 1;		// 현재 페이지에서 끝나는 마지막 글의 번호
	
	int startPage = (((pageNum-1)/numOfPage) * numOfPage) + 1;	// 현재 페이지에서 시작하는 첫번째 페이지의 번호
	int endPage = (startPage + numOfPage - 1) >= numOfAllPages ? numOfAllPages : (startPage + numOfPage - 1);	// 현재 페이지에서 끝나는 마지막 페이지의 번호
	int leagueNum = numOfLeagues - ((pageNum - 1) * numOfLeague);	// 목록에 표시될 글의 번호
	
	
%>
<body>
	<jsp:include page="../main/main.jsp"/>
	<br />
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
			<tr>
				<th style="background-color: #fafafa; text-align: center;">번호</th>
				<th style="background-color: #fafafa; text-align: center;">리그명</th>
				<th style="background-color: #fafafa; text-align: center;">지역</th>
				<th style="background-color: #fafafa; text-align: center;">참가팀수</th>
				<th style="background-color: #fafafa; text-align: center;">기간</th>
				<th style="background-color: #fafafa; text-align: center;">리그생성자</th>
				<th style="background-color: #fafafa; text-align: center;">리그진행현황</th>
			</tr>
<%
			//for문을 이용하여 notice_board에서 글 가져오기
			leagueList = (location==null && ing==null && search==null)?dao.getF_League_List(startRow, endRow):dao.getF_League_List(startRow, endRow, location, Integer.parseInt(ing), search);	// 현재페이지에 표시할 글 가져오기
			for(int i=0;i<leagueList.size();i++){
				dto = (F_League_CreateDTO)leagueList.get(i);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>	
				<tr>
					<td><%=leagueNum--%></td>
					<td>
<%				
				if(loggedin){ 
%>
						<a href="../League/infoLeague.jsp?category=league&league_num=<%=dto.getLeague_num()%>&pageNum=<%=pageNum%>"><%=dto.getLeague_name()%></a>
<%
				}else{
%>
						<%=dto.getLeague_name()%>
<%
				}
%>
					</td>
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
<%		
			}
%>
		</table>
	<div align="center">
<%
		//if 문으로 이전 페이지 넘어가게 처리
		if(startPage!=1){
%>
			<a href="../League/findLeague.jsp?event=football&category=league&pageNum=<%=1%>&location=<%=location%>&ing=<%=ing%>&search=<%=search%>">≪&nbsp;</a>
			<a href="../League/findLeague.jsp?event=football&category=league&pageNum=<%=startPage-numOfPage<1?1:startPage-numOfPage%>&location=<%=location%>&ing=<%=ing%>&search=<%=search%>">＜&nbsp;</a>
<%
		}
		// 페이지 번호 처리
		for(int i=startPage; i<=endPage; i++){
%>		
			<a href="../League/findLeague.jsp?event=football&category=league&pageNum=<%=i%>&location=<%=location%>&ing=<%=ing%>&search=<%=search%>"><%=i%>&nbsp;</a>	
<%		
		}
		//if 문으로 이후 페이지 넘어가게 처리
		if(endPage!=numOfAllPages){
%>
			<a href="../League/findLeague.jsp?event=football&category=league&pageNum=<%=endPage+1>numOfAllPages?numOfAllPages:endPage+1%>&location=<%=location%>&ing=<%=ing%>&search=<%=search%>">＞&nbsp;</a>
			<a href="../League/findLeague.jsp?event=football&category=league&pageNum=<%=numOfAllPages%>&location=<%=location%>&ing=<%=ing%>&search=<%=search%>">≫</a>
<%
		}
%>
		<%if(!isMaster) { // 결과값 없으면 아무것도 안보여주기 %>
		
    <%}else { // 결과값 있으면 보여주느대~ %>
		<div align="center">
			<form action="../League/createLeague.jsp?category=league" method="post" name="createLeague" >
				<input type="hidden" name="creater" value="<%=id%>" />
				<input type="hidden" name="club_num" value="<%=Club_ListDAO.getInstance().checkMaster(id).getClubNum()%>" />
				<input type="submit" class="btn btn-primary" value="리그생성" name="createLeague">
			</form>	
		</div>
	  <% 
	 } // else 문 끝%>
 		<div align="center">
		<form action="../League/findLeague.jsp?" method="get" name="searchForm" onsubmit="return check2()">
			<input type="hidden" id="pageNum" name="pageNum" value="<%=pageNum%>" />
			<input type="hidden" name="category" value="league" />
			<input type="hidden" name="oldIng" value="<%=ing%>"/>
			지역 : <input type="text" name="location" />
			상태 		<select name="ing">
						<option value="-1">선택안함</option>
						<option value="0">모집중</option>
						<option value="1">진행중</option>
						<option value="2">종료</option>
					</select>
			리그이름 : <input type="text" name="search" />
			<input type="submit" value="검색"/>
		</form>
		</div>
	</div>
</body>
</html>