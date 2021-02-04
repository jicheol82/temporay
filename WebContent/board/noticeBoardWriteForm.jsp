<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지게시판 글쓰기</title>
<script type="text/javascript" src="../se2/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/custom.css">
</head>
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
<%	// 아무 내용도 안넣을 경우의 유효성 검사 필요 %>
<%
	//로그인 처리부	-쿠키 사용하지 않음
	String id = (String)session.getAttribute("memId");
	//boolean loggedin = false;	// login 상태 확인
	boolean admin = false;	// 관리자 파악
	if(id!=null){
		//loggedin = true;
		if(id.equals("admin")) admin=true;
	}
	// 세션 정보 저장
	String pageNum = request.getParameter("pageNum");
%>
<body>
	<jsp:include page="../main/main.jsp"/>
	<div class="container">
	<form action="noticeBoardWritePro.jsp" method="post" name="writeForm" enctype="multipart/form-data">
		<input type="hidden" name="pageNum" value=<%=pageNum%> />
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="2"><h4>공지사항 작성</h4></th>
				</tr>
			</thead>	
			<tr>
				<td> 작성자 </td>
				<td align="left"> <input type="text" name="writer" value="admin"/> </td>
			</tr>
			<tr>
				<td> 제목 </td>
				<td align="left"> <input type="text" name="title"/> </td>
			</tr>
			<tr>
				<td> 내   용 </td>
				<td> <textarea id="content" rows="20" cols="70" name = "content"></textarea> </td>
			</tr>
			<tr>
				<td> 그림파일 </td>
				<td> <input type="file" name="pic" /> </td>
			</tr>
			<tr>
				<td colspan="2">
					<input id="savebutton" class="btn btn-primary" type="submit" value="저장"/> 
					<input type="reset" value="재작성" class="btn btn-primary"/>
					<input type="button" value="리스트 보기" class="btn btn-primary" onclick="location='../board/noticeBoard.jsp?event=football&category=comboard&pageNum=<%=pageNum%>'"/>
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