<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.text.*,java.util.*,dao.*,model.*"%>
<%--
  gdMovieRevenueStat6.jsp - Hinh 16 (GDMR), man hinh GD3 cua Hinh 14.
  Phan tu : inStartDate : Date, inEndDate : Date, subView : submit,
            outsubMovieStatList : Table + link, subBack : submit, outError : Label
  Bien    : listMovieStat : MovieStatistic6[] (ArrayList), emp : Employee6
  Khoang ngay luu o session khoa "startDate", "endDate" de gdShowtimeStat6.jsp dung lai (A13, A20).
--%>
<%!
	private String tien(long v) {
		DecimalFormatSymbols s = new DecimalFormatSymbols();
		s.setGroupingSeparator('.');
		s.setDecimalSeparator(',');
		return new DecimalFormat("#,##0", s).format(v);
	}

	private String esc(String s) {
		if (s == null) {
			return "";
		}
		return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
	}
%>
<%
	Employee6 emp = (Employee6) session.getAttribute("quanli");
	if (emp == null) {
		response.sendRedirect(request.getContextPath() + "/gdLogin6.jsp");
		return;
	}
	request.setCharacterEncoding("UTF-8");

	// *a: Quay lai -> giao dien chon loai thong ke
	if (request.getParameter("subBack") != null) {
		response.sendRedirect(request.getContextPath() + "/quanli/gdSelectReport6.jsp");
		return;
	}

	SimpleDateFormat fIn = new SimpleDateFormat("yyyy-MM-dd");
	fIn.setLenient(false);
	SimpleDateFormat fOut = new SimpleDateFormat("dd/MM/yyyy");

	String outError = "";
	String sStart;
	String sEnd;
	ArrayList<MovieStatistic6> listMovieStat = null;

	if (request.getParameter("subView") != null) {
		// buoc 7: nhan vien quan li chon ngay va click Xem thong ke
		sStart = request.getParameter("inStartDate");
		sEnd = request.getParameter("inEndDate");
		if (sStart == null) {
			sStart = "";
		}
		if (sEnd == null) {
			sEnd = "";
		}
		// buoc 8: kiem tra khoang ngay
		Date d1 = null;
		Date d2 = null;
		try {
			d1 = fIn.parse(sStart);
			d2 = fIn.parse(sEnd);
		} catch (ParseException e) {
			d1 = null;
			d2 = null;
		}
		if (d1 == null || d2 == null || d1.after(d2)) {
			outError = "Ngày bắt đầu phải trước hoặc bằng ngày kết thúc";       // ngoai le 5a
		} else if ((d2.getTime() - d1.getTime()) / 86400000L + 1 > 365) {
			outError = "Khoảng thời gian tối đa là 365 ngày";                  // ngoai le 5b
		}
		if (outError.length() > 0) {
			session.removeAttribute("startDate");
			session.removeAttribute("endDate");
			session.removeAttribute("listMovieStat");
		} else {
			// buoc 8 (tiep): luu startDate, endDate vao session cho hai muc sau
			session.setAttribute("startDate", d1);
			session.setAttribute("endDate", d2);
			// buoc 9: goi MovieStatisticDAO6; buoc 10-14 nam trong DAO
			listMovieStat = new MovieStatisticDAO6().getMovieRevenueStat(d1, d2);
			session.setAttribute("listMovieStat", listMovieStat);
			if (listMovieStat.isEmpty()) {
				// ngoai le 6a
				outError = "Không có dữ liệu trong khoảng " + fOut.format(d1) + " – " + fOut.format(d2);
			}
		}
	} else {
		Date d1 = (Date) session.getAttribute("startDate");
		Date d2 = (Date) session.getAttribute("endDate");
		listMovieStat = (ArrayList<MovieStatistic6>) session.getAttribute("listMovieStat");
		if (d1 == null || d2 == null) {
			// buoc 6: lan dau hien thi, mac dinh ngay dau va ngay cuoi thang hien tai (A12), bang rong
			Calendar c = Calendar.getInstance();
			c.set(Calendar.DAY_OF_MONTH, 1);
			sStart = fIn.format(c.getTime());
			c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			sEnd = fIn.format(c.getTime());
			listMovieStat = null;
		} else {
			// *a: quay lai tu gdShowtimeStat6.jsp, hien lai dung du lieu dang xem
			sStart = fIn.format(d1);
			sEnd = fIn.format(d2);
			if (listMovieStat != null && listMovieStat.isEmpty()) {
				outError = "Không có dữ liệu trong khoảng " + fOut.format(d1) + " – " + fOut.format(d2);
			}
		}
	}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thống kê phim theo doanh thu</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css?v=2">
</head>
<body>
<h2>Thống kê phim theo doanh thu</h2>
<form action="<%=request.getContextPath()%>/quanli/gdMovieRevenueStat6.jsp" method="post">
	<p><label for="inStartDate">Ngày bắt đầu</label>
		<input type="date" id="inStartDate" name="inStartDate" value="<%=esc(sStart)%>"></p>
	<p><label for="inEndDate">Ngày kết thúc</label>
		<input type="date" id="inEndDate" name="inEndDate" value="<%=esc(sEnd)%>"></p>
	<p><input type="submit" id="subView" name="subView" value="Xem thống kê"></p>

	<p id="outError" name="outError"><%=esc(outError)%></p>

	<%-- buoc 15: hien thi bang thong ke phim (Bang 3), xep doanh thu giam dan --%>
	<table id="outsubMovieStatList" name="outsubMovieStatList">
		<tr><th>TT</th><th>Tên phim</th><th>Số suất chiếu</th><th>Số vé bán</th><th>Doanh thu (VNĐ)</th></tr>
<%
	if (listMovieStat != null && !listMovieStat.isEmpty()) {
		int tongSuat = 0;
		int tongVe = 0;
		long tongTien = 0;
		int tt = 0;
		for (MovieStatistic6 ms : listMovieStat) {
			tt++;
			tongSuat += ms.getTotalShowtimes();
			tongVe += ms.getTotalTicketsSold();
			tongTien += ms.getTotalRevenue();
%>
		<tr>
			<td><%=tt%></td>
			<%-- buoc 16: click 1 phim; buoc 17: goi gdShowtimeStat6.jsp kem idMovie --%>
			<td><a href="<%=request.getContextPath()%>/quanli/gdShowtimeStat6.jsp?idMovie=<%=ms.getId()%>"><%=esc(ms.getTitle())%></a></td>
			<td><%=tien(ms.getTotalShowtimes())%></td>
			<td><%=tien(ms.getTotalTicketsSold())%></td>
			<td><%=tien(ms.getTotalRevenue())%></td>
		</tr>
<%
		}
%>
		<tr><td></td><td>Tổng cộng</td><td><%=tien(tongSuat)%></td><td><%=tien(tongVe)%></td><td><%=tien(tongTien)%></td></tr>
<%
	}
%>
	</table>

	<p><input type="submit" id="subBack" name="subBack" value="Quay lại"></p>
</form>
</body>
</html>
