<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/bootstrap.css">
<title>동호회 생성</title>
	<script>
		function check(){
			//필수기입란 기입했는지
			var inputs = document.inputForm;
			//pw, pwch 동일한지
			if(!inputs.tName.value){
				alert("동호회 이름을  입력하세요");
				return false;
			}
			if(!inputs.tNum.value){
				alert("동호호 인원을 입력하세요")
				return false;
			}
			if(!inputs.skill.value){
				alert("실력을 입력하세요")
				return false;
			}
			if(!inputs.tLocal.value){
				alert("지역을 입력하세요")
				return false;
			}
			if(!inputs.ground.value){
				alert("활동 경기장을 입력하세요.")
				return false;
			}
			if(!inputs.emblem.value){
				alert("엠블럼을 업로드해주세요.")
				return false;
			}
		}
		//동호회명 중복 확인 함수
		function openConfirmtName(inputForm){
			console.log(inputForm.tName.value); //폼태그안에 name 속성이 id인 태그의 입력값출력 
			//form태그 안에 id 입력란에 작성 값을 꺼내서 db연결해 검사 
			if(inputForm.tName.value == ""){ //id란 입력했는지 검사 
				alert("아이디를 입력하세요");
				return; //아래 코드 실행하지 않고 이 함수 강제 종료! 
			}
			//팝업 띄워서 id 확인 결과 보기 
			//팝업 띄울 주소를 작성 > id란에 입력한 값을 get 방식 파라미터로 같이 전송 !
			var url = "confirmtName.jsp?tName=" + inputForm.tName.value;
			
			open(url, "tName", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, width=500, height=200");
			
			
		}
	</script>
<%
	String id = (String)session.getAttribute("memId");
	//뒤로가기에 붙혀줄 pageNum 받아오기 
	String pageNum = request.getParameter("pageNum");
	//System.out.println("createClub pageNum= " + pageNum);
%>
</head>
<body>
<jsp:include page="../main/main.jsp"></jsp:include>
	<br />
	<form action="createClubPro.jsp" method="post" name="inputForm" enctype="multipart/form-data" onsubmit="return check()">
		<input type="hidden" name="memId" value="<%=id%>" />
		<div align="center">
		<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
			<tr>
				<td>동호회 이름*</td>
				<td><input type="text" name="tName"/></td>
			</tr>
			<tr>
				<td>동호회 이름 중복 검사*</td>
				<td><input type="button" value="중복 확인" onclick="openConfirmtName(this.form)"/></td>
			</tr>
			<tr>
				<td>동호회 인원*</td>
				<td><input type="text" name="tNum"/></td>
			</tr>
			<tr>
				<td>연령대*</td>
				<td>
					<select name="avrAge">
						<option value="10대">10대</option>
						<option value="20대">20대</option>
						<option value="30대">30대</option>
						<option value="40대">40대</option>
						<option value="50대">50대</option>
						<option value="60대">60대</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>종목*</td>
				<td>
					<select name="clubEvent">
						<option value="축구">축구</option>
						<option value="농구">농구</option>
						<option value="탁구">탁구</option>
						<option value="배드민턴">배트민턴</option>
						<option value="스타크래프트">스타크래프트</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>실력*</td>
				<td>
					<input type="radio" name="skill" value="상"> 상
					<input type="radio" name="skill" value="중"> 중
					<input type="radio" name="skill" value="하"> 하
				</td>
			</tr>
			<tr>
				<td>지역*</td>
				<td><input type="text" name="tLocal" /></td>
			</tr>
			<tr>
				<td>활동경기장*</td>
				<td><input type="text" name="ground" /></td>
			</tr>
			<tr>
				<td>엠블럼*</td>
				<td><input type="file" name="emblem" /></td>
			</tr>
			<tr>
				<td>팀소개</td>
				<td><textarea rows="20" cols="50" name="bio"></textarea>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" value="만들기" />
					<input type="reset" value="재작성" />
					<input type="button" value="뒤로" onclick="window.location='findClub.jsp?category=club&pageNum=<%=pageNum%>'"/>
					
				</td>
			</tr>
			<tr>
			</tr>
		</table>
		</div>
	</form>
</body>
</html>