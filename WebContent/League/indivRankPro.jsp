<%@page import="java.util.List"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="woodley.football.league.F_Per_RecordDAO"%>
<%@page import="woodley.football.league.F_Per_RecordDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	// ajax 로 넘어온 데이터들 처리하는 페이지
	request.setCharacterEncoding("UTF-8");
	String sClub_num = request.getParameter("club_num"); // 리퀘스트로 ajax로 넘어온데이터 받기
	String pageNum = request.getParameter("page_num"); // 상동
	if(pageNum == null) {
		pageNum = "1";
	}
	int currPage = Integer.parseInt(pageNum);
	int pageSize = 5;
	int startRow = (currPage -1) * pageSize +1; 
	int endRow = currPage * pageSize;			
	
	int count = 0;
	String[] club = sClub_num.split(","); // 스트링 배열에다가 ajax로 넘어온데이터 콤마구분해서 짤라서 넣기
	F_Per_RecordDAO perdao = F_Per_RecordDAO.getInstance(); 
	
	int League_num = Integer.parseInt(club[0]); // 처음에 넘어온 데이터가 리그넘이므로 첫번째 인덱스값넣기
	int club_num = Integer.parseInt(club[1]); // 2번째가 클럽넘이므로 클럽넘 넣기
	
	List<F_Per_RecordDTO> perList = null; // 개인기록 리스트 일단 널로 생성
	JSONArray arrjson = new JSONArray(); // JSON 객체배열 생성 외부라이브러리 있어야 생성가능	
	if(club.length == 2) { // 클럽랭쓰가 2이면 전체팀이 아닌 한개팀 데이터이므로 여기서 객체처리
		perList = perdao.getPerRecord(League_num, club_num, startRow, endRow); // 개인기록 리스트 디비에서 가져옴
		for(int i =0; i < perList.size();i++) {
			
			String profile = perdao.getProfile(perList.get(i).getName(), perList.get(i).getClub_num());
			
			perList.get(i).setProfile(profile);
		}
		count = perdao.teamCount(League_num, club_num); 
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		int pageBlock = 5;
		int startPage = (int)((currPage - 1)/pageBlock) * pageBlock + 1;
		int endPage = startPage + pageBlock - 1;
		if(endPage > pageCount) endPage = pageCount;
		
		for(int i = 0; i < perList.size();i++) { // 개인기록 리스트만큼 포문돌려서 json 형태로 담기
			F_Per_RecordDTO dto = perList.get(i);
			JSONObject json = new JSONObject();
			json.put("ranked", dto.getRanked()); // json 형태의 자바의해쉬맵과 비슷한 형태로 담기
			json.put("name", dto.getName());
			json.put("tname", dto.getTname());
			json.put("goals", dto.getGoals());
			json.put("assist", dto.getAssist());
			json.put("played", dto.getPlayed());
			json.put("league_num" , dto.getLeague_num());
			json.put("club_num", dto.getClub_num());
			json.put("profile", dto.getProfile());
			
			arrjson.add(i, json); // 제이슨 객체배열에 생성된 제이슨 객체 하나씩 넣기
		}
			
			JSONObject json = new JSONObject(); // 여기는 페이징 관련데이터들 객체배열 맨뒤에 담아서 자바스크립트에서 뒷꽁무니 짜름
			json.put("pageCount", pageCount);
			json.put("pageBlock", pageBlock);
			json.put("startRow", startRow);
			json.put("endRow", endRow);
			json.put("startPage", startPage);
			json.put("endPage", endPage);
			json.put("pageSize", pageSize);
			arrjson.add(json);
		
		
	}else { // 배열값 2 이상이면 전체선수목록이므로 전체 데이터 담는다
		perList = perdao.getPerRecord(League_num,startRow,endRow);
		for(int i =0; i < perList.size();i++) {
			
			String profile = perdao.getProfile(perList.get(i).getName(), perList.get(i).getClub_num());
			
			perList.get(i).setProfile(profile);
		}
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
		
		
	response.getWriter().write(arrjson.toJSONString()); // 제이슨형태로 뷰쪽에 다시보내줌
%>
	
	
	
	
	
