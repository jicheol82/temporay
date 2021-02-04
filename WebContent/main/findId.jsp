<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Find id</title>
<script> 
	
</script>
</head>

<body>
	<form action="findIdPro.jsp" method="post">
   	<br />
	<br />
		
	<h1> 아이디 찾기</h1>
	<tr>
		<td>
			이름 <input type="text" placeholder="이름 입력" name="name" required /> <br/>
		</td>
	</tr>
	<tr>
		<td>
			 이메일 <input type="text" placeholder="이메일 입력" name="name" required /> <br />
		</td>
	</tr>
	<tr>
		<td>
			<input type="button" name="findid" value="아이디찾기" onclick="window.location='findIdPro.jsp'"/>
		</td>
	</tr>
	<tr>
		<td>
			<input type="button" name="login" value="로그인" onclick="window.location='loginForm.jsp'" />
		</td>
	</tr>
</form>
</body>
</html>