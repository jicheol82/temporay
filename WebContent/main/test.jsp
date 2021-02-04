<%@page import="org.json.simple.JSONObject"%>
<%@page import="woodley.main.bcity.B_CityDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.main.bcity.B_CityDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%
	B_CityDAO b_city = B_CityDAO.getInstance();
	List<B_CityDTO> b_cityList = b_city.callBcity();
	
%>
<meta charset="UTF-8">
<meta name=viewport content="width=device-width", initial-scale="1"> 
<title>Insert title here</title>
<link rel="stylesheet" href="../css/bootstrap.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script type= "text/javascript">
		function itemChange() {
			var select = $('#select1').val();
			$.ajax({
				type: 'POST',
				url: 'test2.jsp',
				data: { b_citynum: select},
				success: function(result) {
					const objs = JSON.parse(result);
					console.log(objs);
					
					$('#select2').empty();
					
					for(name in objs) {
						var option = $("<option>" + objs[name] + "</option>");
						$('#select2').append(option);
					}
					
				}
			})
		}
	</script>
</head>
<%
	
	

%>
<body>
	<select id="select1" onchange="itemChange()">
		<option>선택</option>
		<%for(int i =0; i < b_cityList.size();i++) {
			B_CityDTO dto = b_cityList.get(i);%>
			<option value="<%=dto.getCity_num()%>"><%=dto.getCity_name() %></option>
	    <%}%>
	</select>
	<select id="select2">
		<option>선택</option>
	</select>
</body>


</html>



