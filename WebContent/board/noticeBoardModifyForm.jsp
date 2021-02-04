<%@page import="woodley.football.comboard.Notice_BoardDTO"%>
<%@page import="woodley.football.comboard.Notice_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
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
	//로그인 처리부	-쿠키 사용하지 않음
	String id = (String)session.getAttribute("memId");
	//boolean loggedin = false;	// login 상태 확인
	boolean admin = false;	// 관리자 파악
	if(id!=null){
		//loggedin = true;
		if(id.equals("admin")) admin=true;
	}
	
	// 넘어온 값 받기
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	// dao 생성하여 본문 글 가져오기
	Notice_BoardDAO dao = Notice_BoardDAO.getInstance();
	Notice_BoardDTO dto = dao.getArticle(num);
%>
<body>
	<jsp:include page="../main/main.jsp"/>
	<div class="container">
	<form action="noticeBoardWritePro.jsp" method="post" enctype="multipart/form-data">
		<input type="hidden" name="pageNum" value="<%=pageNum%>" />
		<input type="hidden" name="num" value="<%=num%>" />
	<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
		<thead>
			<tr>
				<th colspan="2"><h4>공지사항 수정</h4></th>
			</tr>
		</thead>
			<tr>
				<td> 작성자 </td>
				<td align="left"> <input type="text" name="writer" value="<%=dto.getId()%>" readonly /> </td>
			</tr>
			<tr>
				<td> 제목 </td>
				<td align="left"> <input type="text" name="title" value="<%=dto.getTitle() %>" /></td>
			</tr>
			<tr>
				<td> 내   용 </td>
				<td> <textarea rows="20" cols="70" name = "content" ><%=dto.getContent()%></textarea> </td>
			</tr>
			<tr> 
				<td> 사   진</td>
				<td>
<%
					if(dto.getPic()==null){
%>
						<img src="https://concrete.store/Content/images/not-available.jpg" width="100" /><br/>
<%					
					}else{
%>
						<img src="/woodley/save/<%=dto.getPic()%>" width="100" /><br/>
<%					
					}
%>						<input type="hidden" name="oldpic" value="<%=dto.getPic()%>"/>
						<input type="file" name="pic" />
				</td>
			<tr>
			<tr>
				<td colspan="2">
<%
					if(admin){
%>
						<input type="submit" value="저장" />
						<input type="button" value="삭제" onclick="location='../board/deleteArticlesPro.jsp?delete=<%=num%>&pageNum=<%=pageNum%>'"/>
<%					
					}
%>
					<input type="button" value="리스트 보기" onclick="location='../board/noticeBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>