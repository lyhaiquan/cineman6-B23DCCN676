<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.*"%>
<%--
  gdCustomerHome6.jsp - Hinh 15: subRegister : link, cus : Customer6.
  buoc 1, 2 (vao chuc nang dang ki) va buoc 26 (hien lai trang chu) cua kich ban v.3.
--%>
<%
	// cus : Customer6 - khach hang cua phien, null neu chua dang ki/dang nhap
	Customer6 cus = (Customer6) session.getAttribute("khachhang");
	String hoTen = "";
	if (cus != null && cus.getFullName() != null) {
		FullName6 fn = cus.getFullName();
		String mid = fn.getMiddleName();
		hoTen = ((fn.getFirstName() == null ? "" : fn.getFirstName())
				+ (mid == null || mid.trim().isEmpty() ? "" : " " + mid.trim())
				+ " " + (fn.getLastName() == null ? "" : fn.getLastName())).trim();
		hoTen = hoTen.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>CineMan — Trang chủ</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css?v=2">
</head>
<body>
<h1>CineMan — Trang chủ</h1>
<%-- dong chu tinh cua Hinh 13 (khong phai phan tu cua Hinh 15, khong bam duoc) --%>
<p>Phim đang chiếu &nbsp;&nbsp; Lịch chiếu &nbsp;&nbsp; Khuyến mãi</p>
<%
	// buoc 26: trang chu hien thi cho khach hang
	if (cus == null) {
%>
<%-- buoc 1: khach hang click subRegister; buoc 2: trang goi gdRegisterMember6.jsp --%>
<p><a id="subRegister" name="subRegister" href="<%=request.getContextPath()%>/khachhang/gdRegisterMember6.jsp">Đăng kí thành viên</a></p>
<%
	} else {
%>
<p>Xin chào, <%=hoTen%></p>
<%
	}
%>
</body>
</html>
