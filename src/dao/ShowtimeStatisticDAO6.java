package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import model.Movie6;
import model.ScreeningRoom6;
import model.ShowFormat6;
import model.ShowtimeStatistic6;
import model.TimeSlot6;

/**
 * Lop ShowtimeStatisticDAO6 - Hinh 16, ke thua DAO6.
 * Goi stored procedure tkSuatchieuCuaPhim6; van loc theo khoang ngay chieu da
 * chon o muc phim (gia dinh A13, A20).
 * Kieu tra ve ShowtimeStatistic6[] cai dat bang ArrayList<ShowtimeStatistic6>.
 * Ung voi buoc 18 den buoc 23 cua kich ban v.3 modul 2.
 */
public class ShowtimeStatisticDAO6 extends DAO6 {

	public ShowtimeStatisticDAO6() {
		super();
	}

	/**
	 * buoc 19: thong ke cac suat chieu cua mot phim trong khoang thoi gian.
	 *
	 * @return danh sach xep theo gio bat dau; danh sach rong neu phim khong co
	 *         suat chieu nao trong khoang (ngoai le 23a)
	 */
	public ArrayList<ShowtimeStatistic6> getShowtimeStatOfMovie(int idMovie, Date startDate,
			Date endDate) {
		ArrayList<ShowtimeStatistic6> kq = new ArrayList<ShowtimeStatistic6>();
		String sql = "{call tkSuatchieuCuaPhim6(?,?,?)}";
		try (CallableStatement cs = con.prepareCall(sql)) {
			cs.setInt(1, idMovie);
			cs.setDate(2, new java.sql.Date(startDate.getTime()));
			cs.setDate(3, new java.sql.Date(endDate.getTime()));
			try (ResultSet rs = cs.executeQuery()) {
				while (rs.next()) {
					// buoc 20-22: dong goi thuc the ShowtimeStatistic6
					ShowtimeStatistic6 ss = new ShowtimeStatistic6();
					ss.setId(rs.getInt("id"));
					ss.setShowtimeCode(rs.getString("showtimecode"));
					ss.setStartTime(rs.getTimestamp("starttime"));
					ss.setEndTime(rs.getTimestamp("endtime"));
					ss.setBasePrice(rs.getLong("baseprice"));
					ss.setStatus(rs.getString("status"));

					Movie6 m = new Movie6();
					m.setId(idMovie);
					m.setTitle(rs.getString("movietitle"));
					ss.setMovie(m);

					ScreeningRoom6 r = new ScreeningRoom6();
					r.setId(rs.getInt("roomid"));
					r.setName(rs.getString("roomname"));
					r.setCapacity(rs.getInt("capacity"));
					ss.setRoom(r);

					TimeSlot6 ts = new TimeSlot6();
					ts.setId(rs.getInt("timeslotid"));
					ts.setName(rs.getString("timeslotname"));
					ss.setTimeSlot(ts);

					ShowFormat6 sf = new ShowFormat6();
					sf.setId(rs.getInt("formatid"));
					sf.setName(rs.getString("formatname"));
					ss.setFormat(sf);

					ss.setTotalInvoices(rs.getInt("totalinvoices"));
					ss.setTotalTicketsSold(rs.getInt("totalticketssold"));
					ss.setOccupancyRate(rs.getFloat("occupancyrate"));
					ss.setRevenue(rs.getLong("revenue"));
					kq.add(ss);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// buoc 23: tra danh sach cho gdShowtimeStat6.jsp
		return kq;
	}
}
