<%@page import="woodley.main.member.MemberDAO"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDAO"%>
<%@page import="woodley.football.comboard.Mercenary_BoardDTO"%>
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
	// modify와 같이 사용한다.
	// 초기설정
	request.setCharacterEncoding("utf-8");
	String path = request.getRealPath("save");
	int max = 1024*1024*5;
	String enc = "utf-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);

	//로그인 처리부	-쿠키 사용하지 않음
	String id = (String)session.getAttribute("memId");
	
	// 위 아이디로 소속 동호회 가져옴
	MemberDAO mdao = MemberDAO.getInstance();
	String tname = mdao.findTname(id);
	
	String pageNum = mr.getParameter("pageNum");
	//dto에 넘어온 글 정보 입력
	Mercenary_BoardDTO dto = new Mercenary_BoardDTO();
	dto.setBulletPoint(mr.getParameter("bulletPoint"));
	dto.setTitle(mr.getParameter("title"));
	dto.setWriter(id);
	dto.setTname(tname);
	dto.setContent(mr.getParameter("content"));
	//img가 있음에도 수정을 안했을 경우에는 이전 img(oldimg)를 사용
	if(mr.getFilesystemName("img")==null && mr.getParameter("oldimg")!=null){
		dto.setImg(mr.getParameter("oldimg"));
	}else{dto.setImg(mr.getFilesystemName("img"));}
	
	// num값이 없으면 새글 작성, 이미 있으면 글 수정
	if(mr.getParameter("num")==null){
		// dao.insertArticle
		Mercenary_BoardDAO dao = Mercenary_BoardDAO.getInstance();
		if(dao.insertArticle(dto)){
			response.sendRedirect("../board/recruitBoard.jsp?event=football&category=comboard&pageNum="+pageNum);
		}else{
%>
			<script>
				alert("글 등록 실패");
				window.location="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>";
			</script>
<%
		}
	}else{
		dto.setNum(Integer.parseInt(mr.getParameter("num")));
		Mercenary_BoardDAO dao = Mercenary_BoardDAO.getInstance();
		if(dao.modifyArticle(dto)){
			response.sendRedirect("../board/recruitBoard.jsp?event=football&category=comboard&pageNum="+pageNum);
		}else{
%>
			<script>
				alert("글 수정 실패");
				window.location="../board/recruitBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>";
			</script>
<%
		}
	}
%>
<body>

</body>
</html>