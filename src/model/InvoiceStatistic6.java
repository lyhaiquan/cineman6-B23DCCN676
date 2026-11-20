package model;

/** Lop thuc the InvoiceStatistic6 - Hinh 16, Hinh 23. */
public class InvoiceStatistic6 extends Invoice6 {

	private int ticketCount;
	private long revenue;

	public InvoiceStatistic6() {
		super();
	}

	public int getTicketCount() {
		return ticketCount;
	}

	public void setTicketCount(int ticketCount) {
		this.ticketCount = ticketCount;
	}

	public long getRevenue() {
		return revenue;
	}

	public void setRevenue(long revenue) {
		this.revenue = revenue;
	}
}
