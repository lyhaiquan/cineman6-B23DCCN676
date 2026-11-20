<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.*"%>
<%--
  gdLogin6.jsp - NGOAI pham vi hai module (gia dinh A23), chi de chay thu module 2.
  Khong truy van CSDL: bam nut thi tao mot Manager6 gia lap, dua vao session khoa "quanli".
--%>
<%
	if (request.getParameter("subLogin") != null) {
		Manager6 ql = new Manager6();
		ql.setEmployeeCode("NV001");
		ql.setPosition("Quản lí");
		session.setAttribute("quanli", ql);
		response.sendRedirect(request.getContextPath() + "/quanli/gdManagerHome6.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đăng nhập thử</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/cineman6.css?v=3">
</head>
<body>
<h2>Trang đăng nhập thử – ngoài phạm vi hai module</h2>
<form action="<%=request.getContextPath()%>/gdLogin6.jsp" method="post">
	<input type="submit" id="subLogin" name="subLogin" value="Đăng nhập thử với quyền quản lí">
</form>
</body>
</html>
