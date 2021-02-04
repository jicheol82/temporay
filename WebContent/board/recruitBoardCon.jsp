<%@page import="java.util.List"%>
<%@page import="woodley.football.comboard.Mercenary_ReplyDTO"%>
<%@page import="woodley.football.comboard.Mercenary_ReplyDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDAO"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 읽기</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
<script>
	// 대댓글 작성시 해당 댓글 밑에 글쓰기상자 생성 및 본문글 댓글 상자 없애기
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
</head>
<%	
	// url 접근 방지
	String referer = request.getHeader("referer");
	if(referer == null){
%>
		<script>
			alert("비정상적인 접근입니다.");
			history.go(-1);
		</script>
<%	
	}
%>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	Mercenary_BoardDAO dao = Mercenary_BoardDAO.getInstance();
	Mercenary_BoardDTO dto = dao.getArticle(num);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");	// 게시글용
	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");	// 댓글용

	//로그인 처리부	-쿠키 사용하지 않음
	String id = (String)session.getAttribute("memId");
	String pageNum = request.getParameter("pageNum");
	//boolean loggedin = false;	// login 상태 확인
	boolean admin = false;	// 관리자 파악
	if(id!=null){
		//loggedin = true;
		if(id.equals("admin")) admin=true;
	}
	
	// 댓글 관련
	Mercenary_ReplyDAO daoR = Mercenary_ReplyDAO.getInstance();
	Mercenary_ReplyDTO dtoR = new Mercenary_ReplyDTO();
	List replyList = daoR.getReply(num);
%>
<body>
	<jsp:include page="../main/main.jsp"/>
	<div class="container">
	<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
		<tr>
			<td><%=dto.getBulletPoint()%>&nbsp;<%=dto.getTitle()%></td>
			<td align="right">
<%
				if(id.equals(dto.getWriter()) || id.equals("admin")){
%>
					<input type="button" onclick="location='../board/deleteRecruitPro.jsp?target=content&num=<%=dto.getNum()%>&pageNum=<%=pageNum%>'" value="삭제">
					<input type="button" onclick="location='../board/recruitBoardModifyForm.jsp?event=football&category=comboard&num=<%=dto.getNum()%>&pageNum=<%=pageNum%>'" value="수정">
<%
				}
%>
			</td>
		</tr>
		<tr>
			<td>posted by <%=dto.getWriter()%> at <%=sdf.format(dto.getReg())%></td>
			<td align="right">reviewed <%=dto.getReadcount()%></td>
		</tr>
		<tr>
			<td colspan="2"><textarea rows="20" cols="70" name = "content" readonly><%=dto.getContent()%></textarea></td>
		</tr>
		<tr>
			<td colspan="2">
<%
				if(dto.getImg()==null){
%>
					<img src="https://concrete.store/Content/images/not-available.jpg" width="100" />
<%					
				}else{
%>
					<img src="/woodley/save/<%=dto.getImg()%>" width="100" />
<%					
				}
%>
		<tr>
	</table>
<!--  댓글영역  -->

	<form action="../board/recruitReplyPro.jsp" method="post" name="inputForm">
		<input type="hidden" name="pageNum" value="<%=pageNum%>"/>
		<input type="hidden" name="ref" value="<%=num%>"/>
		<input type="hidden" name="ref_num" id="ref_num" value="-1"/>
		<input type="hidden" name="writer" value="<%=id%>"/>
		<input type="hidden" name="ref_step" id="ref_step" value="0"/>
		<input type="hidden" name="replyto" id="replyto" value="null"/>
		<table id="replyBox" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<tr>
				<td align="left">전체댓글 [<%=replyList.size()%>]</td>
				<td></td>
				<td align="right"><button type="button" onclick="window.location='../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>'">목록으로</button></td> 
			</tr>
		
<%
				for(int i=0;i<replyList.size();i++){
					dtoR = (Mercenary_ReplyDTO)replyList.get(i);
%>
			<tr id="re_<%=i%>" align="left">
				<td><%=dtoR.getWriter()%></td>
				<td >
<%
					if(dtoR.getRef_step()==1){
%>
						☞<%=dtoR.getReplyto()%>&nbsp;
<%
					}
%>				
					<%=dtoR.getContent()%><br/>
					<!-- 메소드 안에 문자는 ''를 넣어야한다 -->
					<button type="button" onclick="reply(<%=i%>, <%=dtoR.getRef_num()%>,'<%=dtoR.getWriter()%>')">댓글</button>
				</td>
				<td><%=sdf2.format(dtoR.getReg())%>
<%					
					if(id.equals(dtoR.getWriter())){
%>
						<a href="../board/deleteRecruitPro.jsp?target=reply&num=<%=dtoR.getNum()%>&conNum=<%=num%>" >×</a>
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
				<td><input type="submit" value="등록"/></td>
			</tr>
		</table>
	</form>


</body>
</html>