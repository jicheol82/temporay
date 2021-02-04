<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> resign </title>

<script type="text/javascript">
			<%--비밀번호 미 입력 경고창 --%>
		function checkValue(){
			if(!document.resign.password.value){
				alert("비밀번호를 입력하지 않았습니다.");
				return false;
			}
		}
	</script>
</head>
<body>
	<h2 align="center"> 회원 탈퇴</h2>
	<h5 align="center"> 탈퇴를 원하시면 비밀번호를 입력해주세요.</h5>
	<table>
		<tr>
			<td> 비밀번호 입력</td>
			<td><input type="password" name="pw" /></td>
		</tr>
	</table>
	<br />
	<input type="submit" value="회원탈퇴" onclick="main.jsp"/>
	<input type="button" value="취소"  onclick="myInfo.jsp"/>
</body>
</html>