<%@page import="woodley.fooball.club.Club_CreateDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동호회 이름 중복 확인</title>
<%
	String tName = request.getParameter("tName");
	Club_CreateDAO dao = Club_CreateDAO.getInstance();
	boolean res = dao.confirmtName(tName);
	//System.out.println("res = " + res);
%>
</head>
<body>
		<div align="center">
	<%if(res){ //아이디가 DB에 존재  %>
		<table align = "center" style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
			<tr>
				<td>'<%=tName %>'는 이미 사용중인 아이디 입니다. </td>
			</tr>
		</table><br/>
		<form action ="confirmtName.jsp" method="post">
			<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" > 
				<tr>
					<td>다른 아이디를 입력하세요<br/>
						<input type="text" name="tName"/>
						<input type="submit" value="동호회 명 중복확인"/>
					</td>
					
				</tr>
			</table>
		</form>
		
	<% }else{ //이 아이디가 DB에 존재하지 않을 때 --> 사용가능하다. %>
		<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
			<tr>
				<td>입력하신 '<%=tName %> ' 는 사용할 수 있는 아이디 입니다. <br /></td>
			</tr>
			<tr align="center">		
				<td><input type="button" value="닫기" onclick="settName()" /></td>
			</tr>
<% }
	%>
		
		</table>	
		</div>
		
	<script>
		function settName(){
			//팝업을 열어준 원래 페이지의 id란에 지금 체크한 id값 넣어주기 
			opener.document.inputForm.tName.value= "<%=tName%>";
			//창 닫기 
			self.close();
			
		}
	
	
	</script>

</body>
</html>