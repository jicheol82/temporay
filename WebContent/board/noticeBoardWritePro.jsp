<%@page import="woodley.football.comboard.Notice_BoardDAO"%>
<%@page import="woodley.football.comboard.Notice_BoardDTO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	// modify와 같이 사용
	// 설정
	request.setCharacterEncoding("utf-8");
	String path = request.getRealPath("save");	
	int max = 1024*1024*5;
	String enc = "utf-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	// dto에 입력
	// usebean을 써도 되고
	// 객체를 생성해도 되고
	String pageNum = mr.getParameter("pageNum");
	Notice_BoardDTO dto = new Notice_BoardDTO();
	dto.setId(mr.getParameter("writer"));
	dto.setTitle(mr.getParameter("title"));
	dto.setContent(mr.getParameter("content"));
	if(mr.getFilesystemName("pic")==null && mr.getParameter("oldpic")!=null){
		dto.setPic(mr.getParameter("oldpic"));
	}else{dto.setPic(mr.getFilesystemName("pic"));}
	
	// num값이 없으면 새글 작성, 이미 있으면 글 수정
	if(mr.getParameter("num")==null){
		// dao.insertArticle
		Notice_BoardDAO dao = Notice_BoardDAO.getInstance();
		if(dao.insertArticle(dto)){
			response.sendRedirect("../board/noticeBoard.jsp?event=football&category=comboard&pageNum="+pageNum);
		}else{
%>
			<script>
				alert("글 등록 실패")
				window.location="../board/noticeBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>"
			</script>
<%
		}
	}else{
		dto.setNotice_board_num(Integer.parseInt(mr.getParameter("num")));
		Notice_BoardDAO dao = Notice_BoardDAO.getInstance();
		if(dao.modifyArticle(dto)){
			response.sendRedirect("../board/noticeBoard.jsp?event=football&category=comboard&pageNum="+pageNum);
		}else{
%>
			<script>
				alert("글 수정 실패")
				window.location="noticeBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>"
			</script>
<%
		}
	}
%>
<body>

</body>
</html>