<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.fooball.club.Club_ListDTO"%>
<%@page import="woodley.main.bcity.B_CityDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="woodley.main.bcity.B_CityDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.football.fmatch.FMatchDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.fmatch.FMatchDAO"%>
<%@page import="java.time.DayOfWeek"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>친선 경기 검색</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<%
	request.setCharacterEncoding("utf-8");
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
	//인스턴스들 생성
	FMatchDAO dao = FMatchDAO.getInstance();	// 친선경기 목록용
	B_CityDAO cityDao = B_CityDAO.getInstance();	// 지방목록 가져오기위한 인스턴스
	List list;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	// 필드생성
	String selectDate = request.getParameter("selectDate");
	String fromDate = request.getParameter("fromDate");
	String toDate = request.getParameter("toDate");
	String location = request.getParameter("location");
	
	if(location==null || (fromDate=="" && selectDate=="" && location=="")){
		//처음 들어왔을 때 또는 아무 기간도 선택 안했을 때-이달의 모든 지역의 경기를 리스트업한다. 
		LocalDate date = LocalDate.now();
		//System.out.println(sdf.format(date.toString()));
		int year = date.getYear();
		int month = date.getMonthValue();
		fromDate = year+"-"+(month<10?"0"+month:month)+"-1";
		toDate = year+"-"+((month+1)<10?"0"+(month+1):(month+1))+"-"+date.lengthOfMonth();
		list = dao.findFMatch(fromDate, toDate, "");
	}else if(selectDate!="" && fromDate==""){
		//날짜가 선택됐을때
		list = dao.findFMatch(selectDate, location);
	}else{
		// 기간이 선택됐을때
		list = dao.findFMatch(fromDate, toDate, location);
	}
%>
</head>
<body >
<jsp:include page="../main/main.jsp"/>
	<form action="../FMatch/findFMatch.jsp" method="get">
		<input type="hidden" name="event" value="football"/>
		<input type="hidden" name="category" value="fmatch"/>
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
			<tr>
				<th style="background-color: #fafafa; text-align: center;" rowspan="2"><input type="date" name="selecthate"></th>
				<th style="background-color: #fafafa; text-align: center;">시합 지역</th>
				<th style="background-color: #fafafa; text-align: center;">날짜설정</th>
			</tr>
			<tr>
				<td>
					<select name="location">
						<option value="">전체지역</option>
<%
						List cityList = cityDao.callBcity();
						for(int i=0; i<cityList.size(); i++){
							B_CityDTO dto = (B_CityDTO)cityList.get(i);
%>
							<option value="<%=(dto.getCity_name()).substring(0, 2)%>"><%=dto.getCity_name()%></option>
<%
						}
%>
					</select>
				</td>
				<td>
					<input type="month" name="fromDate"/>~
					<input type="month" name="toDate"/>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<input type="submit" value="경기검색"/>
					<%if(isMaster){ %><input type="button" value="경기등록" onclick="window.location='../FMatch/createFMatch.jsp?event=football&category=fmatch'"/><%} %>
				</td>
			</tr>
		</table>
	</form>
	<br />
	<table id="fmatchList" class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<tr>
			<th style="background-color: #fafafa; text-align: center;"></th>
			<th style="background-color: #fafafa; text-align: center;">동호회 이름</th>
			<th style="background-color: #fafafa; text-align: center;">작성자</th>
			<th style="background-color: #fafafa; text-align: center;">경기일시</th>
			<th style="background-color: #fafafa; text-align: center;">지역</th>
			<th style="background-color: #fafafa; text-align: center;">경기장</th>
			<th style="background-color: #fafafa; text-align: center;">한마디</th>
			<th style="background-color: #fafafa; text-align: center;">등록일</th>
			<th style="background-color: #fafafa; text-align: center;">상태</th>
		</tr>
<%
		
		for(int i=0;i<list.size();i++){
			FMatchDTO dto = (FMatchDTO)list.get(i);
			// 팀명으로 emblem가져오기
			String emblem = dao.findEmblem(dto.getTname());
%>
		<tr>
			<td><img src="../save/<%=emblem%>" width=10 /></td>
			<td><%=dto.getTname()%></td>
			<td><%=dto.getId()%></td> 
			<td><%=dto.getGamedate()%> <%=dto.getGametime()%></td>
			<td><%=dto.getLocation()%></td>
			<td><%=dto.getHomeground()%></td>
			<td><%=dto.getContent()%></td>
			<td><%=sdf.format(dto.getReg())%></td>
			<td>
				<%if(!dto.getId().equals(id) && isMaster && dto.getState()==0){ %><button type="button" onclick="window.location='../FMatch/requestFMatch.jsp?ref=<%=dto.getNum()%>&receiver=<%=dto.getId()%>'">대결신청</button><%}else if(dto.getState()==1){%><button type="button" disabled>매치종료</button><%}%>
				<%if(dto.getId().equals(id) || admin){%><br/><button type="button" onclick="window.location='../FMatch/deleteFMatch.jsp?num=<%=dto.getNum()%>'">삭제</button><%}%>
				<%if(dto.getId().equals(id)){%><button type="button" onclick="window.location='../FMatch/modifyFMatchForm.jsp?event=football&category=comboard&num=<%=dto.getNum()%>'">수정</button><%}%>
			</td>
		</tr>
<%
		}
%>
	</table>
</body>
</html>