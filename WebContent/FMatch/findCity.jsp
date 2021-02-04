<%@page import="woodley.main.scity.S_CityDAO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.main.bcity.B_CityDTO"%>
<%@page import="woodley.main.bcity.B_CityDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	request.setCharacterEncoding("utf-8");
	B_CityDAO dao = B_CityDAO.getInstance();
	List dtoList = dao.callBcity();
	B_CityDTO dto = new B_CityDTO();
	S_CityDAO s_dao = S_CityDAO.getInstance();
	List allList = s_dao.getAllCities();
	
%>
<script>
	// city1에 맞는 옵션생성 하기
	function fnCngList(val){
		// ajax불러와야 함
		
	}
	// 도시를 선택하여 이전 페이지로 넘겨주기
	function setCity(){
		var city = document.getElementById("city1").value + " " + document.getElementById("city2").value;
		console.log(city);
		//팝업을 열어준 원래 페이지의 id란에 지금 체크한 id값 넣어주기
		opener.document.inputForm.city.value=city;
		// 팝업창 닫기
		self.close();
	}
</script>
<body>
	<select id="city1" onchange="fnCngList(this.value);">
		<option value="0">대분류</option>
<%
		for(int i=0; i<dtoList.size(); i++){
			dto = (B_CityDTO)dtoList.get(i);
%>
			<option value="<%=dto.getCity_num()%>"><%=dto.getCity_name()%></option>		
<%			
		}
%>
	</select>
	<!-- 향후 ajax 사용하여 시군 정보 가져올 것 -->
	<select id="city2">
		<option value="0">소분류</option>
<%
		for(int i=0; i<allList.size(); i++){
			//dto = (B_CityDTO)allList.get(i);
%>
			<option value=""><%=allList.get(i)%></option>		
<%			
		}
%>
	</select>
	<input type="button" value="확인" onclick="setCity()"/>
	
</body>
</html>