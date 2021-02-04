<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="woodley.football.league.F_Per_RecordDAO"%>
<%@page import="woodley.football.league.F_Per_RecordDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.main.member.MemberDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.football.league.F_LeagueListDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_LeagueListDAO"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>indivRank</title>
<%
	request.setCharacterEncoding("UTF-8");
	int League_num = Integer.parseInt(request.getParameter("league_num")); 
	
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null) {
		pageNum= "1";
	}
	int currPage = Integer.parseInt(pageNum);
	int pageSize = 5;
	int startRow = (currPage -1) * pageSize +1; 
	int endRow = currPage * pageSize;			
	int count = 0;
	
	F_LeagueListDAO listdao = F_LeagueListDAO.getInstance();
	int authority = 0; // 권한 0 이상인 리그참가중인 팀 목록불러오기
	List<Club_CreateDTO> allList = listdao.getallList(League_num, authority); // 리그 참가중인 팀들
	F_Per_RecordDAO perdao = F_Per_RecordDAO.getInstance();
	String allTeam = "";
	for(int i = 0; i < allList.size();i++) {
		Club_CreateDTO clubdto = allList.get(i);
		allTeam+= clubdto.getClubNum() + ",";
	}
	count = perdao.allCount(League_num);
	
	allTeam = allTeam.substring(0, allTeam.length()-1);
	List<F_Per_RecordDTO> allMemList = perdao.getPerRecord(League_num,startRow,endRow);
	for(int i =0; i < allMemList.size();i++) {
		
		String profile = perdao.getProfile(allMemList.get(i).getName(), allMemList.get(i).getClub_num());
		
		allMemList.get(i).setProfile(profile);
	}
		
		
		
	
	
		
%>
</head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
<script src="../js/bootstrap.js"></script>

<script type= "text/javascript">
		
		var page_num = 1; // 페이징 처리 위한 번호
		
		function pagenum(num) { // 페이징 a태그 클릭시 그값 페이지번호 서버로 전송
			page_num = num 
		}
		
		
		function itemChange() { // 셀렉바뀌엇을때 실행되는  함수
			var select = $('#select1').val(); // 현재 선택된 셀렉에 벨류값 가져와서 자바스크립트 select 변수에 담기
			
			
			
			
			
			$.ajax({ // 제이쿼리 이용한 ajax 통신시작
				type: 'POST', // post 방식
				url: '../League/indivRankPro.jsp', // ajax 통신할 페이지
				
				data: { club_num : select, page_num : page_num}, // club_num 이라는 이름으로 select 변수랑 page_num 변수
				success: function(result) { // 통신에 성공하면 result라는 변수에 json 형식으로 넘어온 데이터 담기
					const objs = JSON.parse(result); // json 형태의 데이터를 자바스크립트 객체화 시키는 함수
					const page = objs.pop(); // json 마지막에 들어온 객체는 페이징처리에 관한것이므로 따로빼줌
					
					var html = ""; // id값 ajaxbody를 가지고있는 div 태그에 들어갈 테이블 태그
					var inputpage = ""; // 페이징처리를 위한 a태그 나열하기위한 a태그 코드
					for(var i=0; i < objs.length;i++) { // objs 자바스크립트 객체로 html변수에 코드입력
						html += '<tr>';
						html += '<td>' + objs[i].ranked + '</td>';
						html += '<td>'+ objs[i].tname + '</td>';
						html += '<td>' + '<img width=\"63px\" height=\"88px\" src=\"/woodley/save/' +objs[i].profile+ '\"/>' + objs[i].name + '</td>';
						html += '<td>'+ objs[i].played + '</td>';
						html += '<td>'+ objs[i].goals + '</td>';
						html += '<td>'+ objs[i].assist + '</td>';
						html += '</tr>';
					}
					
					
					for(var i = page.startPage; i <= page.endPage; i++) { // 페이징처리 
						inputpage += '<a href=\"#\" onclick=\"pagenum('+i+'); itemChange() \" >' +'  '+i+ '  ' + '</a>';
					}
					
					if(page.endPage < page.pageCount) { // 다음a태그 나올수잇게하는 페이징처리
						var start = parseInt(page.startPage);
						var pageBlock = parseInt(page.pageBlock);
						inputpage += '<a href=\"#\" onclick=\"pagenum(' +(start + pageBlock) +'); itemChange()\" >' +'다음'+ '</a>';
					}
					
					
					$('#ajaxtbody').empty(); // ajaxbody 에 있는 내용 싹 지워버리고
					$('#ajaxtbody').append(html);	// 바뀐 데이터로 div태그 채워준다
					
					$('#ajaxpage').empty(); // 페이징처리도 다시 싹 날려주고
					$('#ajaxpage').append(inputpage); // 바뀐값으로 다시 넣어준다
					
				}
			})
		}
	</script>


