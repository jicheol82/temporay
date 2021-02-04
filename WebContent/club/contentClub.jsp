<%@page import="woodley.fooball.club.Club_ReplyDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.fooball.club.Club_ReplyDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.fooball.club.Club_BoardDTO"%>
<%@page import="woodley.fooball.club.Club_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>글 내용</title>
</head>
<%	
	//introClub-boardClub 에서 넘어오는 pageNum 받아줌 
	String pageNum = request.getParameter("pageNum");
	//boardClub에서 넘어오는 pageNum 받아줌
	String bpageNum = request.getParameter("bpageNum");
	
	//System.out.println("content bpageNum = " +bpageNum);
	//System.out.println("content pageNum = " +pageNum);
	
	//몇 번 게시글의 글인지 boardnum 받는다 
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	System.out.println("content boardnum =" + boardnum);
	
	//글 클릭 하고 들어 갔을 때도 clubNum 붙여주려고 
	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	//System.out.println("content clubNum =" + clubNum);
	//시간 포맷 설정
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

	Club_BoardDAO dao = Club_BoardDAO.getInstance();
	//게시판 번호로 게시글 내용 불러오기 
	Club_BoardDTO article = dao.getArticle(boardnum);
	
	String id = (String)session.getAttribute("memId");
	//댓글 관련
	//답글 가져오기 
	Club_ReplyDAO rdao = Club_ReplyDAO.getInstance();
	Club_ReplyDTO rdto = new Club_ReplyDTO();
	List replyList =  rdao.getReply(boardnum);
	
	//System.out.println("contentclub id =" + id);
	//System.out.println("contentclub writer =" + article.getWriter());
%>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<div align="center">
	<h3 align="center"><a href="introClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 소개</a> | <a href="boardClub.jsp?category=club&bpageNum=<%=bpageNum%>&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 게시판</a></h3>
	<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
		<tr>
			<td colspan="2">제목:<%=article.getTitle() %>&nbsp;&nbsp;&nbsp;<%=sdf.format(article.getReg())%></td>
		</tr>
		<tr>
			<td colspan="2">조회수: <%=article.getReadcount()%> &nbsp;&nbsp;&nbsp;<a href="#class">댓글</a></td>
		</tr>
		<tr>
			<td>본문</td>
			<td><textarea rows="20" cols="50" readonly><%=article.getContent()%></textarea></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
			<%if(article.getPhoto() == null || article.getPhoto().equals("null")){ //처음에 안올렸을 때 %>
				<img src="img/default_img.jpg" width="100" height="100" />
			<%}else{ %>	
				<img src="/woodley/save/<%=article.getPhoto()%>" width="100" height="100" />
				<%} %>
			</td>
		</tr>
		<%--세션 memid 랑 해당 글 writer 가 일치할 떄 버튼 나오도록 수정  --%>
		
		<%if(id.equals(article.getWriter())) {%>
		<tr >
			<td colspan ="2" align="center">
			<button onclick="window.location='contentClubModifyForm.jsp?category=club&boardnum=<%=boardnum%>&clubNum=<%=clubNum%>&pageNum=<%=pageNum%>&bpageNum=<%=bpageNum%>'">수정</button>	
			<button onclick="window.location='contentClubDeleteForm.jsp?category=club&boardnum=<%=boardnum%>&clubNum=<%=clubNum%>&pageNum=<%=pageNum%>&bpageNum=<%=bpageNum%>'">삭제</button>	
			</td>
		</tr>
		<%} %>
	</table>
	</div>
	<%--댓글 영역 --%>
	<div align="center">
	<form action="contentClubPro.jsp" method="post" name="inputForm">
	<input type="hidden" name="pageNum" value="<%=request.getParameter("pageNum")%>" />
	<input type="hidden" name="bpageNum" value="<%=request.getParameter("bpageNum")%>" />
	<input type="hidden" name="boardnum" value="<%=request.getParameter("boardnum")%>" />
	<input type="hidden" name="clubNum" value="<%=request.getParameter("clubNum")%>" />
	<input type="hidden" name="ref" value="<%=boardnum%>" />
	<input type="hidden" name="ref_num" id="ref_num" value="-1"/>
	<input type="hidden" name="writer" value="<%=id%>"/>
	<input type="hidden" name="ref_step" id="ref_step" value="0"/>
	<input type="hidden" name="replyto" id="replyto" value="null"/>
	<%-- <table id="replyBox" align="center">--%>
	<table id="replyBox" style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
		<tr>
			<td colspan="3" align="left">전체 댓글[<%=replyList.size() %>] </td>
		</tr>
<%
			for(int i = 0; i < replyList.size(); i++){ 
			rdto = (Club_ReplyDTO)replyList.get(i);
%>
		<tr id="re_<%=i%>">
			<td>id= <%=rdto.getWriter() %></td>
			<td>
<%
				if(rdto.getRef_step()==1){
%>
					☞<%=rdto.getReplyto()%>&nbsp;
<% 
				}
%>

				<%=rdto.getContent()%><br/>
				<button type="button" onclick="reply(<%=i%>, <%=rdto.getRef_num()%>,'<%=rdto.getWriter()%>')">댓글</button>
			</td>
			<td><%=sdf.format(rdto.getReg()) %>
				<%if(id.equals(rdto.getWriter())){ 
				
				%>
					<a href="contentReplyDelete.jsp?category=club&target=reply&num=<%=rdto.getNum()%>&boardnum=<%=boardnum%>&clubNum=<%=clubNum%>&pageNum=<%=pageNum%>&bpageNum=<%=bpageNum%>">&nbsp; x</a>
				<%} %>
			</td>
			<%-- 
			<td>
				num = <%=rdto.getNum()%>
				reply to = <%=rdto.getReplyto() %>
				ref = <%=rdto.getRef() %>
				ref_num= <%=rdto.getRef_num() %>
				ref_step= <%=rdto.getRef_step() %>
			</td>
			--%>
		</tr>
		
	<%} %>
	
			<tr>
				<td colspan="3">댓글 쓰기</td>
			</tr>
			<tr id="last">
				<td colspan="3"> <textarea rows="1" cols="50" name="content"></textarea> <input type="submit" value="등록"/></td>
			</tr>
		</table>
	</form>
	</div>
	<script>

	function reply(val, ref_num, replyto){
		var tb = document.getElementById("replyBox");
		var row = tb.insertRow(val+2);
		var cell1 = row.insertCell(0);
		var cell2 = row.insertCell(1);
		var cell3 = row.insertCell(2);
		cell1.colspan = "3";
		cell2.innerHTML="<textarea rows='1' cols='50' name='content'>"
		cell3.innerHTML="<input type='button' onclick='location.reload()' value='취소'><input type='submit' value='등록' />"
		tb.deleteRow(-1);
		tb.deleteRow(-1);
		console.log(ref_num);
		console.log(replyto);
		// 태그에 id가 없으면 동작을 안해
		document.getElementById("ref_num").value = ref_num;
		document.getElementById("replyto").value = replyto;
		document.getElementById("ref_step").value = "1";
	}

</script>
</body>
</html>
