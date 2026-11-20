<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.text.*,java.util.*,dao.*,model.*"%>
<%--
  gdShowtimeStat6.jsp - Hinh 16 (GDST), man hinh GD4 cua Hinh 14.
  Phan tu : outMovieInfo : Label, outsubShowtimeStatList : Table + link, subBack : submit
  Bien    : movie : Movie6, startDate : Date, endDate : Date,
            listShowtimeStat : ShowtimeStatistic6[] (ArrayList), emp : Employee6
  movie, listShowtimeStat giu o session de "Quay lai" tu gdInvoiceStat6.jsp hien lai dung du lieu (*a).
--%>
<%!
	private String so(long v) {
		DecimalFormatSymbols s = new DecimalFormatSymbols();
		s.setGroupingSeparator('.');
		s.setDecimalSeparator(',');
		return new DecimalFormat("#,##0", s).format(v);
	}

	private String phanTram(double ti) {
		DecimalFormatSymbols s = new DecimalFormatSymbols();
		s.setGroupingSeparator('.');
		s.setDecimalSeparator(',');
		return new DecimalFormat("#,##0.#", s).format(ti * 100) + "%";
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

	// *a: Quay lai -> giao dien thong ke phim (hien lai du lieu dang xem tu session)
	if (request.getParameter("subBack") != null) {
		response.sendRedirect(request.getContextPath() + "/quanli/gdMovieRevenueStat6.jsp");
		return;
	}

	Date startDate = (Date) session.getAttribute("startDate");
	Date endDate = (Date) session.getAttribute("endDate");
	ArrayList<MovieStatistic6> listMovieStat = (ArrayList<MovieStatistic6>) session.getAttribute("listMovieStat");
	if (startDate == null || endDate == null || listMovieStat == null) {
		response.sendRedirect(request.getContextPath() + "/quanli/gdMovieRevenueStat6.jsp");
		return;
	}

	Movie6 movie = null;
	ArrayList<ShowtimeStatistic6> listShowtimeStat = null;
	String sIdMovie = request.getParameter("idMovie");
	if (sIdMovie != null) {
		// buoc 17: nhan ma phim vua click
		int idMovie = -1;
		try {
			idMovie = Integer.parseInt(sIdMovie);
		} catch (NumberFormatException e) {
			idMovie = -1;
		}
		for (MovieStatistic6 ms : listMovieStat) {
			if (ms.getId() == idMovie) {
				movie = ms;
				break;
			}
		}
		if (movie == null) {
			response.sendRedirect(request.getContextPath() + "/quanli/gdMovieRevenueStat6.jsp");
			return;
		}
		// buoc 18: goi ShowtimeStatisticDAO6 voi khoang ngay lay tu session; buoc 19-23 nam trong DAO
		listShowtimeStat = new ShowtimeStatisticDAO6().getShowtimeStatOfMovie(movie.getId(), startDate, endDate);
		session.setAttribute("movie", movie);
		session.setAttribute("listShowtimeStat", listShowtimeStat);
		session.removeAttribute("showtime");
		session.removeAttribute("listInvoiceStat");
	} else {
		// *a: quay lai tu gdInvoiceStat6.jsp
		movie = (Movie6) session.getAttribute("movie");
		listShowtimeStat = (ArrayList<ShowtimeStatistic6>) session.getAttribute("listShowtimeStat");
		if (movie == null || listShowtimeStat == null) {
			response.sendRedirect(request.getContextPath() + "/quanli/gdMovieRevenueStat6.jsp");
			return;
		}
	}

	SimpleDateFormat fNgay = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat fGio = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thống kê suất chiếu của phim</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css">
</head>
<body>
<h2>Thống kê suất chiếu của phim</h2>
<form action="<%=request.getContextPath()%>/quanli/gdShowtimeStat6.jsp" method="post">
	<div id="outMovieInfo" name="outMovieInfo">
		<p>Phim: <%=esc(movie.getTitle())%></p>
		<p>Khoảng thời gian: <%=fNgay.format(startDate)%> – <%=fNgay.format(endDate)%></p>
	</div>

	<%-- buoc 24: hien thi bang thong ke suat chieu (Bang 4), xep theo ngay chieu roi gio chieu --%>
	<table id="outsubShowtimeStatList" name="outsubShowtimeStatList">
		<tr><th>TT</th><th>Mã suất</th><th>Ngày chiếu</th><th>Giờ chiếu (khung giờ)</th><th>Phòng</th>
			<th>Định dạng</th><th>Vé bán / Sức chứa</th><th>Tỉ lệ lấp đầy</th><th>Doanh thu (VNĐ)</th></tr>
<%
	int tt = 0;
	for (ShowtimeStatistic6 ss : listShowtimeStat) {
		tt++;
		String gio = (ss.getStartTime() != null ? fGio.format(ss.getStartTime()) : "")
				+ " – " + (ss.getEndTime() != null ? fGio.format(ss.getEndTime()) : "")
				+ " (" + esc(ss.getTimeSlot().getName()) + ")";
%>
		<tr>
			<td><%=tt%></td>
			<%-- buoc 25: click 1 suat chieu; buoc 26: goi gdInvoiceStat6.jsp kem idShowtime --%>
			<td><a href="<%=request.getContextPath()%>/quanli/gdInvoiceStat6.jsp?idShowtime=<%=ss.getId()%>"><%=esc(ss.getShowtimeCode())%></a></td>
			<td><%=ss.getStartTime() != null ? fNgay.format(ss.getStartTime()) : ""%></td>
			<td><%=gio%></td>
			<td><%=esc(ss.getRoom().getName())%></td>
			<td><%=esc(ss.getFormat().getName())%></td>
			<td><%=so(ss.getTotalTicketsSold())%> / <%=so(ss.getRoom().getCapacity())%></td>
			<td><%=phanTram(ss.getOccupancyRate())%></td>
			<td><%=so(ss.getRevenue())%></td>
		</tr>
<%
	}
%>
	</table>

	<p><input type="submit" id="subBack" name="subBack" value="Quay lại"></p>
</form>
</body>
</html>
