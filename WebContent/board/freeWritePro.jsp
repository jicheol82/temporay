<%@page import="woodley.football.comboard.Free_BoardDTO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="woodley.football.comboard.Free_BoardDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<%request.setCharacterEncoding("UTF-8");
	Free_BoardDTO dto = new Free_BoardDTO(); //객체생성
	String path = request.getRealPath("save");
	//System.out.println(path);
	
	int max = 1024 * 1024 * 5;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();  // 중복방지 파일중복식 파일이름에 자동으로 123붙여줌
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	
	dto.setTitle(mr.getParameter("title"));   //파일 업로드시 useBean setproperty불가 파라미터 하나씩배써 dto에 담아줘야함
	dto.setWriter(mr.getParameter("writer"));
	dto.setContent(mr.getParameter("content"));
	dto.setImg(mr.getFilesystemName("img"));


	
//	article.setReg(new Timestamp(System.currentTimeMillis()));

	Free_BoardDAO dao = Free_BoardDAO.getInstance(); 
	dao.insertArticle(dto);
	
	response.sendRedirect("freeBoard.jsp?category=comboard");

%>

<body>

</body>
</html>