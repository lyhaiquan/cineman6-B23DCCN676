<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.text.*,java.util.*,dao.*,model.*"%>
<%--
  doRegister6.jsp - Hinh 15: cus : Customer6, rank : MembershipRank6,
  existed : boolean, newId : integer. Trang xu li, khong hien thi.
  Buoc 6 - 22 cua kich ban v.3, ngoai le 9a, 21a.
--%>
<%
	request.setCharacterEncoding("UTF-8");
	String trangBieuMau = "/khachhang/gdRegisterMember6.jsp";

	// buoc 6: nhan du lieu bieu mau gdRegisterMember6.jsp submit sang
	String inFullName    = request.getParameter("inFullName");
	String inDateOfBirth = request.getParameter("inDateOfBirth");
	String inPhone       = request.getParameter("inPhone");
	String inEmail       = request.getParameter("inEmail");
	String inAddress     = request.getParameter("inAddress");
	String inPassword    = request.getParameter("inPassword");
	if (inFullName == null || inPhone == null || inEmail == null
			|| inPassword == null || inDateOfBirth == null) {
		// mo truc tiep trang nay khong qua bieu mau
		response.sendRedirect(request.getContextPath() + trangBieuMau);
		return;
	}
	inFullName = inFullName.trim();
	inPhone = inPhone.trim();
	inEmail = inEmail.trim();
	inAddress = (inAddress == null) ? "" : inAddress.trim();

	// buoc 7: goi lop CustomerDAO6 yeu cau kiem tra SDT va email
	CustomerDAO6 cusDao = new CustomerDAO6();
	// buoc 8: CustomerDAO6 goi checkExistedAccount(phone, email)
	boolean existed = cusDao.checkExistedAccount(inPhone, inEmail);
	// buoc 9: nhan ket qua "chua ton tai"
	if (existed) {
		// ngoai le 9a: goi lai gdRegisterMember6.jsp kem outError, giu du lieu da nhap
		request.setAttribute("outError", "Số điện thoại hoặc email đã được đăng kí.");
		request.getRequestDispatcher(trangBieuMau).forward(request, response);
		return;
	}

	// buoc 10: goi lop MembershipRankDAO6 yeu cau lay hang mac dinh
	MembershipRankDAO6 rankDao = new MembershipRankDAO6();
	// buoc 11 - 14 nam trong MembershipRankDAO6.getDefaultRank()
	MembershipRank6 rank = rankDao.getDefaultRank();
	// buoc 15: nhan hang "Thuong"
	if (rank == null) {
		request.setAttribute("outError", "Hệ thống đang bận, vui lòng thử lại");
		request.getRequestDispatcher(trangBieuMau).forward(request, response);
		return;
	}

	// buoc 16: goi lop Customer6 de dong goi thong tin khach hang moi
	// buoc 17: Customer6() dong goi thuc the, gom FullName6, Address6, hang mac dinh
	Date dateOfBirth = null;
	try {
		dateOfBirth = new SimpleDateFormat("yyyy-MM-dd").parse(inDateOfBirth);
	} catch (ParseException pe) {
		request.setAttribute("outError", "Ngày sinh không đúng định dạng.");
		request.getRequestDispatcher(trangBieuMau).forward(request, response);
		return;
	}

	// Ho ten: tu dau la ho (firstName), tu cuoi la ten (lastName), giua la dem
	FullName6 fullName = new FullName6();
	String[] phanTen = inFullName.split("\\s+");
	if (phanTen.length == 1) {
		fullName.setFirstName("");
		fullName.setMiddleName("");
		fullName.setLastName(phanTen[0]);
	} else {
		fullName.setFirstName(phanTen[0]);
		StringBuilder dem = new StringBuilder();
		for (int i = 1; i < phanTen.length - 1; i++) {
			if (dem.length() > 0) { dem.append(" "); }
			dem.append(phanTen[i]);
		}
		fullName.setMiddleName(dem.toString());
		fullName.setLastName(phanTen[phanTen.length - 1]);
	}

	// Dia chi "so nha duong, phuong, quan, thanh pho": phan dau la street,
	// phan cuoi la city, ke cuoi la district, cac phan giua la ward
	Address6 address = new Address6();
	String[] p = inAddress.isEmpty() ? new String[0] : inAddress.split(",");
	int n = p.length;
	address.setStreet(n >= 1 ? p[0].trim() : "");
	address.setCity(n >= 2 ? p[n - 1].trim() : "");
	address.setDistrict(n >= 3 ? p[n - 2].trim() : "");
	StringBuilder phuong = new StringBuilder();
	for (int i = 1; i < n - 2; i++) {
		if (phuong.length() > 0) { phuong.append(", "); }
		phuong.append(p[i].trim());
	}
	address.setWard(phuong.toString());

	Date bayGio = new Date();
	Customer6 cus = new Customer6();
	cus.setUsername(inPhone);                    // gia dinh A15: SDT la ten dang nhap
	cus.setPassword(inPassword);
	cus.setDateOfBirth(dateOfBirth);
	cus.setPhone(inPhone);
	cus.setEmail(inEmail);
	cus.setStatus(Person6.STATUS_ACTIVE);        // gia dinh A25
	cus.setFullName(fullName);
	cus.setAddress(address);
	cus.setRank(rank);                           // gia dinh A16: hang "Thuong"
	cus.setPoints(0);                            // gia dinh A16: diem 0
	cus.setRegisteredDate(bayGio);
	cus.setCustomerCode("MB" + new SimpleDateFormat("yyyyMMddHHmmss").format(bayGio)); // gia dinh A24
	// buoc 18: Customer6 tra doi tuong cus cho trang

	// buoc 19: goi lop CustomerDAO6 yeu cau luu khach hang moi
	// buoc 20: CustomerDAO6 goi addCustomer(cus)
	int newId = cusDao.addCustomer(cus);
	// buoc 21: nhan ket qua
	if (newId == 0) {
		// ngoai le 21a: goi lai gdRegisterMember6.jsp kem thong bao loi he thong
		request.setAttribute("outError", "Hệ thống đang bận, vui lòng thử lại");
		request.getRequestDispatcher(trangBieuMau).forward(request, response);
		return;
	}
	cus.setId(newId);
	cus.setPassword(null);                       // khong giu mat khau trong phien

	// buoc 22: goi trang gdRegisterResult6.jsp; khach hang o trang thai da dang nhap
	session.setAttribute("khachhang", cus);
	response.sendRedirect(request.getContextPath() + "/khachhang/gdRegisterResult6.jsp");
%>
