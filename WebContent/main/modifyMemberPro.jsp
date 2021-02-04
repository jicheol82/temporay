<%@page import="woodley.main.member.MemberDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyMemberPro</title>
</head>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="member" class="woodley.main.member.MemberDTO"/>
<jsp:setProperty property="*" name="member"/>
<%
	// multipartrequest 객체 생성
	String path = request.getRealPath("save");
	int max = 1024*1024*5;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	// id는 modifyMember에서 넘어가지 않으니까 채워주는
	String id = (String)session.getAttribute("memId");
	member.setId(id);
	member.setPw(mr.getParameter("pw"));
	member.setEmail(mr.getParameter("email"));
	member.setPhone(mr.getParameter("phone"));
	member.setBirth(mr.getParameter("birth"));
	member.setLocation(mr.getParameter("location"));
	member.setPrefer(mr.getParameter("prefer"));
		
	if(mr.getFilesystemName("profile") != null){
		member.setProfile(mr.getParameter("profile"));
	}else{
		member.setProfile(mr.getParameter("exProfile"));
	}
	MemberDAO dao = MemberDAO.getInstance();
	dao.updateMember(member);
%>
<body>
	<h1 align="center">회원정보 수정</h1>
	<table>
		<tr>
			<td><b> 정보가 수정 되었습니다.</b></td>
		</tr>
		<tr>
			<td>
				<button onclick="window.location='myInfo.jsp'"> 내정보 </button>
			</td>
		</tr>
	</table>

</body>
</html>