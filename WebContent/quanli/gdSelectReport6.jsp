<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.*"%>
<%--
  gdSelectReport6.jsp - Hinh 16 (GDSR), man hinh GD2 cua Hinh 14.
  Phan tu : inoutReportType : Select, subContinue : submit, subBack : submit
  Bien    : emp : Employee6
  Ba loai thong ke co dinh (gia dinh A17). Hai loai "khach hang" va "doanh thu toan rap"
  ngoai pham vi: chon roi bam Tiep tuc thi o lai trang nay, giu nguyen lua chon.
--%>
<%
	Employee6 emp = (Employee6) session.getAttribute("quanli");
	if (emp == null) {
		response.sendRedirect(request.getContextPath() + "/gdLogin6.jsp");
		return;
	}
	request.setCharacterEncoding("UTF-8");

	// *a: Quay lai tu giao dien chon loai thong ke -> trang chu quan li
	if (request.getParameter("subBack") != null) {
		response.sendRedirect(request.getContextPath() + "/quanli/gdManagerHome6.jsp");
		return;
	}

	String reportType = request.getParameter("inoutReportType");
	if (reportType == null) {
		reportType = "movie";
	}

	// buoc 4: chon "Thong ke phim theo doanh thu", click Tiep tuc
	if (request.getParameter("subContinue") != null && "movie".equals(reportType)) {
		// bat dau mot lan xem moi: bang ket qua rong (buoc 6)
		session.removeAttribute("startDate");
		session.removeAttribute("endDate");
		session.removeAttribute("listMovieStat");
		session.removeAttribute("movie");
		session.removeAttribute("listShowtimeStat");
		session.removeAttribute("showtime");
		session.removeAttribute("listInvoiceStat");
		// buoc 5: goi trang gdMovieRevenueStat6.jsp
		response.sendRedirect(request.getContextPath() + "/quanli/gdMovieRevenueStat6.jsp");
		return;
	}
	// buoc 3: hien thi danh sach loai thong ke
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chọn loại thống kê</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css">
</head>
<body>
<h2>Chọn loại thống kê</h2>
<form action="<%=request.getContextPath()%>/quanli/gdSelectReport6.jsp" method="post">
	<label for="inoutReportType">Loại thống kê</label>
	<select id="inoutReportType" name="inoutReportType">
		<option value="movie"<%="movie".equals(reportType) ? " selected" : ""%>>Thống kê phim theo doanh thu</option>
		<option value="customer"<%="customer".equals(reportType) ? " selected" : ""%>>Thống kê khách hàng</option>
		<option value="revenue"<%="revenue".equals(reportType) ? " selected" : ""%>>Thống kê doanh thu toàn rạp</option>
	</select>
	<p>
		<input type="submit" id="subContinue" name="subContinue" value="Tiếp tục">
		<input type="submit" id="subBack" name="subBack" value="Quay lại">
	</p>
</form>
</body>
</html>
