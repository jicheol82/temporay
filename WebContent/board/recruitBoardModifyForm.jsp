<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDTO"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모집글 수정</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
<%	// 아무 내용도 안넣을 경우의 유효성 검사 필요 %>
<script>
	function check(){
		var input = document.writeForm;
		if(input.bulletPoint.value==""){
			alert("말머리를 선택하여 주세요.");
			return false;
		}
		if(input.title.value==""){
			alert("제목을 입력하여 주세요.");
			return false;
		}
		if(input.content.value==""){
			alert("내용을 입력하여 주세요.");
			return false;
		}
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
	//로그인 처리부	recruitBoardCon에서 이미 사용자 검증하였으므로 사용하지 않음
	
	// 정보 저장
	String pageNum = request.getParameter("pageNum");
	// 게시글 불러올 준비
	int num = Integer.parseInt(request.getParameter("num"));
	Mercenary_BoardDAO dao = Mercenary_BoardDAO.getInstance();
	Mercenary_BoardDTO dto = dao.getArticle(num);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");	// 게시글용
	
%>
<body>
	<jsp:include page="../main/main.jsp"/>
	<div class="container">
	<form action="../board/recruitBoardWritePro.jsp" method="post" name="writeForm" enctype="multipart/form-data" onsubmit="return check()">
		<input type="hidden" name="num" value="<%=dto.getNum()%>" />
		<input type="hidden" name="pageNum" value="<%=pageNum%>" />
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<tr>
				<td> 제목 </td>
				<td align="left"> 
					<select name="bulletPoint">
						<option value="">말머리선택</option>
						<option id="1" value="[용병구함]">[용병구함]</option>
						<option id="2" value="[선수구함]">[선수구함]</option>
						<option id="3" value="[팀구함]">[팀구함]</option>
					</select>
					<input type="text" name="title" value="<%=dto.getTitle()%>" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
<%
						if(dto.getImg()==null){
%>
							<img src="https://concrete.store/Content/images/not-available.jpg" width="100" /><br/>
<%					
						}else{
%>
							<img src="/woodley/save/<%=dto.getImg()%>" width="100" /><br/>
<%					
						}
%>						
							<input type="hidden" name="oldimg" value="<%=dto.getImg()%>"/>
							<input type="file" name="img" />
				 </td>
			</tr>
			<tr>
				<td> 내   용 </td>
				<td> <textarea rows="20" cols="70" name = "content"><%=dto.getContent()%></textarea> </td>
			</tr>
			
			<tr>
				<td colspan="2">
					<input type="submit" value="확인"/> 
					<input type="reset" value="재작성"/>
					<input type="button" value="취소" onclick="location='../board/recruitBoard.jsp?event=footbal&category=comboard&pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>