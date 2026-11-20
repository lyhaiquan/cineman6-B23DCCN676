<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,model.*"%>
<%--
  gdRegisterMember6.jsp - Hinh 15: inFullName, inDateOfBirth, inPhone, inEmail,
  inAddress, inPassword, inConfirmPassword, subRegister, subCancel, outError,
  cus : Customer6. Buoc 3 - 6 cua kich ban v.3, ngoai le 5a (dinh dang),
  5b (duoi 13 tuoi); hien lai kem outError o ngoai le 9a, 21a.
--%>
<%
	// cus : Customer6 - phien da co thanh vien thi khong dang ki lan hai (tien dieu kien)
	Customer6 cus = (Customer6) session.getAttribute("khachhang");
	if (cus != null) {
		response.sendRedirect(request.getContextPath() + "/khachhang/gdCustomerHome6.jsp");
		return;
	}

	// Ngoai le 9a, 21a: doRegister6.jsp forward ve kem thong bao (thuoc tinh "outError")
	// va giu nguyen du lieu da nhap (tham so cua bieu mau). Hai o mat khau khong dien lai.
	String[] oNhap = {"inFullName", "inDateOfBirth", "inPhone", "inEmail", "inAddress"};
	Map<String, String> giaTri = new HashMap<String, String>();
	for (int i = 0; i < oNhap.length; i++) {
		String v = request.getParameter(oNhap[i]);
		v = (v == null) ? "" : v.replace("&", "&amp;").replace("\"", "&quot;")
				.replace("<", "&lt;").replace(">", "&gt;");
		giaTri.put(oNhap[i], v);
	}
	Object loi = request.getAttribute("outError");
	String outError = (loi == null) ? "" : loi.toString().replace("&", "&amp;")
			.replace("<", "&lt;").replace(">", "&gt;");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng kí thành viên</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css?v=2">
<script type="text/javascript">
var daHuy = false;   // true khi khach hang click subCancel

// buoc 5: kiem tra dinh dang cac o (Bang 1) ngay tren trinh duyet
function kiemtraDinhdang() {
	if (daHuy) { return true; }   // ngoai le 2a: Huy thi khong kiem tra, khong luu
	var f = document.forms["frmRegister"];
	var batBuoc = ["inFullName", "inDateOfBirth", "inPhone", "inEmail",
	               "inPassword", "inConfirmPassword"];
	for (var i = 0; i < batBuoc.length; i++) {
		if (f[batBuoc[i]].value.trim() === "") {
			return baoLoi(f[batBuoc[i]], "Vui lòng nhập đủ các ô có dấu (*).");
		}
	}
	if (f["inFullName"].value.trim().length > 60) {
		return baoLoi(f["inFullName"], "Họ và tên tối đa 60 kí tự.");
	}
	if (!/^\d{10}$/.test(f["inPhone"].value.trim())) {
		return baoLoi(f["inPhone"], "Số điện thoại phải gồm 10 chữ số.");
	}
	if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(f["inEmail"].value.trim())) {
		return baoLoi(f["inEmail"], "Email không đúng định dạng.");
	}
	if (!/^(?=.*[A-Za-z])(?=.*\d).{8,}$/.test(f["inPassword"].value)) {
		return baoLoi(f["inPassword"], "Mật khẩu tối thiểu 8 kí tự, có cả chữ và số.");
	}
	if (f["inPassword"].value !== f["inConfirmPassword"].value) {
		return baoLoi(f["inConfirmPassword"], "Nhập lại mật khẩu không trùng với ô Mật khẩu.");
	}
	// ngoai le 5b (gia dinh A14): phai du 13 tuoi
	if (tuoi(f["inDateOfBirth"].value) < 13) {
		return baoLoi(f["inDateOfBirth"], "Khách hàng dưới 13 tuổi không thể tự đăng kí thành viên");
	}
	document.getElementById("outError").innerHTML = "";
	return true;   // buoc 6: submit goi doRegister6.jsp
}

// ngoai le 5a: dat noi dung outError, dung lai, khong goi doRegister6.jsp
function baoLoi(o, thongBao) {
	document.getElementById("outError").innerHTML = thongBao;
	o.focus();
	return false;
}

function tuoi(ngaySinh) {
	var d = new Date(ngaySinh);
	if (isNaN(d.getTime())) { return -1; }
	var nay = new Date();
	var t = nay.getFullYear() - d.getFullYear();
	var m = nay.getMonth() - d.getMonth();
	if (m < 0 || (m === 0 && nay.getDate() < d.getDate())) { t--; }
	return t;
}
</script>
</head>
<body>
<%-- buoc 3: hien thi bieu mau dang ki; buoc 4: khach hang nhap va click subRegister --%>
<h1>Đăng kí thành viên</h1>
<form name="frmRegister" action="<%=request.getContextPath()%>/khachhang/doRegister6.jsp"
      method="post" onsubmit="return kiemtraDinhdang()">
	<p><label for="inFullName">Họ và tên (*)</label>
		<input type="text" id="inFullName" name="inFullName" maxlength="60" value="<%=giaTri.get("inFullName")%>"></p>
	<p><label for="inDateOfBirth">Ngày sinh (*)</label>
		<input type="date" id="inDateOfBirth" name="inDateOfBirth" value="<%=giaTri.get("inDateOfBirth")%>"></p>
	<p><label for="inPhone">Số điện thoại (*)</label>
		<input type="text" id="inPhone" name="inPhone" maxlength="10" value="<%=giaTri.get("inPhone")%>"></p>
	<p><label for="inEmail">Email (*)</label>
		<input type="text" id="inEmail" name="inEmail" value="<%=giaTri.get("inEmail")%>"></p>
	<p><label for="inAddress">Địa chỉ</label>
		<input type="text" id="inAddress" name="inAddress" value="<%=giaTri.get("inAddress")%>"></p>
	<p><label for="inPassword">Mật khẩu (*)</label>
		<input type="password" id="inPassword" name="inPassword"></p>
	<p><label for="inConfirmPassword">Nhập lại mật khẩu (*)</label>
		<input type="password" id="inConfirmPassword" name="inConfirmPassword"></p>
	<p><label id="outError"><%=outError%></label></p>
	<p>
		<input type="submit" id="subRegister" name="subRegister" value="Đăng kí" onclick="daHuy = false;">
		<input type="submit" id="subCancel" name="subCancel" value="Huỷ" onclick="daHuy = true;"
		       formaction="<%=request.getContextPath()%>/khachhang/gdCustomerHome6.jsp">
	</p>
</form>
</body>
</html>
