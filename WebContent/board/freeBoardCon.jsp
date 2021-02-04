<%@page import="java.util.List"%>
<%@page import="woodley.football.comboard.Free_BoardReplyDAO"%>
<%@page import="woodley.football.comboard.Free_BoardReplyDTO"%>
<%@page import="woodley.football.comboard.Free_BoardDTO"%>
<%@page import="woodley.football.comboard.Free_BoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>글내용</title>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
</head>
<%
	String id = (String)session.getAttribute("memId");
	
	// 게시판목록에서 글제목을 클릭하면, 글 본문내용이 보여지는 content 페이지로 이동.
	// num=글고유번호(db의 num값)
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");//리스트로 돌아갈떄 보던 페이지로 돌아가기위해 넘겨받음
	if(pageNum == null) pageNum = "1";
	
	// 작성시간 시간 포맷
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm"); 	//게시글용
	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss"); //댓글용
	
	// 글 고유번호로 해당 글에 대한 전체 내용을 DB에서 가져오기
	Free_BoardDAO dao = Free_BoardDAO.getInstance();
	Free_BoardDTO article = dao.getArticle(num);
	
	//댓글
	Free_BoardReplyDAO daoR = Free_BoardReplyDAO.getInstance();
	Free_BoardReplyDTO dtoR = new Free_BoardReplyDTO();
	List replyList = daoR.getReply(num);
	
	
	
%>
<body>
<jsp:include page ="/main/main.jsp" flush="false"></jsp:include>

	<div align="center">
		<a href="noticeBoard.jsp?category=comboard">공지사항	|</a>
		<a href="freeBoard.jsp?category=comboard">자유게시판	|</a>
		<a href="recruitBoard.jsp?category=comboard">모집게시판</a><br/><br/>
	</div>
		
<%		if(id.equals(article.getWriter())) {%>
		<button class="btn btn-primary" onclick="window.location='modifyFormFreeBoard.jsp?pageNum=<%=pageNum%>&category=comboard&num=<%=article.getFree_board_num() %>'">수	정</button>
		<button class="btn btn-primary" onclick="window.location='FreeBoardDeleteForm.jsp?pageNum=<%=pageNum%>&category=comboard&num=<%=article.getFree_board_num() %>'">삭	제</button>
<%		}   %>
		
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<tr>
				<td><h2><%=article.getTitle() %></h2></td>
			</tr>
			<tr>
				<td>posted by 
				<b><%=article.getWriter() %> </b>at <%= sdf.format(article.getReg()) %>
				<%= article.getReadcount() %> viewed</td>
			</tr>
			<tr>
				<td>

			<%	if(article.getImg()!= null){ %>
					<img src="/woodley/save/<%=article.getImg()%>" width="150" /><br/>
			<%	}%>
				<textarea rows="20" cols="50" readonly><%=article.getContent() %></textarea>
				</td>
			</tr>
		</table>
		<button class="btn btn-primary" onclick="window.location='freeBoard.jsp?pageNum=<%=pageNum%>&category=comboard'">리스트보기</button>
	
	
	
	
	
	
	
	<%--댓글 --%>
	<div align="center">
	<form action="freeReplyPro.jsp" method="post" name="inputForm">
		<input type="hidden" name="pageNum" value="<%=request.getParameter("pageNum")%>"/>
		<input type="hidden" name="ref" value="<%=num%>"/>
		<input type="hidden" name="ref_num" id="ref_num" value="-1"/>
		<input type="hidden" name="writer" value="<%=id%>"/>
		<input type="hidden" name="ref_step" id="ref_step" value="0"/>
		<input type="hidden" name="replyto" id="replyto" value="null"/>
		<table id="replyBox" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<tr>
				<td colspan="3" align="left">전체댓글 [<%=replyList.size()%>]</td>
			</tr>
			
	<%           
				for(int i=0;i<replyList.size();i++){
					dtoR = (Free_BoardReplyDTO)replyList.get(i);
	%>
				<tr id="re_<%=i%>">
					<td><%=dtoR.getWriter()%></td>
					<td>
	<%					
						if(dtoR.getRef_step()==1){
	%>
							☞<%=dtoR.getReplyto()%>&nbsp;
	<%
						}
	%>			
						<%=dtoR.getContent()%>
						
						<button type="button" class="btn btn-primary" onclick="reply(<%=i%>, <%=dtoR.getRef_num()%>,'<%=dtoR.getWriter()%>')">댓글</button>
					</td>
					<td><%=sdf2.format(dtoR.getReg())%>
	<%					
						if(id.equals(dtoR.getWriter())){
	%>
<!-- 댓글 삭제 --> 			<a href="replyDelFreeBoard.jsp?target=reply&num=<%=dtoR.getFree_board_reply_num()%>&pageNum=<%=article.getFree_board_num()%>" >x</a>
	<%
						} 
	%>
					</td>	
				</tr>			
	<%
				}
	%>
			<tr>
				<td colspan="3">댓글쓰기</td>
			</tr>
			<tr id="last">
				<td colspan="2"><textarea rows="1" cols="50" name="content"></textarea></td>
				<td><input type="submit" value="등록" class="btn btn-primary"/></td>
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
			cell3.innerHTML="<input type='button' onclick='location.reload()' value='취소' class='btn btn-primary'> &nbsp; <input type='submit' value='등록' class='btn btn-primary' />"
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