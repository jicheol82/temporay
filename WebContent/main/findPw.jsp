<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>findPw</title>
</head>
<body>
	<form action="findPwPro.jsp" method="post">
	<h1> 비밀번호 찾기</h1>
	<tr>
		<td>
			<input type="text" placeholder="아이디 입력" name="id"  /> <br/>
		</td>
	</tr>
	<tr>
		<td>
			<input type="text" placeholder="이름 입력" name="name"  /> <br />
		</td>
	</tr>
	<tr>
		<td>
			<input type="text" placeholder="이메일 입력" name="email"  /> <br />
		</td>
	</tr>
	<tr>
		<td>
			<input type="text" placeholder="임시비밀번호 입력" name="tem"  /> <br />
		</td>
	</tr>
	<tr>
		<td>
			<input type="button" name="findid" value="로그인" onclick="window.location='main.jsp'" />
		</td>
	</tr>
	
	
		
		

</body>
</html>