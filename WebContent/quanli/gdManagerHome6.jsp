<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.*"%>
<%--
  gdManagerHome6.jsp - Hinh 16 (GDMH), man hinh GD1 cua Hinh 14.
  Phan tu : subViewReport : link
  Bien    : emp : Employee6 (nhan vien quan li dang dang nhap, lay tu session)
--%>
<%
	Employee6 emp = (Employee6) session.getAttribute("quanli");
	if (emp == null) {
		// dang nhap ngoai pham vi hai module (gia dinh A23)
		response.sendRedirect(request.getContextPath() + "/gdLogin6.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Trang chủ quản lí</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css">
</head>
<body>
<h2>CINEMAN — Trang chủ quản lí</h2>
<%-- buoc 1: click Xem bao cao; buoc 2: goi trang gdSelectReport6.jsp --%>
<a id="subViewReport" name="subViewReport" href="<%=request.getContextPath()%>/quanli/gdSelectReport6.jsp">Xem báo cáo</a>
</body>
</html>
