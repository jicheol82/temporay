<%@page import="woodley.main.member.MemberDTO"%>
<%@page import="woodley.fooball.club.Club_ListDAO"%>
<%@page import="woodley.fooball.club.Club_CreateDTO"%>
<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>동호회 검색 및 리스트</title>
</head>
 <%
 	request.setCharacterEncoding("UTF-8");
 	
 	String id = (String)session.getAttribute("memId");
 	
 	//members에서 clubnum 뽑아오기 
 	Club_ListDAO ldao = Club_ListDAO.getInstance();
 	MemberDTO mdto = ldao.checkMember(id);
 	
 	// 한 페이지에 보여줄 게시글의 수 
 	int pageSize = 10;
 
 	// 게시글 정보 담기
 	String pageNum = request.getParameter("pageNum");
 	//동호회 클릭 해서 바로 들어왔을 때는 1page 로 설정 해줌
 	if(pageNum == null){
 		pageNum = "1";
 	}
 	// 현재 페이지에 보여줄 게시글의 첫 글과 마지막글 정보 세팅 
 	// 현재 페이지를 int 로 형변환
 	int currPage = Integer.parseInt(pageNum);
 	//해당 페이지의 첫 번째 글 구하기 
 	int startRow = (currPage-1)*pageSize+1;
 	//해당 페이지의 마지막 글 구하기 
 	int endRow = currPage*pageSize;
 	//화면에 뿌려줄 번호 첫 번째 번호만 구하고 나머지는 1씩 감소하면서 출력 해줌
 	int number =0;
 	//전체 글의 수 count 변수 미리 선언, 분기 처리 해주기 위해서 
 	int count=0;
 	//글을 반복해서 뿌려줄 수 있도록 list 미리 생성
 	List clubList = null;
 	//count 되는지 확인 
 	Club_CreateDAO dao = Club_CreateDAO.getInstance();
 	
 	//셀렉트한  지역,연령대,동호회 명 파라미터로 받기 
 	String age = request.getParameter("age");
 	String name = request.getParameter("name");
 	//조건을 선택했을 때와 처음에 그냥 동호회 검색을 들어왔을 때 나눔
 	//셋다 동시에 선택 되었을 때인데 하나 만 선택해도 구현해야할듯?
 	//틀린 조건 검색 했을 때 에러 뜨는 거 처리해야함 
 	if( age != null && name != null){
 		count = dao.getSearchClubCount(age,name);
 		if(count>0){
 			clubList = dao.getSearchClublist(startRow, endRow,age, name);
 		}
 	}else if(age == null && name == null){ 
 		//조건 없이 페이지 보여줄 때 (처음에 들어왔을 때)
 		count = dao.getClubCount();
 		if(count>0){
 			clubList = dao.getClublist(startRow, endRow);
 		}
 	}
 	number = count - (currPage-1)*pageSize;
 %>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
 <% if(count == 0){%>
 		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
 			<tr>
 				<td>등록된 동아리가 없습니다.</td>
 			</tr>
 			<tr>
 				<td>
 					<input type="button" value="동호회 생성" onclick="window.location='../club/createClub.jsp?category=club&pageNum=<%=pageNum%>'"/>
 				</td>
 			</tr>
 		</table>
 <%}else{%>
	
	<div align="center">
	<form action="../club/findClub.jsp" >
		<input type="hidden" name="category" value="club" />
		<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
		<tr>
			<td>
				<select name="age">
					<option value="10대" checked>10대</option>
					<option value="20대">20대</option>
					<option value="30대">30대</option>
					<option value="40대">40대</option>
					<option value="50대">50대</option>
					<option value="60대">60대</option>
				</select>
			</td>
			<td>
				<input type="text" name="name" placeholder="동호회명, 지역 검색"/>
				<input type="submit" value="검색" />
			</td>
		</tr>
		</table>
	</form>
	</div>
		<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
			<tr>	
				<th style="background-color: #fafafa; text-align: center;">No.</th>
				<th style="background-color: #fafafa; text-align: center;">동호회명</th>
				<th style="background-color: #fafafa; text-align: center;">팀원수</th>
				<th style="background-color: #fafafa; text-align: center;">지역</th>
				<th style="background-color: #fafafa; text-align: center;">연령대</th>
				<th style="background-color: #fafafa; text-align: center;">실력</th>
				<th style="background-color: #fafafa; text-align: center;">활동경기장</th>
				
			</tr>
		<%--동호회 목록 tr/td 반복해서 뿌려주기  --%>
			<%for(int i = 0; i < clubList.size(); i++){
				Club_CreateDTO club = (Club_CreateDTO)clubList.get(i);%>
				<tr align="center">
					<td><%=number--%></td>
					<td><a href="../club/introClub.jsp?category=club&pageNum=<%=pageNum %>&clubNum=<%=club.getClubNum()%>"><%=club.gettName() %></a></td>
					<td><%=club.gettNum() %></td>
					<td><%=club.gettLocal() %></td>
					<td><%=club.getAvrAge() %></td>
					<td><%=club.getSkill() %></td>
					<td><%=club.getGround() %></td>
				</tr>
			<% }//for문%>
		</table>
		<br/>
		<%--페이지 번호 부여 --%>
		<div align="center">
			<%
				//총 몇 페이지가 나오는지 계산, 계산이 딱 떨어지면 page 추가 안된다는 뜻 
				int pageCount = count/pageSize + (count%pageSize == 0 ? 0:1);
				// 몇 개의 페이지 씩 보여줄지 설정
				int pageBlock = 4;
				// 현재 위치한 페이지에서 페이지 뷰어 첫 번째 숫자가 무엇인지 찾기 
				// 앞자리 구하고 +1
				int startPage=(int)((currPage-1)/pageBlock) * pageBlock +1;
				// 현재 위치한 페이지에서 페이지 뷰어 마지막 숫자가 
				int endPage= startPage + pageBlock - 1;
				// 마지막 보여지는 페이지 뷰어에 페이지 수가 꽉차는게 아니라면
				// 마지막 페이지 번호가 페이지 수가 되게 만들어줌
				if(endPage>pageCount) endPage = pageCount;
				
				//  < 6 7 8 9 10
				//앞으로 가는 기호
				if(startPage>pageBlock){%>
					<a href="../club/findClub.jsp?category=club&pageNum=<%=startPage-pageBlock%>"> &lt;</a>
			 <%}
				//조건 검색 일 때 
				if(age !=null && name != null){
					for(int i = startPage; i <= endPage; i++){%>
						<a href="../club/findClub.jsp?category=club&pageNum=<%=i%>&age=<%=age%>&name=<%=name%>">&nbsp; <%=i%> &nbsp;</a>	
				<% }%>
			  <%}else{
				//조건 검색이 아닐때 
					for(int i = startPage; i <= endPage; i++){%>
						<a href="../club/findClub.jsp?category=club&pageNum=<%=i%>">&nbsp; <%=i%> &nbsp;</a>
				  <%}
			    }
				//뒤로 가는 기호 
				if(endPage < pageCount){%>
					 <a href="../club/findClub.jsp?category=club&pageNum=<%=startPage + pageBlock%>">&gt;</a>
				<%}
			%>
		</div>
			<%if(session.getAttribute("memId") != null && mdto.getClubnum()==0){ 
				//로그인 된 상태, 가입된 클럽이 없는 상태 members에 clubnum이 0일 때 %>
			<table align="center">
			<tr>
				<td >
					<input type="button" value="동호회 생성" onclick="window.location='../club/createClub.jsp?category=club&pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
			</table>
			<%} %>
</body>
<%} %>
</html>