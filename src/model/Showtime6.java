package model;

import java.util.Date;

/** Lop thuc the Showtime6 - Hinh 16, Hinh 23. */
public class Showtime6 {

	private int id;
	private String showtimeCode;
	private Date startTime;
	private Date endTime;
	private long basePrice;
	private String status;
	private Movie6 movie;
	private ScreeningRoom6 room;
	private ShowDate6 showDate;
	private TimeSlot6 timeSlot;
	private ShowFormat6 format;

	public Showtime6() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getShowtimeCode() {
		return showtimeCode;
	}

	public void setShowtimeCode(String showtimeCode) {
		this.showtimeCode = showtimeCode;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public long getBasePrice() {
		return basePrice;
	}

	public void setBasePrice(long basePrice) {
		this.basePrice = basePrice;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Movie6 getMovie() {
		return movie;
	}

	public void setMovie(Movie6 movie) {
		this.movie = movie;
	}

	public ScreeningRoom6 getRoom() {
		return room;
	}

	public void setRoom(ScreeningRoom6 room) {
		this.room = room;
	}

	public ShowDate6 getShowDate() {
		return showDate;
	}

	public void setShowDate(ShowDate6 showDate) {
		this.showDate = showDate;
	}

	public TimeSlot6 getTimeSlot() {
		return timeSlot;
	}

	public void setTimeSlot(TimeSlot6 timeSlot) {
		this.timeSlot = timeSlot;
	}

	public ShowFormat6 getFormat() {
		return format;
	}

	public void setFormat(ShowFormat6 format) {
		this.format = format;
	}
}
