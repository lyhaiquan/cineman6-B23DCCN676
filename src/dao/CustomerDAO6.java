package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Types;

import model.Customer6;

/**
 * Lop CustomerDAO6 - Hinh 15, tang truy xuat du lieu. Ke thua DAO6 nen dung
 * chung ket noi con. Hai phuong thuc dung ten, tham so, kieu tra ve cua Hinh 15:
 *   checkExistedAccount - buoc 8 kich ban v.3 (ngoai le 9a)
 *   addCustomer         - buoc 20 kich ban v.3 (ngoai le 21a)
 */
public class CustomerDAO6 extends DAO6 {

	public CustomerDAO6() {
		super();
	}

	/**
	 * buoc 8: kiem tra so dien thoai hoac email da duoc dung chua
	 * (procedure kiemtraTonTai6).
	 *
	 * @return true neu da ton tai. Loi CSDL tra ve false: cac rang buoc UNIQUE
	 *         cua tblperson6 khien addCustomer tra 0, trang bao "he thong dang
	 *         ban" (21a) thay vi bao nham "da duoc dang ki" (9a).
	 */
	public boolean checkExistedAccount(String phone, String email) {
		boolean kq = false;
		try (CallableStatement cs = con.prepareCall("{call kiemtraTonTai6(?,?)}")) {
			cs.setString(1, phone);
			cs.setString(2, email);
			try (ResultSet rs = cs.executeQuery()) {
				if (rs.next()) {
					kq = rs.getInt("soluong") > 0;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			kq = false;
		}
		// buoc 9: tra ket qua cho doRegister6.jsp
		return kq;
	}

	/**
	 * buoc 20: luu khach hang moi (procedure themKhachhang6, 15 IN + 1 OUT),
	 * ghi bon bang tblfullname6, tbladdress6, tblperson6, tblcustomer6 trong
	 * mot giao dich.
	 *
	 * @return id khach hang vua them, 0 neu that bai (ngoai le 21a)
	 */
	public int addCustomer(Customer6 cus) {
		int kq = 0;
		try (CallableStatement cs = con.prepareCall(
				"{call themKhachhang6(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}")) {
			cs.setString(1, cus.getUsername());
			cs.setString(2, cus.getPassword());
			cs.setDate(3, new java.sql.Date(cus.getDateOfBirth().getTime()));
			cs.setString(4, cus.getPhone());
			cs.setString(5, cus.getEmail());
			cs.setString(6, cus.getFullName().getFirstName());
			cs.setString(7, cus.getFullName().getMiddleName());
			cs.setString(8, cus.getFullName().getLastName());
			cs.setString(9, cus.getAddress().getStreet());
			cs.setString(10, cus.getAddress().getWard());
			cs.setString(11, cus.getAddress().getDistrict());
			cs.setString(12, cus.getAddress().getCity());
			cs.setString(13, cus.getCustomerCode());
			cs.setInt(14, cus.getRank().getId());
			cs.setString(15, cus.getStatus());
			cs.registerOutParameter(16, Types.INTEGER);
			cs.execute();
			kq = cs.getInt(16);
		} catch (Exception e) {
			e.printStackTrace();
			kq = 0;
		}
		// buoc 21: tra ket qua cho doRegister6.jsp
		return kq;
	}
}
