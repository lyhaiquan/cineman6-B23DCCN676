package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Lop DAO6 - Hinh 15, Hinh 16 (gia dinh A19): giu mot ket noi dung chung con.
 * Thong tin ket noi doc tu bien moi truong CINEMAN6_DB_URL, CINEMAN6_DB_USER,
 * CINEMAN6_DB_PASS; khong co mat khau nao nam trong ma nguon.
 */
public abstract class DAO6 {

	protected static Connection con;

	public DAO6() {
		if (con == null) {
			String url = System.getenv("CINEMAN6_DB_URL");
			if (url == null || url.isEmpty()) {
				url = "jdbc:mysql://localhost:3306/cineman6?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8";
			}
			String user = System.getenv("CINEMAN6_DB_USER");
			if (user == null || user.isEmpty()) {
				user = "root";
			}
			String pass = System.getenv("CINEMAN6_DB_PASS");
			if (pass == null) {
				pass = "";
			}
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				con = DriverManager.getConnection(url, user, pass);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
