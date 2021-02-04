<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<script type="text/javascript" src="../se2/js/HuskyEZCreator.js" charset="utf-8"></script>
	<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>

<link rel="stylesheet" href="css/bootstrap.css">
<title>writeFormClub</title>
<script>
		function check(){
			//필수기입란 기입했는지
			var inputs = document.inputForm;
			//pw, pwch 동일한지
			if(!inputs.title.value){
				alert("제목을 입력해주세요");
				return false;
			}
			if(!inputs.content.value){
				alert("내용을 입력해주세요")
				return false;
			}
		}

	</script>
</head>
<%	int clubNum = Integer.parseInt(request.getParameter("clubNum"));
	String pageNum = request.getParameter("pageNum");
	//System.out.println("writeform clubNum =" + clubNum);
	//System.out.println(clubNum);
	String writer = (String)session.getAttribute("memId");
			
%>
<body>
<jsp:include page="../main/main.jsp"></jsp:include>
<h3 align="center"><a href="introClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 소개</a> | <a href="boardClub.jsp?category=club&pageNum=<%=pageNum%>&clubNum=<%=clubNum%>">동호회 게시판</a></h3>
	<br /><br />
	<div align="center">
	<form action="writeProClub.jsp" method="post" enctype="multipart/form-data" name="inputForm" onsubmit="return check()">	
		<input type="hidden" name="pageNum" value="<%=pageNum %>" />
		<input type="hidden" name="clubNum" value="<%=clubNum %>" />
		<input type="hidden" name="writer" value="<%=writer %>" />
		<table style="width: 500px;" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd" >
			<tr>
				<td><input type="text" name="title" placeholder="제목"/></td>
			</tr>
			<tr>
				<td><textarea id="content" rows="10" cols="50" name="content" placeholder="내용"></textarea></td>
			</tr>
			<tr>
				<td><input type="file" name="photo"/></td>
			</tr>
			<tr>
				<td>
					<input type="button" value="돌아가기" onclick="window.location='boardClub.jsp?category=club&clubNum=<%=clubNum%>'"/>
					<input id="savebutton"  type="submit" value="작성하기"/>
				</td>
			</tr>
		</table>
	</form>
	</div>
	
</body>
</html>

<script type="text/javascript">

	$(document).ready(function() { var oEditors = []; // 개발되어 있는 소스에 맞추느라, 전역변수로 사용하였지만, 지역변수로 사용해도 전혀 무관 함. 
		// Editor Setting 
		nhn.husky.EZCreator.createInIFrame({ 
			oAppRef : oEditors, // 전역변수 명과 동일해야 함. 
			elPlaceHolder : "content", // 에디터가 그려질 textarea ID 값과 동일 해야 함. 
			sSkinURI : "../se2/SmartEditor2Skin.html", // Editor HTML 
			fCreator : "createSEditor2", // SE2BasicCreator.js 메소드명이니 변경 금지 X 
			htParams : { // 툴바 사용 여부 (true:사용/ false:사용하지 않음) 
				bUseToolbar : true, // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음) 
				bUseVerticalResizer : true, // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음) 
				bUseModeChanger : true, 
			} 
		}); 
	
	// 전송버튼 클릭이벤트 
	$("#savebutton").click(function(){ 
		//if(confirm("저장하시겠습니까?")) { // id가 smarteditor인 textarea에 에디터에서 대입 
			oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []); 
		
		// 이부분에 에디터 validation 검증 
		if(validation()) { 
			$("#frm").submit(); 
		} 
		//} 
		}) 
	}); 
	// 필수값 Check 
	function validation(){
		var contents = $.trim(oEditors[0].getContents()); 
		if(contents === '<p>&bnsp;</p>' || contents === ''){ // 기본적으로 아무것도 입력하지 않아도 값이 입력되어 있음. 
			alert("내용을 입력하세요.!!!"); oEditors.getById['content'].exec('FOCUS'); 
			return false; 
		} 
		
		return true; 
}

</script>
			