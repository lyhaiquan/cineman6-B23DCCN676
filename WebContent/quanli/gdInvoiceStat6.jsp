<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.text.*,java.util.*,dao.*,model.*"%>
<%--
  gdInvoiceStat6.jsp - Hinh 16 (GDIS), man hinh GD5 cua Hinh 14.
  Phan tu : outShowtimeInfo : Label, outInvoiceStatList : Table, subBack : submit
  Bien    : showtime : Showtime6, listInvoiceStat : InvoiceStatistic6[] (ArrayList), emp : Employee6
--%>
<%!
	private String so(long v) {
		DecimalFormatSymbols s = new DecimalFormatSymbols();
		s.setGroupingSeparator('.');
		s.setDecimalSeparator(',');
		return new DecimalFormat("#,##0", s).format(v);
	}

	private String hoTen(FullName6 fn) {
		if (fn == null) {
			return "";
		}
		String s = (fn.getFirstName() == null ? "" : fn.getFirstName()) + " "
				+ (fn.getMiddleName() == null ? "" : fn.getMiddleName()) + " "
				+ (fn.getLastName() == null ? "" : fn.getLastName());
		return s.replaceAll("\\s+", " ").trim();
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

	// *a: Quay lai -> giao dien thong ke suat chieu (hien lai du lieu dang xem tu session)
	if (request.getParameter("subBack") != null) {
		response.sendRedirect(request.getContextPath() + "/quanli/gdShowtimeStat6.jsp");
		return;
	}

	ArrayList<ShowtimeStatistic6> listShowtimeStat =
			(ArrayList<ShowtimeStatistic6>) session.getAttribute("listShowtimeStat");
	if (listShowtimeStat == null) {
		response.sendRedirect(request.getContextPath() + "/quanli/gdShowtimeStat6.jsp");
		return;
	}

	Showtime6 showtime = null;
	ArrayList<InvoiceStatistic6> listInvoiceStat = null;
	String sIdShowtime = request.getParameter("idShowtime");
	if (sIdShowtime != null) {
		// buoc 26: nhan ma suat chieu vua click
		int idShowtime = -1;
		try {
			idShowtime = Integer.parseInt(sIdShowtime);
		} catch (NumberFormatException e) {
			idShowtime = -1;
		}
		for (ShowtimeStatistic6 ss : listShowtimeStat) {
			if (ss.getId() == idShowtime) {
				showtime = ss;
				break;
			}
		}
		if (showtime == null) {
			response.sendRedirect(request.getContextPath() + "/quanli/gdShowtimeStat6.jsp");
			return;
		}
		// buoc 27: goi InvoiceStatisticDAO6; buoc 28-32 nam trong DAO
		listInvoiceStat = new InvoiceStatisticDAO6().getInvoiceStatOfShowtime(showtime.getId());
		session.setAttribute("showtime", showtime);
		session.setAttribute("listInvoiceStat", listInvoiceStat);
	} else {
		showtime = (Showtime6) session.getAttribute("showtime");
		listInvoiceStat = (ArrayList<InvoiceStatistic6>) session.getAttribute("listInvoiceStat");
		if (showtime == null || listInvoiceStat == null) {
			response.sendRedirect(request.getContextPath() + "/quanli/gdShowtimeStat6.jsp");
			return;
		}
	}

	SimpleDateFormat fNgayGio = new SimpleDateFormat("dd/MM/yyyy HH:mm");
	String info = esc(showtime.getShowtimeCode())
			+ " — " + (showtime.getMovie() != null ? esc(showtime.getMovie().getTitle()) : "")
			+ " — " + (showtime.getStartTime() != null ? fNgayGio.format(showtime.getStartTime()) : "");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thống kê hoá đơn bán vé của suất chiếu</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css">
</head>
<body>
<h2>Thống kê hoá đơn bán vé của suất chiếu</h2>
<form action="<%=request.getContextPath()%>/quanli/gdInvoiceStat6.jsp" method="post">
	<p>Suất chiếu: <span id="outShowtimeInfo" name="outShowtimeInfo"><%=info%></span></p>

	<%-- buoc 33: hien thi bang thong ke hoa don (Bang 5), xep theo thoi diem lap --%>
	<table id="outInvoiceStatList" name="outInvoiceStatList">
		<tr><th>TT</th><th>Số hoá đơn</th><th>Thời điểm lập</th><th>Kênh bán</th><th>Nhân viên lập</th>
			<th>Khách hàng</th><th>Số vé</th><th>Thành tiền (VNĐ)</th></tr>
<%
	if (listInvoiceStat.isEmpty()) {
%>
		<tr><td colspan="8">Suất chiếu chưa có hóa đơn bán vé</td></tr>
<%
	} else {
		int tt = 0;
		int tongVe = 0;
		long tongTien = 0;
		for (InvoiceStatistic6 is : listInvoiceStat) {
			tt++;
			tongVe += is.getTicketCount();
			tongTien += is.getRevenue();
			String nv = "—";
			if (is.getSalesperson() != null) {
				nv = esc(hoTen(is.getSalesperson().getFullName()));
			}
			String khach = "Khách vãng lai";
			if (is.getCustomer() != null) {
				khach = esc(hoTen(is.getCustomer().getFullName()))
						+ " (" + esc(is.getCustomer().getCustomerCode()) + ")";
			}
%>
		<tr>
			<td><%=tt%></td>
			<td><%=esc(is.getInvoiceNo())%></td>
			<td><%=is.getCreatedAt() != null ? fNgayGio.format(is.getCreatedAt()) : ""%></td>
			<td><%=esc(is.getChannel().getName())%></td>
			<td><%=nv%></td>
			<td><%=khach%></td>
			<td><%=so(is.getTicketCount())%></td>
			<td><%=so(is.getRevenue())%></td>
		</tr>
<%
		}
%>
		<tr><td colspan="6">Tổng cộng (<%=tt%> hoá đơn)</td><td><%=so(tongVe)%></td><td><%=so(tongTien)%></td></tr>
<%
	}
%>
	</table>

	<p><input type="submit" id="subBack" name="subBack" value="Quay lại"></p>
</form>
</body>
</html>
