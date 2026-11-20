package model;

/** Lop thuc the TimeSlot6 - Hinh 16, Hinh 23. */
public class TimeSlot6 {

	private int id;
	private String name;
	private int startHour;
	private int endHour;
	private float priceFactor;

	public TimeSlot6() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getStartHour() {
		return startHour;
	}

	public void setStartHour(int startHour) {
		this.startHour = startHour;
	}

	public int getEndHour() {
		return endHour;
	}

	public void setEndHour(int endHour) {
		this.endHour = endHour;
	}

	public float getPriceFactor() {
		return priceFactor;
	}

	public void setPriceFactor(float priceFactor) {
		this.priceFactor = priceFactor;
	}
}
