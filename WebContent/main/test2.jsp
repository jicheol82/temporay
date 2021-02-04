<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="woodley.main.scity.S_CityDTO"%>
<%@page import="java.util.List"%>
<%@page import="woodley.main.scity.S_CityDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String str = request.getParameter("b_citynum");
	int b_citynum = Integer.parseInt(str);
	S_CityDAO s_cityDAO = S_CityDAO.getInstance();
	List goolist = s_cityDAO.getCities(b_citynum);
	
	
	JSONObject json = new JSONObject();
	JSONArray arrjson = new JSONArray();
	for(int i =0;i < goolist.size();i++) {
		S_CityDTO dto = (S_CityDTO)goolist.get(i);
		json.put(i, dto.getS_cityName());
	}
	response.getWriter().write(json.toJSONString());
%>
