package model;

import java.util.ArrayList;
import java.util.Date;

/** Lop thuc the Invoice6 - Hinh 16, Hinh 23. Thuoc tinh X[] cua so do duoc cai dat bang ArrayList<X>. */
public class Invoice6 {

	private int id;
	private String invoiceNo;
	private Date createdAt;
	private long totalAmount;
	private long discountAmount;
	private long finalAmount;
	private String status;
	private Showtime6 showtime;
	private SalesChannel6 channel;
	private Customer6 customer;
	private Salesperson6 salesperson;
	private ArrayList<Ticket6> listTicket;

	public Invoice6() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getInvoiceNo() {
		return invoiceNo;
	}

	public void setInvoiceNo(String invoiceNo) {
		this.invoiceNo = invoiceNo;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public long getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(long totalAmount) {
		this.totalAmount = totalAmount;
	}

	public long getDiscountAmount() {
		return discountAmount;
	}

	public void setDiscountAmount(long discountAmount) {
		this.discountAmount = discountAmount;
	}

	public long getFinalAmount() {
		return finalAmount;
	}

	public void setFinalAmount(long finalAmount) {
		this.finalAmount = finalAmount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Showtime6 getShowtime() {
		return showtime;
	}

	public void setShowtime(Showtime6 showtime) {
		this.showtime = showtime;
	}

	public SalesChannel6 getChannel() {
		return channel;
	}

	public void setChannel(SalesChannel6 channel) {
		this.channel = channel;
	}

	public Customer6 getCustomer() {
		return customer;
	}

	public void setCustomer(Customer6 customer) {
		this.customer = customer;
	}

	public Salesperson6 getSalesperson() {
		return salesperson;
	}

	public void setSalesperson(Salesperson6 salesperson) {
		this.salesperson = salesperson;
	}

	public ArrayList<Ticket6> getListTicket() {
		return listTicket;
	}

	public void setListTicket(ArrayList<Ticket6> listTicket) {
		this.listTicket = listTicket;
	}
}
