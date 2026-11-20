<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.text.*,model.*"%>
<%--
  gdRegisterResult6.jsp - Hinh 15: outMemberInfo : Label, outGuide : Label,
  subHome : submit, cus : Customer6. Buoc 23 - 25 cua kich ban v.3 (Bang 2).
--%>
<%
	// cus : Customer6 - doi tuong vua luu, doRegister6.jsp dat vao session
	Customer6 cus = (Customer6) session.getAttribute("khachhang");
	if (cus == null) {
		response.sendRedirect(request.getContextPath() + "/khachhang/gdCustomerHome6.jsp");
		return;
	}
	FullName6 fn = cus.getFullName();
	String hoTen = "";
	if (fn != null) {
		String mid = fn.getMiddleName();
		hoTen = ((fn.getFirstName() == null ? "" : fn.getFirstName())
				+ (mid == null || mid.trim().isEmpty() ? "" : " " + mid.trim())
				+ " " + (fn.getLastName() == null ? "" : fn.getLastName())).trim();
		hoTen = hoTen.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
	String hang = (cus.getRank() == null) ? "" : cus.getRank().getName();
	String ngayDangKi = (cus.getRegisteredDate() == null) ? ""
			: new SimpleDateFormat("dd/MM/yyyy").format(cus.getRegisteredDate());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng kí thành viên thành công</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css?v=3">
</head>
<body>
<%-- buoc 23: hien thi ket qua dang ki cho khach hang (Bang 2) --%>
<h1>Đăng kí thành viên thành công!</h1>

<table id="outMemberInfo">
	<tr><td>Mã thành viên</td><td><%=cus.getCustomerCode()%></td></tr>
	<tr><td>Họ và tên</td><td><%=hoTen%></td></tr>
	<tr><td>Số điện thoại</td><td><%=cus.getPhone()%></td></tr>
	<tr><td>Hạng thành viên</td><td><%=hang%></td></tr>
	<tr><td>Điểm tích luỹ</td><td><%=cus.getPoints()%></td></tr>
	<tr><td>Ngày đăng kí</td><td><%=ngayDangKi%></td></tr>
</table>

<p><label id="outGuide">Mời quý khách tới quầy để được nhân viên xuất thẻ thành viên</label></p>

<%-- buoc 24: khach hang click subHome; buoc 25: trang goi gdCustomerHome6.jsp --%>
<form action="<%=request.getContextPath()%>/khachhang/gdCustomerHome6.jsp" method="post">
	<input type="submit" id="subHome" name="subHome" value="Về trang chủ">
</form>
</body>
</html>
