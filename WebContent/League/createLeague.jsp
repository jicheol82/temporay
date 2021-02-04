<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create League</title>
</head>

	<meta http-equiv="Content-Type" content="text/html"; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
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
			
			if(date1 == "") {
				alert("시작날짜를 입력하세요");
				return false;
			}
			if(date2 == "") {
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
	String id = request.getParameter("creater");
	int club_num = Integer.parseInt(request.getParameter("club_num"));
	
%>

<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<div class="container">
		<form action="../League/createLeaguePro.jsp" method="post" enctype="multipart/form-data" onsubmit="return inputcheck()">
			<input type="hidden" name="creater" value="<%=id%>"/>
			<input type="hidden" name="club_num" value="<%=club_num%>"/>
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
				<tr>
					<th colspan="4"><h4>리그만들기</h4></th>
				</tr>
				</thead>
					<tr>
						<td style="width: 110px;"><h5>리그명</h5></td> 
						<td colspan="3"> <input class="form-control" id="league_name" type="text" name="league_name" ></td>
					</tr>
				<tr>
					<td style="width: 110px;"><h5>기간</h5></td> 
					<td style="width: 110px;"><input class="input-date" id="date1" type="date" name="period1" style="float:left;" max="2200-12-31" /><input class="input-date" id="date2" type="date" name="period2" max="2200-12-31" /></td>
				</tr>
					
				
				<tr>
					<td style="width: 110px;"><h5>참가팀수</h5></td> 
					<td colspan="3""><input class="jointeam-input" readonly id="jointeam" value="1" type="text" name="jointeam" style="float: left;" /><button class="btn btn-primary" onclick="minus()" type="button" style="float: right;">-</button ><button class="btn btn-primary" onclick="pluss()" type="button" style="float: right;">+</button></td>
				</tr>
					
				<tr>
					<td style="width: 110px;"><h5> 지역 </h5></td>
					<td><input class="form-control" type="text" name="location" /></td>
				</tr>
				<tr>
					<td style="width: 110px;"><h5> 리그배너 </h5></td>
					<td><input class="form-control" type="file" name="banner" /></td>
				</tr>
				<tr>
					<td style="width: 110px;"><h5> 리그소개 </h5></td>
					<td><textarea style="width:100%;" rows="5" name="content" ></textarea></td>
				</tr>
					
				<tr>
				</tr>
				<tr>
					<td colspan="4"><input type="submit" class="btn btn-primary" value="리그생성" /><button type="button" class="btn btn-primary" onclick="window.location='../League/findLeague.jsp?event=football&category=league'">뒤로</button></td>
				</tr>
			</table>
		</form>
			
	</div>
</body>
</html>
					
					
			
			
			
			