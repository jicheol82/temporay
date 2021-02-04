<%@page import="woodley.football.league.F_League_CreateDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.football.league.F_League_CreateDAO"%>
<%@page import="sun.misc.Perf.GetPerfAction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script> 
	<script src="../js/bootstrap.js"></script>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/main.css">

<%
	request.setCharacterEncoding("UTF-8");
	
	String event = request.getParameter("event");
	if(event == null) {
		event = "football";
	}
	
	String category = request.getParameter("category");
	if(category == null) {
		category = "main";
	}
	
	
	String id = (String)session.getAttribute("memId");
	F_League_CreateDAO dao = F_League_CreateDAO.getInstance();
	List<F_League_CreateDTO> mainList = dao.mainviewList();
	
	  
%>

</head>
<body>
	<style type="text/css" >
		.jumbotron {
			background-image: url( "../images/main.png" );
			background-size: cover;
			text-shadow; black 0.2em 0.2em 0.2em;
			color: white;
		}
	</style>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapsed" 
				data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="sr-only"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="../main/main.jsp" >우리들만의리그</a>
			</div>
		
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
							aria-haspopup="true" aria-expanded="false">축구<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="../club/findClub.jsp?event=<%=event%>&category=club">동호회</a></li>
							<li><a href="../League/findLeague.jsp?event=<%=event%>&category=league">리그</a></li>
							<li><a href="../FMatch/findFMatch.jsp?event=<%=event%>&category=fmatch">친선경기</a></li>
							<li><a href="../board/noticeBoard.jsp?evnet=<%=event%>&category=comboard">커뮤니티</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
							aria-haspopup="true" aria-expanded="false">농구<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="../main/updatePage.jsp?category=club">동호회</a></li>
							<li><a href="../main/updatePage.jsp?category=club">리그</a></li>
							<li><a href="../main/updatePage.jsp?category=club">친선경기</a></li>
							<li><a href="../main/updatePage.jsp?category=club">커뮤니티</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
							aria-haspopup="true" aria-expanded="false">탁구<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="../main/updatePage.jsp?category=club">동호회</a></li>
							<li><a href="../main/updatePage.jsp?category=club">리그</a></li>
							<li><a href="../main/updatePage.jsp?category=club">친선경기</a></li>
							<li><a href="../main/updatePage.jsp?category=club">커뮤니티</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
							aria-haspopup="true" aria-expanded="false">배드민턴<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="../main/updatePage.jsp?category=club">동호회</a></li>
							<li><a href="../main/updatePage.jsp?category=club">리그</a></li>
							<li><a href="../main/updatePage.jsp?category=club">친선경기</a></li>
							<li><a href="../main/updatePage.jsp?category=club">커뮤니티</a></li>
						</ul>
					</li>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
							aria-haspopup="true" aria-expanded="false">스타크래프트<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="../main/updatePage.jsp?category=club">동호회</a></li>
							<li><a href="../main/updatePage.jsp?category=club">리그</a></li>
							<li><a href="../main/updatePage.jsp?category=club">친선경기</a></li>
							<li><a href="../main/updatePage.jsp?category=club">커뮤니티</a></li>
						</ul>
					</li>
				</ul>
				<form action="../League/findLeague.jsp" method="get" class="navbar-form navbar-left">
					<input type="hidden" name="event" value="football"/>
					<input type="hidden" name="category" value="league"/>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="리그명검색" name="search"/>
					</div>
					<button type="submit" class="btn btn-default">리그검색</button>
				</form>
				<ul class="nav navbar-nav navbar-right">
					<%if(session.getAttribute("memId") == null) { %>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
								aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="../main/loginForm.jsp?category=login">로그인</a></li>
								<li><a href="../main/signUp.jsp?category=login">회원가입</a></li>
							</ul>
						</li>
				   <%}else {%>
				   		<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
							aria-haspopup="true" aria-expanded="false"><%=id%>님 환영합니다<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="../main/myInfo.jsp?category=myInfo">마이페이지</a></li>
							<li><a href="../main/alert.jsp?category=alert">알림 및 쪽지</a></li>
							<li><a href="../main/logout.jsp">로그아웃</a></li>
						</ul>
					</li>
				   <%}%>
				</ul>
			</div>
		</div>
	</nav>
		<%if(category.equals("main")) { %>
		<div class="container">
			<div class="jumbotron">
				<h1 class="text-center"> 우들리의 오신것을 환영합니다.</h1>
				<p class="text-center"> 우들리는 동호회 기능 및 리그 기능을 가진 사이트입니다. 다양한 리그를 생성하고 참여해보세요!</p>
			</div>
		</div>
	
	<div class="container">
			<br/>
			<div class="row">
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(0).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(0).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(0).getLeague_name() %></h2> 
					</button>
				</div>
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(1).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(1).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(1).getLeague_name() %></h2> 
					</button>
				</div>
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(2).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(2).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(2).getLeague_name() %></h2> 
					</button>
				</div>
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(3).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(3).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(3).getLeague_name() %></h2> 
					</button>
				</div>
			</div>
			<br/>
			<div class="row">
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(4).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(4).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(4).getLeague_name() %></h2> 
					</button>
				</div>
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(5).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(5).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(5).getLeague_name() %></h2> 
					</button>
				</div>
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(6).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(6).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(6).getLeague_name() %></h2> 
					</button>
				</div>
				<div class="col-sm-3" style="text-align: center;">
					<button style="background-color: white; border: 0;" onclick="window.location='../League/infoLeague.jsp?category=league&league_num=<%=mainList.get(7).getLeague_num()%>'">
						<img style="width: 100%; height: 100%;" src="/woodley/save/<%=mainList.get(7).getBanner()%>"/>
						<br/>
						<h2 style="background-color: #90CAF9; margin-top: 0; "><%=mainList.get(7).getLeague_name() %></h2> 
					</button>
				</div>
			</div>
		</div>
			 
			 
			
			 
	
	<footer style="background-color: #90CAF9; color: #000000; border-color: #000000;">
		<div class="container">
			<br/>
			<div class="row">
				<div class="col-sm-2" style="text-align: center;"><h5>Copyright &copy; 2021</h5><h5>WoodleyTeam</h5></div>
				<div class="col-sm-4"><h4 style="text-align: center;">팀원 소개</h4>
					<div class="list-group">
						<p style="text-align: center;" class="list-group-item">오훈영(Hunyoung Oh)</p>
						<p style="text-align: center;" class="list-group-item">최지철(Jicheol Choi)</p>
						<p style="text-align: center;" class="list-group-item">정보름(Boreum Jeong)</p>
						<p style="text-align: center;" class="list-group-item">조윤호(Yunho Cho)</p>
						<p style="text-align: center;" class="list-group-item">이승헌(Seunghun Lee)</p>
						
					</div>
				</div>
			</div>
		</div>
	</footer>
  <%}%>
	
			
			
</body>
</html>
	
	
	
							
			
	
	
	
	
	
	
				
	
	
			
	
	

	
	


