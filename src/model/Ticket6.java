package model;

import java.util.Date;

/** Lop thuc the Ticket6 - Hinh 16, Hinh 23. */
public class Ticket6 {

	private int id;
	private String ticketCode;
	private long price;
	private String status;
	private Date issuedAt;
	private Showtime6 showtime;

	public Ticket6() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTicketCode() {
		return ticketCode;
	}

	public void setTicketCode(String ticketCode) {
		this.ticketCode = ticketCode;
	}

	public long getPrice() {
		return price;
	}

	public void setPrice(long price) {
		this.price = price;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getIssuedAt() {
		return issuedAt;
	}

	public void setIssuedAt(Date issuedAt) {
		this.issuedAt = issuedAt;
	}

	public Showtime6 getShowtime() {
		return showtime;
	}

	public void setShowtime(Showtime6 showtime) {
		this.showtime = showtime;
	}
}
