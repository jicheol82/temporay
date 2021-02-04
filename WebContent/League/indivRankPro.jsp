<%@page import="java.util.List"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="woodley.football.league.F_Per_RecordDAO"%>
<%@page import="woodley.football.league.F_Per_RecordDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	String sClub_num = request.getParameter("club_num");
	String pageNum = request.getParameter("page_num");
	if(pageNum == null) {
		pageNum = "1";
	}
	int currPage = Integer.parseInt(pageNum);
	int pageSize = 1;
	int startRow = (currPage -1) * pageSize +1; 
	int endRow = currPage * pageSize;			
	
	int count = 0;
	String[] club = sClub_num.split(",");
	F_Per_RecordDAO perdao = F_Per_RecordDAO.getInstance(); 
	
	int League_num = Integer.parseInt(club[0]);
	int club_num = Integer.parseInt(club[1]);
	
	List<F_Per_RecordDTO> perList = null;
	JSONArray arrjson = new JSONArray();
	
	if(club.length == 2) {
		perList = perdao.getPerRecord(League_num, club_num, startRow, endRow);
		count = perdao.teamCount(League_num, club_num);
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int pageBlock = 5;
		int startPage = (int)((currPage - 1)/pageBlock) * pageBlock + 1;
		int endPage = startPage + pageBlock - 1;
		if(endPage > pageCount) endPage = pageCount;
		
		for(int i = 0; i < perList.size();i++) {
			F_Per_RecordDTO dto = perList.get(i);
			JSONObject json = new JSONObject();
			json.put("ranked", dto.getRanked());
			json.put("name", dto.getName());
			json.put("tname", dto.getTname());
			json.put("goals", dto.getGoals());
			json.put("assist", dto.getAssist());
			json.put("played", dto.getPlayed());
			json.put("league_num" , dto.getLeague_num());
			json.put("club_num", dto.getClub_num());
			json.put("profile", dto.getProfile());
			
			arrjson.add(i, json);
		}
			
			JSONObject json = new JSONObject();
			json.put("pageCount", pageCount);
			json.put("pageBlock", pageBlock);
			json.put("startRow", startRow);
			json.put("endRow", endRow);
			json.put("startPage", startPage);
			json.put("endPage", endPage);
			json.put("pageSize", pageSize);
			arrjson.add(json);
		
		
	}else {
		perList = perdao.getPerRecord(League_num,startRow,endRow);
		for(int i = 0; i < perList.size();i++) {
			F_Per_RecordDTO dto = perList.get(i);
			JSONObject json = new JSONObject();
			json.put("ranked", dto.getRanked());
			json.put("name", dto.getName());
			json.put("tname", dto.getTname());
			json.put("goals", dto.getGoals());
			json.put("assist", dto.getAssist());
			json.put("played", dto.getPlayed());
			json.put("league_num" , dto.getLeague_num());
			json.put("club_num", dto.getClub_num());
			json.put("profile", dto.getProfile());
			arrjson.add(i, json);
		}
			count = perdao.allCount(League_num);
			int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			int pageBlock = 5;
			int startPage = (int)((currPage - 1)/pageBlock) * pageBlock + 1;
			int endPage = startPage + pageBlock - 1;
			if(endPage > pageCount) endPage = pageCount;
			JSONObject json = new JSONObject();
			json.put("pageCount", pageCount);
			json.put("pageBlock", pageBlock);
			json.put("startRow", startRow);
			json.put("endRow", endRow);
			json.put("startPage", startPage);
			json.put("endPage", endPage);
			json.put("pageSize", pageSize);
			arrjson.add(json);
	}
		
		
	response.getWriter().write(arrjson.toJSONString());
%>
	
	
	
	
	
