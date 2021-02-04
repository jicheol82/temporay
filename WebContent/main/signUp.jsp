<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/custom.css">
<title>signup Form</title>
	<script>
		// 유효성 검사
		function check(){
			var inputs = document.inputForm;
			// 필수 기입란 기입했는지
			if(!inputs.id.value){
				alert("아이디를 입력하세요.");
				return false;
			}
			if(!inputs.pw.value){
				alert("비밀번호를 입력하세요.");
				return false;
			}
			if(!inputs.name.value){
				alert("이름을 입력하세요.");
				return false;
			}
			// pw , pwCh 동일한지 
			if(inputs.pw.value != inputs.pwch.value){
				alert("비밀번호와 비밀번호 확인이 일치하지 않습니다. ");
				return false;
			}
			
		}
	</script>
</head>
<%
	if(session.getAttribute("id") != null){ %>
		<script>
			alert("로그아웃 후에 이용해주세요.");
			window.location="woodley/main/main.jsp";
		</script>		
<%	}else{ %>
<body>
	<jsp:include page="../main/main.jsp"/>
	<br/>
	<div class="container">
		<form action="../main/signupPro.jsp" method="post" name="inputForm" enctype="multipart/form-data">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3" align="center"><h4>회원 가입</h4></th>
					</tr>
				</thead>
				<tr>
						<td colspan="2" style="width: 110px"><h5>아이디*</h5></td>
						<td><input class="form-control" type="text" id="id" name="id" maxLength="20"></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>비밀번호*</h5></td>
						<td><input class="form-control" type="password" id="pw" name="pw" ></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>비밀번호 확인*</h5></td>
						<td><input class="form-control" type="password" id="pwCh" name="pwCh" ></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>이름*</h5></td>
						<td><input class="form-control" type="text" id="name" name="name" ></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>휴대폰 번호*</h5></td>
						<td><input class="form-control" type="text" id="phone" name="phone" ></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>이메일*</h5></td>
						<td><input class="form-control" type="text" id="email" name="email" ></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>지역*</h5></td>
						<td><input class="form-control" type="text" id="location" name="location" ></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>선호종목*</h5></td>
						<td >
							<select name="prefer">
							<option>축구</option>
							<option>농구</option>
							<option>탁구</option>
							<option>배드민턴</option>
							<option>스타크래프트</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>생일</h5></td>
						<td><input class="form-control" type="text" placeholder="ex) YYYY-MM-DD" id="birth" name="birth" ></td>
					</tr>
					<tr>
						<td colspan="2" style="width:110px"><h5>프로필사진</h5></td>
						<td><input  type="file" name="profile" ></td>
					</tr>
					<tr>
						<td style="text-align: center" colspan="3">
							<input class="btn btn-primary pull-center" type="submit" value="가입">
							<input class="btn btn-primary pull-center" type="button" value="취소 "onclick="window.location='main.jsp'">
						</td>
					</tr>
				</tbody>
				</table>
			</form>
		</div>
</body>
<% } %>
</html>