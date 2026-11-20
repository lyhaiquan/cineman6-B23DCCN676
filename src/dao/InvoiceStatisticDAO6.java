package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Customer6;
import model.FullName6;
import model.InvoiceStatistic6;
import model.SalesChannel6;
import model.Salesperson6;

/**
 * Lop InvoiceStatisticDAO6 - Hinh 16, ke thua DAO6.
 * Goi stored procedure tkHoadonCuaSuatchieu6. Hoa don co the khong gan khach
 * hang (khach vang lai) va khong gan nhan vien (hoa don truc tuyen) - gia dinh A9.
 * Kieu tra ve InvoiceStatistic6[] cai dat bang ArrayList<InvoiceStatistic6>.
 * Ung voi buoc 27 den buoc 32 cua kich ban v.3 modul 2.
 */
public class InvoiceStatisticDAO6 extends DAO6 {

	public InvoiceStatisticDAO6() {
		super();
	}

	/**
	 * buoc 28: thong ke cac hoa don ban ve cua mot suat chieu.
	 *
	 * @return danh sach xep theo thoi diem lap; danh sach rong neu suat chieu
	 *         chua co hoa don (ngoai le 32a / 10a)
	 */
	public ArrayList<InvoiceStatistic6> getInvoiceStatOfShowtime(int idShowtime) {
		ArrayList<InvoiceStatistic6> kq = new ArrayList<InvoiceStatistic6>();
		String sql = "{call tkHoadonCuaSuatchieu6(?)}";
		try (CallableStatement cs = con.prepareCall(sql)) {
			cs.setInt(1, idShowtime);
			try (ResultSet rs = cs.executeQuery()) {
				while (rs.next()) {
					// buoc 29-31: dong goi thuc the InvoiceStatistic6
					InvoiceStatistic6 is = new InvoiceStatistic6();
					is.setId(rs.getInt("id"));
					is.setInvoiceNo(rs.getString("invoiceno"));
					is.setCreatedAt(rs.getTimestamp("createdat"));
					is.setTotalAmount(rs.getLong("totalamount"));
					is.setDiscountAmount(rs.getLong("discountamount"));
					is.setFinalAmount(rs.getLong("finalamount"));
					is.setStatus(rs.getString("status"));

					SalesChannel6 ch = new SalesChannel6();
					ch.setId(rs.getInt("channelid"));
					ch.setName(rs.getString("channelname"));
					is.setChannel(ch);

					// khach hang: null = khach vang lai
					int idCus = rs.getInt("customerid");
					if (!rs.wasNull()) {
						Customer6 c = new Customer6();
						c.setId(idCus);
						c.setCustomerCode(rs.getString("customercode"));
						FullName6 fn = new FullName6();
						fn.setFirstName(rs.getString("firstname"));
						fn.setMiddleName(rs.getString("middlename"));
						fn.setLastName(rs.getString("lastname"));
						c.setFullName(fn);
						is.setCustomer(c);
					}

					// nhan vien lap: null = hoa don truc tuyen
					int idSp = rs.getInt("salespersonid");
					if (!rs.wasNull()) {
						Salesperson6 sp = new Salesperson6();
						sp.setId(idSp);
						sp.setEmployeeCode(rs.getString("salespersoncode"));
						FullName6 sfn = new FullName6();
						sfn.setFirstName(rs.getString("spfirstname"));
						sfn.setMiddleName(rs.getString("spmiddlename"));
						sfn.setLastName(rs.getString("splastname"));
						sp.setFullName(sfn);
						is.setSalesperson(sp);
					}

					is.setTicketCount(rs.getInt("ticketcount"));
					is.setRevenue(rs.getLong("revenue"));
					kq.add(is);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// buoc 32: tra danh sach cho gdInvoiceStat6.jsp
		return kq;
	}
}
