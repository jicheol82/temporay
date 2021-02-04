<%@page import="java.text.SimpleDateFormat"%>
<%@page import="woodley.main.message.MessageDAO"%>
<%@page import="woodley.main.message.MessageDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
	request.setCharacterEncoding("utf-8");
	String id = (String)session.getAttribute("memId");
	// 쪽지 쓰기와 읽기를 한페이지에서 실행
	String function = request.getParameter("function");
	if(function.equals("write")){	//쪽지를 보내는 경우
%>
		<title>쪽지 보내기</title>
		</head>
		<body>
			<form action="../main/messagePro.jsp" method="post">
				<input type="hidden" name="function" value="write" />
				<input type="hidden" name="receiver" value="<%=request.getParameter("receiver")%>" />
				<input type="hidden" name="cond" value="sender" />
				<table>
					<tr>
						<td>받는 사람 : <%=request.getParameter("receiver")%></td>
					</tr>
					<tr>
						<td width="150px" height="170px"><textarea rows="10" cols="30" name="content"></textarea></td>
					</tr>
					<tr>
						<td><input type="submit" value="보내기" /><input type="button" value="취소" onclick="window.close()"></td>
					</tr>
				</table>
			</form>
		</body>
<%
		
	}else if(function.equals("read")){	//쪽지를 읽는 경우
		int num = Integer.parseInt(request.getParameter("num"));
		String cond = request.getParameter("cond");
		MessageDAO dao = MessageDAO.getInstance();
		MessageDTO dto = dao.getMessage(num);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");
		
		boolean toggle=false; //삭제 버튼 표시를 위한 토글스위치 쪽지 받은 사람은 항상 true
		%>
		<title>쪽지 읽기</title>
		</head>
		<body>
			<form action="../main/messagePro.jsp" method="post">
				<input type="hidden" name="function" value="delete" />
				<input type="hidden" name="num" value="<%=dto.getNum()%>" />
				<input type="hidden" name="cond" value="<%=cond%>" />
				<table>
					<tr>
						<td>
<%							//쪽지를 읽는 사람의 상태에 따라 변경
							if(cond.equals("receiver")){
								//쪽지를 받은 사람이 읽어 state를 1로 변환한다.
								dao.changeState(dto.getNum());
								toggle=true;
%>
								보낸 사람 : <%=dto.getSender()%>
<%
							}else if(cond.equals("sender")){ 
								toggle=false;
%>
								받는 사람 : <%=dto.getReceiver()%>
<%							
							}
%>
						</td>
						<td align=right><%=sdf.format(dto.getReg())%></td>
					</tr>
					<tr>
						<td colspan="2" width="150px" height="170px"><textarea rows="10" cols="30" name="content" readonly><%=dto.getContent()%></textarea></td>
					</tr>
					<tr>
						<td colspan="2">
<%
						if(!id.equals(dto.getSender())){
%>
							<input type="button" value="답장" onclick="window.location='../main/messageForm.jsp?receiver=<%=dto.getSender()%>&function=write'"/>
<%
						}
%>
<%
						if(toggle || dto.getState()==0 || dto.getState()==2){
%>							
							<input type="submit" value="삭제" />
<%							
						}
%>
						<input type="button" value="취소" onclick="window.close()"></td>
					</tr>
				</table>
			</form>
		</body>
<%	
	}
%>

</html>