<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<br/>
	<div align="center">
		<a href="../League/infoLeague.jsp?league_num=<%=League_num%>&category=league">리그정보</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/teamRank.jsp?league_num=<%=League_num%>&category=league">팀랭킹</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/indivRank.jsp?league_num=<%=League_num%>&category=league">개인기록</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/resultview.jsp?league_num=<%=League_num%>&category=league">경기일정/결과</a>
	</div>
	<select id="select1" onchange="pagenum(1); itemChange()">  <!-- onchange 가 되면 pagenum(), itemChange() 함수 실행 -->
		<option value="<%=League_num%>,<%=allTeam%>">전체선수</option> <!-- 전체선수이므로 리그번호와 전체선수목록 스트링에 -->
		<%for(int i=0; i < allList.size();i++) {					// 담아서 벨류값으로 서버로 송신	
			Club_CreateDTO listdto = allList.get(i);%> <!-- 밑에 옵션은 그 팀 선택됏을때 리그번호, 클럽번호, 팀이름 서버로 넘김 -->
			<option value="<%=League_num%>,<%=listdto.getClubNum()%>"><%=listdto.gettName() %></option>
		<%}%>
	</select>
	<br/><br/>
	<table class="table" style="text-align: center; border: 1px solid #dddddd;">
			<thead style="background-color: #90CAF9; text-align: center">
				<tr>
					<th>순위</th>
					<th>팀</th>
					<th>선수</th>
					<th>경기수</th>
					<th>득점</th>
					<th>도움</th>
				</tr>
			</thead>
			<tbody id="ajaxtbody">  <!-- 바뀐 데이터가 들어갈곳 -->
				<%for(int i=0; i < allMemList.size();i++) {
					F_Per_RecordDTO perdto = allMemList.get(i);%>
					<tr>
						<td><%=perdto.getRanked() %></td>
						
						<td><%=perdto.getTname() %></td> 
						<td width="300px">
							<img width="63px" height="88px" src="/woodley/save/<%=perdto.getProfile()%>" />
							<%=perdto.getName() %>
						</td>
						<td><%=perdto.getPlayed() %></td>
						<td><%=perdto.getGoals() %></td>
						<td><%=perdto.getAssist() %></td>
					</tr>
				<%}%>
			</tbody>	
		</table>
		<% 
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			int pageBlock = 5;	
			int startPage = (int)((currPage - 1)/pageBlock) * pageBlock + 1;
			int endPage = startPage + pageBlock - 1;
			
			if(endPage > pageCount) endPage = pageCount;%> 
			<div id="ajaxpage" align="center"><%  // 페이징 처리 다시 그릴수있게 id값 주기
				if(startPage > pageBlock) {%>
					<a href="../League/indivRank.jsp?league_num=<%=League_num%>&pageNum=<%=startPage - pageBlock %>&category=league"> 이전 </a>
		  	  <%}
		   		 for(int i = startPage; i <= endPage; i++) { %>
		    		<a href="../League/indivRank.jsp?league_num=<%=League_num%>&category=league&pageNum=<%= i%>&category=league"> &nbsp;<%= i %> &nbsp; </a>
		  	   <%}
			    if(endPage < pageCount) { %>
			    	<a href="../League/indivRank.jsp?league_num=<%=League_num%>&pageNum=<%= startPage+pageBlock %>&category=league"> 다음</a>
			  <%} %>	
	  	   </div>
		
		
		
	
</body>

</html>
	
	
	
	
	
	
	
	
	
	
	





	











