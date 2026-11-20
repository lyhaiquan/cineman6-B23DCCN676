package model;

/** Lop thuc the ShowtimeStatistic6 - Hinh 16, Hinh 23. */
public class ShowtimeStatistic6 extends Showtime6 {

	private int totalInvoices;
	private int totalTicketsSold;
	private float occupancyRate;
	private long revenue;

	public ShowtimeStatistic6() {
		super();
	}

	public int getTotalInvoices() {
		return totalInvoices;
	}

	public void setTotalInvoices(int totalInvoices) {
		this.totalInvoices = totalInvoices;
	}

	public int getTotalTicketsSold() {
		return totalTicketsSold;
	}

	public void setTotalTicketsSold(int totalTicketsSold) {
		this.totalTicketsSold = totalTicketsSold;
	}

	public float getOccupancyRate() {
		return occupancyRate;
	}

	public void setOccupancyRate(float occupancyRate) {
		this.occupancyRate = occupancyRate;
	}

	public long getRevenue() {
		return revenue;
	}

	public void setRevenue(long revenue) {
		this.revenue = revenue;
	}
}
