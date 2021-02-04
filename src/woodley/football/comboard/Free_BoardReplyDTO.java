package woodley.football.comboard;

import java.sql.Timestamp;

public class Free_BoardReplyDTO {
	private Integer free_board_reply_num;
	private Integer ref;
	private Integer ref_num;
	private Integer ref_step;
	private String replyto;
	private String writer;
	private String content;
	private Timestamp reg;
	public Integer getFree_board_reply_num() {
		return free_board_reply_num;
	}
	public void setFree_board_reply_num(Integer free_board_reply_num) {
		this.free_board_reply_num = free_board_reply_num;
	}
	public Integer getRef() {
		return ref;
	}
	public void setRef(Integer ref) {
		this.ref = ref;
	}
	public Integer getRef_num() {
		return ref_num;
	}
	public void setRef_num(Integer ref_num) {
		this.ref_num = ref_num;
	}
	public Integer getRef_step() {
		return ref_step;
	}
	public void setRef_step(Integer ref_step) {
		this.ref_step = ref_step;
	}
	public String getReplyto() {
		return replyto;
	}
	public void setReplyto(String replyto) {
		this.replyto = replyto;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	
	
	


}
