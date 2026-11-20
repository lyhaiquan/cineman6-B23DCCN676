package model;

import java.util.Date;

/** Lop thuc the Customer6 - Hinh 15 + Hinh 16 (hop), Hinh 23. */
public class Customer6 extends Person6 {

	private String customerCode;
	private Date registeredDate;
	private int points;
	private MembershipRank6 rank;

	public Customer6() {
		super();
	}

	public String getCustomerCode() {
		return customerCode;
	}

	public void setCustomerCode(String customerCode) {
		this.customerCode = customerCode;
	}

	public Date getRegisteredDate() {
		return registeredDate;
	}

	public void setRegisteredDate(Date registeredDate) {
		this.registeredDate = registeredDate;
	}

	public int getPoints() {
		return points;
	}

	public void setPoints(int points) {
		this.points = points;
	}

	public MembershipRank6 getRank() {
		return rank;
	}

	public void setRank(MembershipRank6 rank) {
		this.rank = rank;
	}
}
