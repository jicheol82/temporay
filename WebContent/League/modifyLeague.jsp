<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyLeague</title>
</head>
	<meta http-equiv="Content-Type" content="text/html"; charset=UTF-8">
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
	<script type="text/javascript">
		function inputcheck() {
			
			var league_name = $('#league_name').val();
			var jointeam = $('#jointeam').val();
			var date1 = $('#date1').val();
			var date2 = $('#date2').val();
			
			if(league_name == "") {
				alert("리그명을 입력하세요");
				return false;
			}
			
			if(date1 == "" || date1 == null) {
				alert("시작날짜를 입력하세요");
				return false;
			}
			if(date2 == "" || date2 == null) {
				alert("종료날짜를 입력하세요");
				return false;
			}
			if(date1 > date2) {
				alert("시작일이 종료일보다 최신임");
				return false;
			}
			if(jointeam <= 1 ) {
				alert("참가팀은 2팀 이상입니다");
				return false;
			}
			
		}
		
		function minus() {
			var jointeam = $('#jointeam').val();
			jointeam--;
			$('#jointeam').val(jointeam);
		}
		function pluss() {
			var jointeam = $('#jointeam').val();
			jointeam++;
			$('#jointeam').val(jointeam);
		}
		
			
			
			
	</script>
<%
	request.setCharacterEncoding("UTF-8");
	int League_num = Integer.parseInt(request.getParameter("league_num"));
	
	
	F_League_CreateDAO dao = F_League_CreateDAO.getInstance();
	F_League_CreateDTO dto = dao.getInfoLeague(League_num);
	
	
	
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<h1 align="center">리그 관리</h1>
	<div align="center">
		<a href="../League/modifyLeague.jsp?league_num=<%=League_num%>&category=league">리그 정보 수정</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/schedulemanage.jsp?league_num=<%=League_num%>&category=league">경기일정/결과 관리</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a>개인기록 관리</a><%for(int i =0; i < 10;i++) {%> &nbsp; <% }%>
		<a href="../League/manageLeagueTeam.jsp?league_num=<%=League_num%>&category=league">리그참가팀관리</a>
	</div>
	<br/><br/>
	
	<div class="container">
		<form action="../League/modifyLeaguePro.jsp?league_num=<%=League_num %>&category=league" method="post" enctype="multipart/form-data" onsubmit="return inputcheck()">
			<input type="hidden" name="League_num" value="<%=League_num %>" />
			<input type="hidden" name="exbanner" value="<%=dto.getBanner()%>"/>
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="4"><h4>리그수정</h4></th>
					</tr>
				</thead>
				<tr>	
					<td style="width: 110px;"><h5>리그배너</h5></td>
					<td colspan="3"><img width="300px" align="center" src="/woodley/save/<%=dto.getBanner()%>"></td>
				</tr>
				<tr>
					<td colspan="4"><input class="form-control" type="file" name="banner" /></td>
				</tr>
					
				<tr>
					<td style="width: 110px;"><h5>진행상황</h5></td> 
					<td>모집중 <input type="radio" name="leagueing" value="0" <%if(dto.getLeagueing()== 0) out.print("checked");%>/></td>
					<td>진행중<input type="radio" name="leagueing" value="1" <%if(dto.getLeagueing()== 1) out.print("checked");%> /></td>
					<td>리그종료<input type="radio" name="leagueing" value="2" <%if(dto.getLeagueing()== 2) out.print("checked");%>></td>
				</tr>
				<tr>
					<td style="width: 110px;"><h5>리그명</h5></td> 
					<td colspan="3"> <input class="form-control" id="league_name" type="text" name="league_name" value="<%=dto.getLeague_name() %>" ></td>
				</tr>
				<tr>
					<td style="width: 110px;"><h5>기간</h5></td> 
					<td colspan="3" style="width: 110px;"><input class="input-date" id="date1" type="date" name="period1"  style="float:left;" max="2200-12-31" /><input class="input-date" id="date2" type="date" name="period2" max="2200-12-31"  /></td>
				</tr>
				<tr>
					<td style="width: 110px;"><h5>참가팀수</h5></td> 
					<td colspan="3"><input class="jointeam-input" readonly id="jointeam" value="<%=dto.getJointeam() %>" type="text" name="jointeam" style="float: left;" /><button class="btn btn-primary" onclick="minus()" type="button" style="float: right;">-</button ><button class="btn btn-primary" onclick="pluss()" type="button" style="float: right;">+</button></td>
				</tr>
				<tr>
					<td style="width: 110px;"><h5> 지역 </h5></td>
					<td colspan="3"><input class="form-control" type="text" name="location" value="<%=dto.getLocation() %>" /></td>
				</tr>
				<tr>
					<td style="width: 110px;"><h5> 리그소개 </h5></td>
					<td colspan="3"><textarea style="width:100%;" rows="5" name="content" ></textarea></td>
				</tr>
				<tr>
					<td colspan="4"><input type="submit" value="리그 수정"><button type="button" onclick="window.location='../League/infoLeague.jsp?league_num=<%=dto.getLeague_num()%>&category=league'">취소</button></td>
				</tr>
			</table>
		</form>
	</div>		
					
				
</body>
</html>
	
		
		
		