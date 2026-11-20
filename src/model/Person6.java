package model;

import java.util.Date;

/** Lop thuc the Person6 - Hinh 15 + Hinh 16 (hop), Hinh 23. */
public abstract class Person6 {

	/*
	 * Ba gia tri hop le cua status (gia dinh A25), khop kieu
	 * ENUM('ACTIVE','LOCKED','INACTIVE') cua cot tblperson6.status.
	 */
	public static final String STATUS_ACTIVE = "ACTIVE";
	public static final String STATUS_LOCKED = "LOCKED";
	public static final String STATUS_INACTIVE = "INACTIVE";

	private int id;
	private String username;
	private String password;
	private Date dateOfBirth;
	private String phone;
	private String email;
	private String status;
	private String note;
	private FullName6 fullName;
	private Address6 address;

	public Person6() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Date getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public FullName6 getFullName() {
		return fullName;
	}

	public void setFullName(FullName6 fullName) {
		this.fullName = fullName;
	}

	public Address6 getAddress() {
		return address;
	}

	public void setAddress(Address6 address) {
		this.address = address;
	}
}
