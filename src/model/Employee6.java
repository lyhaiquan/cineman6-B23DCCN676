package model;

import java.util.Date;

/** Lop thuc the Employee6 - Hinh 16, Hinh 23. */
public abstract class Employee6 extends Person6 {

	private String employeeCode;
	private String position;
	private Date hireDate;

	public Employee6() {
		super();
	}

	public String getEmployeeCode() {
		return employeeCode;
	}

	public void setEmployeeCode(String employeeCode) {
		this.employeeCode = employeeCode;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Date getHireDate() {
		return hireDate;
	}

	public void setHireDate(Date hireDate) {
		this.hireDate = hireDate;
	}
}
