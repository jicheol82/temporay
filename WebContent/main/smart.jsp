<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="../se2/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>


</head>
<body>
     <form action="/page/test/send.jsp" method="post" id="frm"> 
     	<textarea name="smarteditor" id="smarteditor" rows="10" cols="100" style="width:766px; height:412px;"> 
     	</textarea> 
     </form>

</body>
</html>
	<script type="text/javascript">

	$(document).ready(function() { var oEditors = []; // 개발되어 있는 소스에 맞추느라, 전역변수로 사용하였지만, 지역변수로 사용해도 전혀 무관 함. 
		// Editor Setting 
		nhn.husky.EZCreator.createInIFrame({ 
			oAppRef : oEditors, // 전역변수 명과 동일해야 함. 
			elPlaceHolder : "smarteditor", // 에디터가 그려질 textarea ID 값과 동일 해야 함. 
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
			oEditors.getById["smarteditor"].exec("UPDATE_CONTENTS_FIELD", []); 
		
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
			alert("내용을 입력하세요."); oEditors.getById['smarteditor'].exec('FOCUS'); 
			return false; 
		} 
		
		return true; 
}


		 </script>

		 
		 



