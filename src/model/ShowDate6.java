package model;

import java.util.Date;

/** Lop thuc the ShowDate6 - Hinh 16, Hinh 23. */
public class ShowDate6 {

	private int id;
	private Date showDate;
	private String dayOfWeek;
	private boolean isHoliday;
	private float priceFactor;

	public ShowDate6() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Date getShowDate() {
		return showDate;
	}

	public void setShowDate(Date showDate) {
		this.showDate = showDate;
	}

	public String getDayOfWeek() {
		return dayOfWeek;
	}

	public void setDayOfWeek(String dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}

	public boolean isIsHoliday() {
		return isHoliday;
	}

	public void setIsHoliday(boolean isHoliday) {
		this.isHoliday = isHoliday;
	}

	public float getPriceFactor() {
		return priceFactor;
	}

	public void setPriceFactor(float priceFactor) {
		this.priceFactor = priceFactor;
	}
}
