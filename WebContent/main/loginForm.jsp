<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>
	<jsp:include page="../main/main.jsp"></jsp:include>
	<br/>
	<div class="container">
		<form action="loginPro.jsp" method="post" >
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2" align="center"><h4>로그인</h4></th>
					</tr>
				</thead>
				<tr>
					<td align="center"><h5>아이디</h5></td>
					<td><input class="form-control" type="text" name="id" /></td>
				</tr>
				<tr>
					<td align="center"><h5>비밀번호</h5></td>
					<td><input class="form-control" type="password" name="pw" /></td>
				</tr>
				<tr>
					<td style="text-align: center" colspan="2">
						<input  class="btn btn-primary pull-center" type="submit" value="로그인" /> 
						<input class="btn btn-primary pull-center" type="button" value="취소 "onclick="window.location='main.jsp'">
					</td>
				</tr>
			</table>
		</form>
	</div>						
</body>

</html>