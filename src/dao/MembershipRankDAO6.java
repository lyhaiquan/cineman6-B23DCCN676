package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;

import model.MembershipRank6;

/**
 * Lop MembershipRankDAO6 - Hinh 15, tang truy xuat du lieu. Ke thua DAO6.
 * Mot phuong thuc dung Hinh 15: getDefaultRank - buoc 11 kich ban v.3.
 */
public class MembershipRankDAO6 extends DAO6 {

	public MembershipRankDAO6() {
		super();
	}

	/**
	 * buoc 11: lay hang thanh vien mac dinh - hang co minPoints nho nhat,
	 * tuc hang "Thuong" (gia dinh A16), qua procedure hangMacdinh6.
	 *
	 * @return doi tuong MembershipRank6, null neu loi hoac bang hang rong
	 */
	public MembershipRank6 getDefaultRank() {
		MembershipRank6 kq = null;
		try (CallableStatement cs = con.prepareCall("{call hangMacdinh6()}");
				ResultSet rs = cs.executeQuery()) {
			if (rs.next()) {
				// buoc 12: goi lop MembershipRank6 de dong goi thong tin
				// buoc 13: MembershipRank6() dong goi thuc the
				kq = new MembershipRank6();
				kq.setId(rs.getInt("id"));
				kq.setName(rs.getString("name"));
				kq.setMinPoints(rs.getInt("minpoints"));
				kq.setDiscountRate(rs.getFloat("discountrate"));
				kq.setDescription(rs.getString("description"));
				// buoc 14: MembershipRank6 tra doi tuong cho getDefaultRank()
			}
		} catch (Exception e) {
			e.printStackTrace();
			kq = null;
		}
		// buoc 15: tra hang "Thuong" cho doRegister6.jsp
		return kq;
	}
}
