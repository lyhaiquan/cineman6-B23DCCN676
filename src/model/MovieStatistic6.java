package model;

import java.util.Date;

/** Lop thuc the MovieStatistic6 - Hinh 16, Hinh 23. */
public class MovieStatistic6 extends Movie6 {

	private Date startDate;
	private Date endDate;
	private int totalShowtimes;
	private int totalTicketsSold;
	private long totalRevenue;

	public MovieStatistic6() {
		super();
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public int getTotalShowtimes() {
		return totalShowtimes;
	}

	public void setTotalShowtimes(int totalShowtimes) {
		this.totalShowtimes = totalShowtimes;
	}

	public int getTotalTicketsSold() {
		return totalTicketsSold;
	}

	public void setTotalTicketsSold(int totalTicketsSold) {
		this.totalTicketsSold = totalTicketsSold;
	}

	public long getTotalRevenue() {
		return totalRevenue;
	}

	public void setTotalRevenue(long totalRevenue) {
		this.totalRevenue = totalRevenue;
	}
}
