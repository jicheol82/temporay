<%@page import="java.util.List"%>
<%@page import="woodley.main.alert.AlertDTO"%>
<%@page import="woodley.main.alert.AlertDAO"%>
<%@page import="woodley.main.message.MessageDTO"%>
<%@page import="woodley.main.message.MessageDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림</title>
<link rel="stylesheet" href="../css/bootstrap.css">
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
<script type="text/javascript">
	window.history.forward();
	function noBack() {
		window.history.forward();
	}
</script>
<script>
	function sendMessage(id){
		var url = "messageForm.jsp?receiver="+id+"&function=write";
		open(url, "confirm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=250, height=280");
	}
	function readMessage(num, cond){
		var url = "messageForm.jsp?num="+num+"&function=read&cond="+cond;
		open(url, "confirm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizable=no, width=250, height=280");
	}
</script>
</head>
<%	
	String id = (String)session.getAttribute("memId");
	boolean loggedin = false;	// login 상태 확인
	boolean admin = false;	// 관리자 파악
	if(id!=null){
		loggedin = true;
		if(id.equals("admin")) admin=true;
	}
	MessageDAO dao = MessageDAO.getInstance(); 
	MessageDTO dto = new MessageDTO(); 
	AlertDAO daoA = AlertDAO.getInstance();
	AlertDTO dtoA = new AlertDTO();
	int num;
	int state;
	
%>

<body>
	<jsp:include page="../main/main.jsp"/>
	<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<caption>받은 쪽지함</caption>
			<tr>
				<th style="background-color: #fafafa; text-align: center;">번호</th>
				<th style="background-color: #fafafa; text-align: center;">보낸사람</th>
				<th style="background-color: #fafafa; text-align: center;">내용</th>
				<th style="background-color: #fafafa; text-align: center;">상태</th>
			</tr>
<%
			List messageList = dao.getMyMessageList(id, "receiver");
			num = messageList.size();
			for(; num>0; num--){
				dto = (MessageDTO) messageList.get(num-1);
%>
			<tr>
				<td><%=num%></td>
				<td><%=dto.getSender()%></td>
				<td><a onclick="readMessage(<%=dto.getNum()%>, 'receiver')"><%=dto.getContent()%></a></td>	
				<td><%if(dto.getState()==1){%>읽음<%}else{%>안읽음<%}%></td>
			</tr>
<%
			}
%>
	</table>
	<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<caption>보낸 쪽지함</caption>
			<tr>
				<th style="background-color: #fafafa; text-align: center;">번호</th>
				<th style="background-color: #fafafa; text-align: center;">받는사람</th>
				<th style="background-color: #fafafa; text-align: center;">내용</th>
				<th style="background-color: #fafafa; text-align: center;">상태</th>
			</tr>
<%
			messageList = dao.getMyMessageList(id, "sender");
			num = messageList.size();
			for(; num>0; num--){
				dto = (MessageDTO)messageList.get(num-1);
%>
			<tr>
				<td><%=num%></td>
				<td><%=dto.getReceiver()%></td>
				<td><a onclick="readMessage(<%=dto.getNum()%>, 'sender')"><%=dto.getContent()%></a></td>
				<td><%if(dto.getState()!=0){%>읽음<%}else{%>안읽음<%}%></td>	
			</tr>
<%
			}
%>
	</table>
	<table class="table" style="text-align: center; border: 1px solid #dddddd;" align="center">
		<caption>알림</caption>
			<tr>
				<th style="background-color: #fafafa; text-align: center;">번호</th>
				<th style="background-color: #fafafa; text-align: center;">보낸사람</th>
				<th style="background-color: #fafafa; text-align: center;">내용</th>
				<th style="background-color: #fafafa; text-align: center;">시간</th>
				<th style="background-color: #fafafa; text-align: center;">상태</th>
			</tr>
<%
			List alertList = daoA.getMyAlertList(id);
			num = alertList.size();
			for(; num>0; num--){
				dtoA = (AlertDTO) alertList.get(num-1);
%>
			<tr>
				<td><%=num%></td>
				<td><a onclick="sendMessage('<%=dtoA.getSender()%>')"><%=dtoA.getSender()%></a></td>
				<td><%=dtoA.getContent()%></td>	
				<td><%=dtoA.getReg()%></td>
				<td>
					<%if(dtoA.getState()==0){%>
					대기중<br/>
					<%
						if("match".equals(dtoA.getRequest())){
					%>
							<button onclick="window.location='../main/alertPro.jsp?request=<%=dtoA.getRequest()%>&ref=<%=dtoA.getRef()%>&num=<%=dtoA.getNum()%>&state=1'">수락</button>
							<button onclick="window.location='../main/alertPro.jsp?request=<%=dtoA.getRequest()%>&ref=<%=dtoA.getRef()%>&num=<%=dtoA.getNum()%>&state=2'">거절</button>
					<%		
						}
					}else if(dtoA.getState()==1){%>수락함<%}else if(dtoA.getState()==2){%>거절함<%} %>
				</td>
			</tr>
			<tr></tr>
<%
			}
%>
	</table>

</body>
</html>