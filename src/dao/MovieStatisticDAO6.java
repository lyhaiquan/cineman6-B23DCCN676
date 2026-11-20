package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import model.MovieStatistic6;

/**
 * Lop MovieStatisticDAO6 - Hinh 16, tang truy xuat du lieu, ke thua DAO6.
 * Lop thong ke khong co bang rieng (gia dinh A21): so lieu tinh trong stored
 * procedure tkPhimTheoDoanhthu6 (gia dinh A22), loc theo ngay chieu (A13).
 * Kieu tra ve MovieStatistic6[] cua Hinh 16 cai dat bang ArrayList<MovieStatistic6>
 * (cung quy uoc X[] -> ArrayList<X> nhu Invoice6.listTicket).
 * Ung voi buoc 9 den buoc 14 cua kich ban v.3 modul 2.
 */
public class MovieStatisticDAO6 extends DAO6 {

	public MovieStatisticDAO6() {
		super();
	}

	/**
	 * buoc 10: thong ke doanh thu tung phim trong khoang [startDate, endDate].
	 *
	 * @return danh sach xep doanh thu giam dan; danh sach rong neu khong co
	 *         phim nao phat sinh doanh thu (ngoai le 14a / 6a)
	 */
	public ArrayList<MovieStatistic6> getMovieRevenueStat(Date startDate, Date endDate) {
		ArrayList<MovieStatistic6> kq = new ArrayList<MovieStatistic6>();
		String sql = "{call tkPhimTheoDoanhthu6(?,?)}";
		try (CallableStatement cs = con.prepareCall(sql)) {
			cs.setDate(1, new java.sql.Date(startDate.getTime()));
			cs.setDate(2, new java.sql.Date(endDate.getTime()));
			try (ResultSet rs = cs.executeQuery()) {
				while (rs.next()) {
					// buoc 11-13: dong goi thuc the MovieStatistic6
					MovieStatistic6 ms = new MovieStatistic6();
					ms.setId(rs.getInt("id"));
					ms.setTitle(rs.getString("title"));
					ms.setDirector(rs.getString("director"));
					ms.setDuration(rs.getInt("duration"));
					ms.setAgeRating(rs.getString("agerating"));
					ms.setStatus(rs.getString("status"));
					ms.setStartDate(startDate);
					ms.setEndDate(endDate);
					ms.setTotalShowtimes(rs.getInt("totalshowtimes"));
					ms.setTotalTicketsSold(rs.getInt("totalticketssold"));
					ms.setTotalRevenue(rs.getLong("totalrevenue"));
					kq.add(ms);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// buoc 14: tra danh sach cho gdMovieRevenueStat6.jsp
		return kq;
	}
}
