-- =====================================================================
-- CSDL cineman6 - CineMan de 16 - hau to lop 6
-- Mot file duy nhat cho CA HAI module:
--   module 1: dang ki thanh vien (Hinh 15)
--   module 2: xem thong ke phim theo doanh thu (Hinh 16)
-- Ten bang / ten cot theo Hinh 24 (viet thuong). Chi tao cac bang hai
-- module dung toi; cac bang tblcinema6, tblseat6, tblseattype6,
-- tblpaymentmethod6, tblgenre6, tblmoviegenre6, tblmembershipcard6 cua
-- Hinh 24 va cac cot khoa ngoai tro toi chung (tblcinema6id, tblseat6id,
-- tblpaymentmethod6id) duoc luoc bo.
-- Ba lop thong ke khong co bang (gia dinh A21): so lieu tinh bang truy
-- van gop trong stored procedure (gia dinh A22).
-- Doanh thu = tong finalamount cua hoa don (da tru chiet khau, gia dinh
-- A6); moi muc deu loc theo ngay chieu cua suat chieu (gia dinh A13).
-- Chay duoc tren MariaDB 10.11 va MySQL 8.
-- =====================================================================
SET NAMES utf8mb4;

DROP DATABASE IF EXISTS cineman6;
CREATE DATABASE cineman6 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cineman6;

-- =============================================================== nguoi
CREATE TABLE tblfullname6 (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  firstname  VARCHAR(50) NOT NULL,
  middlename VARCHAR(50) NOT NULL,
  lastname   VARCHAR(50) NOT NULL
);

CREATE TABLE tbladdress6 (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  street   VARCHAR(100) NOT NULL,
  ward     VARCHAR(50) NOT NULL,
  district VARCHAR(50) NOT NULL,
  city     VARCHAR(50) NOT NULL
);

CREATE TABLE tblperson6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  username    VARCHAR(50)  NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  dateofbirth DATE NOT NULL,
  phone       VARCHAR(20) NOT NULL  UNIQUE,
  email       VARCHAR(100) NOT NULL UNIQUE,
  -- gia dinh A25: dung ba gia tri, khop hang STATUS_* cua lop Person6
  status      VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',  -- ACTIVE, LOCKED, INACTIVE (kiem tra trong themKhachhang6)
  note        VARCHAR(255),
  tblfullname6id INT NOT NULL,
  tbladdress6id  INT NOT NULL,
  FOREIGN KEY (tblfullname6id) REFERENCES tblfullname6(id),
  FOREIGN KEY (tbladdress6id)  REFERENCES tbladdress6(id)
);

CREATE TABLE tblmembershiprank6 (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(50) NOT NULL,
  minpoints    INT   NOT NULL DEFAULT 0,
  discountrate FLOAT NOT NULL DEFAULT 0,
  description  VARCHAR(255)
);

-- Ke thua Person6 <|-- Customer6: khoa chinh cung la khoa ngoai
CREATE TABLE tblcustomer6 (
  tblperson6id   INT PRIMARY KEY,
  customercode   VARCHAR(20) NOT NULL UNIQUE,
  registereddate DATE NOT NULL,
  points         INT NOT NULL DEFAULT 0,
  tblmembershiprank6id INT NOT NULL,
  FOREIGN KEY (tblperson6id)         REFERENCES tblperson6(id),
  FOREIGN KEY (tblmembershiprank6id) REFERENCES tblmembershiprank6(id)
);

CREATE TABLE tblemployee6 (
  tblperson6id INT PRIMARY KEY,
  employeecode VARCHAR(20) NOT NULL UNIQUE,
  position     VARCHAR(50) NOT NULL,
  hiredate     DATE NOT NULL,
  FOREIGN KEY (tblperson6id) REFERENCES tblperson6(id)
);

CREATE TABLE tblmanager6 (
  tblemployee6id  INT PRIMARY KEY,
  managementlevel VARCHAR(20) NOT NULL,
  FOREIGN KEY (tblemployee6id) REFERENCES tblemployee6(tblperson6id)
);

CREATE TABLE tblsalesperson6 (
  tblemployee6id INT PRIMARY KEY,
  countercode    VARCHAR(20) NOT NULL,
  workshift      VARCHAR(20) NOT NULL,
  FOREIGN KEY (tblemployee6id) REFERENCES tblemployee6(tblperson6id)
);

-- ========================================================== lich chieu
CREATE TABLE tblmovie6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(150) NOT NULL,
  director    VARCHAR(100) NOT NULL,
  mainactors  VARCHAR(255) NOT NULL,
  duration    INT NOT NULL,
  releasedate DATE NOT NULL,
  agerating   VARCHAR(10) NOT NULL,
  synopsis    TEXT NOT NULL,
  status      VARCHAR(20) NOT NULL
);

CREATE TABLE tblscreeningroom6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(50) NOT NULL,
  capacity    INT NOT NULL,
  description VARCHAR(255)
);

CREATE TABLE tblshowdate6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  showdate    DATE NOT NULL UNIQUE,
  dayofweek   VARCHAR(20) NOT NULL,
  isholiday   TINYINT(1) NOT NULL DEFAULT 0,
  pricefactor FLOAT NOT NULL DEFAULT 1
);

CREATE TABLE tbltimeslot6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(50) NOT NULL,
  starthour   INT NOT NULL,
  endhour     INT NOT NULL,
  pricefactor FLOAT NOT NULL DEFAULT 1
);

CREATE TABLE tblshowformat6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(50) NOT NULL,
  pricefactor FLOAT NOT NULL DEFAULT 1,
  description VARCHAR(255)
);

CREATE TABLE tblshowtime6 (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  showtimecode VARCHAR(20) NOT NULL UNIQUE,
  starttime    DATETIME NOT NULL,
  endtime      DATETIME NOT NULL,
  baseprice    BIGINT NOT NULL,
  status       VARCHAR(20) NOT NULL,
  tblmovie6id         INT NOT NULL,
  tblscreeningroom6id INT NOT NULL,
  tblshowdate6id      INT NOT NULL,
  tbltimeslot6id      INT NOT NULL,
  tblshowformat6id    INT NOT NULL,
  FOREIGN KEY (tblmovie6id)         REFERENCES tblmovie6(id),
  FOREIGN KEY (tblscreeningroom6id) REFERENCES tblscreeningroom6(id),
  FOREIGN KEY (tblshowdate6id)      REFERENCES tblshowdate6(id),
  FOREIGN KEY (tbltimeslot6id)      REFERENCES tbltimeslot6(id),
  FOREIGN KEY (tblshowformat6id)    REFERENCES tblshowformat6(id)
);

-- ============================================================= ban ve
CREATE TABLE tblsaleschannel6 (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(50) NOT NULL,
  description VARCHAR(255)
);

-- Gia dinh A9: chi khach hang (khach vang lai) va nhan vien lap (hoa don truc tuyen) duoc NULL
CREATE TABLE tblinvoice6 (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  invoiceno      VARCHAR(20) NOT NULL UNIQUE,
  createdat      DATETIME NOT NULL,
  totalamount    BIGINT NOT NULL DEFAULT 0,
  discountamount BIGINT NOT NULL DEFAULT 0,
  finalamount    BIGINT NOT NULL DEFAULT 0,
  status         VARCHAR(20) NOT NULL,
  tblshowtime6id     INT NOT NULL,
  tblcustomer6id     INT NULL,
  tblsalesperson6id  INT NULL,
  tblsaleschannel6id INT NOT NULL,
  FOREIGN KEY (tblshowtime6id)     REFERENCES tblshowtime6(id),
  FOREIGN KEY (tblcustomer6id)     REFERENCES tblcustomer6(tblperson6id),
  FOREIGN KEY (tblsalesperson6id)  REFERENCES tblsalesperson6(tblemployee6id),
  FOREIGN KEY (tblsaleschannel6id) REFERENCES tblsaleschannel6(id)
);

CREATE TABLE tblticket6 (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  ticketcode VARCHAR(20) NOT NULL UNIQUE,
  price      BIGINT NOT NULL,
  status     VARCHAR(20) NOT NULL,
  issuedat   DATETIME NOT NULL,
  tblinvoice6id  INT NOT NULL,
  tblshowtime6id INT NOT NULL,
  FOREIGN KEY (tblinvoice6id)  REFERENCES tblinvoice6(id),
  FOREIGN KEY (tblshowtime6id) REFERENCES tblshowtime6(id)
);

-- =====================================================================
-- STORED PROCEDURE (ten va tham so dung nhu cac lop DAO dang goi)
-- =====================================================================
DELIMITER $$

-- CustomerDAO6.checkExistedAccount - buoc 7 - 10 kich ban v.3 module 1
CREATE PROCEDURE kiemtraTonTai6(IN p_phone VARCHAR(20), IN p_email VARCHAR(100))
BEGIN
  SELECT COUNT(*) AS soluong
    FROM tblperson6
   WHERE phone = p_phone OR email = p_email OR username = p_phone;
END$$

-- MembershipRankDAO6.getDefaultRank - buoc 11 - 15: hang co minpoints nho nhat
CREATE PROCEDURE hangMacdinh6()
BEGIN
  SELECT id, name, minpoints, discountrate, description
    FROM tblmembershiprank6
   ORDER BY minpoints ASC, id ASC
   LIMIT 1;
END$$

-- CustomerDAO6.addCustomer - buoc 19 - 22: ghi bon bang trong mot giao dich
CREATE PROCEDURE themKhachhang6(
  IN p_username VARCHAR(50),  IN p_password VARCHAR(255), IN p_dob DATE,
  IN p_phone    VARCHAR(20),  IN p_email    VARCHAR(100),
  IN p_first    VARCHAR(50),  IN p_middle   VARCHAR(50),  IN p_last VARCHAR(50),
  IN p_street   VARCHAR(100), IN p_ward     VARCHAR(50),
  IN p_district VARCHAR(50),  IN p_city     VARCHAR(50),
  IN p_code     VARCHAR(20),  IN p_rank     INT,
  IN p_status   VARCHAR(20),
  OUT p_newid   INT)
proc: BEGIN
  DECLARE v_fullname INT;
  DECLARE v_address  INT;
  -- SQLWARNING: du lieu sai kieu, bi cat chuoi... bao SQLSTATE 01000, khong thuoc SQLEXCEPTION
  DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
  BEGIN
    ROLLBACK;
    SET p_newid = 0;
  END;

  SET p_newid = 0;
  IF p_status IS NULL OR p_status NOT IN ('ACTIVE', 'LOCKED', 'INACTIVE') THEN
    LEAVE proc;
  END IF;

  START TRANSACTION;
    INSERT INTO tblfullname6(firstname, middlename, lastname)
         VALUES (p_first, p_middle, p_last);
    SET v_fullname = LAST_INSERT_ID();

    INSERT INTO tbladdress6(street, ward, district, city)
         VALUES (p_street, p_ward, p_district, p_city);
    SET v_address = LAST_INSERT_ID();

    INSERT INTO tblperson6(username, password, dateofbirth, phone, email,
                           status, note, tblfullname6id, tbladdress6id)
         VALUES (p_username, p_password, p_dob, p_phone, p_email,
                 p_status, NULL, v_fullname, v_address);
    SET p_newid = LAST_INSERT_ID();

    INSERT INTO tblcustomer6(tblperson6id, customercode, registereddate,
                             points, tblmembershiprank6id)
         VALUES (p_newid, p_code, CURDATE(), 0, p_rank);
  COMMIT;
END$$

-- MovieStatisticDAO6.getMovieRevenueStat - buoc 10 - 14 kich ban v.3 module 2
-- Gop rieng ve va hoa don theo suat chieu truoc khi noi, tranh nhan doi tong.
CREATE PROCEDURE tkPhimTheoDoanhthu6(IN p_start DATE, IN p_end DATE)
BEGIN
  SELECT m.id, m.title, m.director, m.duration, m.agerating, m.status,
         COUNT(st.id)          AS totalshowtimes,
         IFNULL(SUM(tk.sl), 0) AS totalticketssold,
         IFNULL(SUM(iv.dt), 0) AS totalrevenue
    FROM tblmovie6 m
    JOIN tblshowtime6 st ON st.tblmovie6id = m.id
    JOIN tblshowdate6 sd ON sd.id = st.tblshowdate6id
    LEFT JOIN (SELECT i.tblshowtime6id AS sid, COUNT(t.id) AS sl
                 FROM tblinvoice6 i
                 JOIN tblticket6 t ON t.tblinvoice6id = i.id AND t.status = 'SOLD'
                WHERE i.status = 'PAID'
                GROUP BY i.tblshowtime6id) tk ON tk.sid = st.id
    LEFT JOIN (SELECT tblshowtime6id AS sid, SUM(finalamount) AS dt
                 FROM tblinvoice6
                WHERE status = 'PAID'
                GROUP BY tblshowtime6id) iv ON iv.sid = st.id
   WHERE sd.showdate BETWEEN p_start AND p_end
   GROUP BY m.id, m.title, m.director, m.duration, m.agerating, m.status
  HAVING totalrevenue > 0
   ORDER BY totalrevenue DESC, m.title;
END$$

-- ShowtimeStatisticDAO6.getShowtimeStatOfMovie - buoc 19 - 23 module 2
CREATE PROCEDURE tkSuatchieuCuaPhim6(IN p_movie INT, IN p_start DATE, IN p_end DATE)
BEGIN
  SELECT st.id, st.showtimecode, st.starttime, st.endtime, st.baseprice, st.status,
         m.title    AS movietitle,
         r.id       AS roomid,
         r.name     AS roomname,
         r.capacity AS capacity,
         ts.id      AS timeslotid,
         ts.name    AS timeslotname,
         sf.id      AS formatid,
         sf.name    AS formatname,
         IFNULL(iv.sohd, 0)                       AS totalinvoices,
         IFNULL(tk.sl, 0)                         AS totalticketssold,
         ROUND(IFNULL(tk.sl, 0) / r.capacity, 4)  AS occupancyrate,
         IFNULL(iv.dt, 0)                         AS revenue
    FROM tblshowtime6 st
    JOIN tblmovie6 m         ON m.id  = st.tblmovie6id
    JOIN tblscreeningroom6 r ON r.id  = st.tblscreeningroom6id
    JOIN tblshowdate6 sd     ON sd.id = st.tblshowdate6id
    JOIN tbltimeslot6 ts     ON ts.id = st.tbltimeslot6id
    JOIN tblshowformat6 sf   ON sf.id = st.tblshowformat6id
    LEFT JOIN (SELECT i.tblshowtime6id AS sid, COUNT(t.id) AS sl
                 FROM tblinvoice6 i
                 JOIN tblticket6 t ON t.tblinvoice6id = i.id AND t.status = 'SOLD'
                WHERE i.status = 'PAID'
                GROUP BY i.tblshowtime6id) tk ON tk.sid = st.id
    LEFT JOIN (SELECT tblshowtime6id AS sid, COUNT(*) AS sohd, SUM(finalamount) AS dt
                 FROM tblinvoice6
                WHERE status = 'PAID'
                GROUP BY tblshowtime6id) iv ON iv.sid = st.id
   WHERE st.tblmovie6id = p_movie
     AND sd.showdate BETWEEN p_start AND p_end
   ORDER BY st.starttime, st.showtimecode;
END$$

-- InvoiceStatisticDAO6.getInvoiceStatOfShowtime - buoc 28 - 32 module 2
-- Them cot salesperson* (nhan vien lap, Bang 5) cho JSP/DAO dung neu can.
CREATE PROCEDURE tkHoadonCuaSuatchieu6(IN p_showtime INT)
BEGIN
  SELECT i.id, i.invoiceno, i.createdat, i.totalamount, i.discountamount,
         i.finalamount, i.status,
         c.id               AS channelid,
         c.name             AS channelname,
         cus.tblperson6id   AS customerid,
         cus.customercode   AS customercode,
         fn.firstname, fn.middlename, fn.lastname,
         i.tblsalesperson6id AS salespersonid,
         e.employeecode     AS salespersoncode,
         sfn.firstname      AS spfirstname,
         sfn.middlename     AS spmiddlename,
         sfn.lastname       AS splastname,
         IFNULL(tk.sl, 0)   AS ticketcount,
         i.finalamount      AS revenue
    FROM tblinvoice6 i
    JOIN tblsaleschannel6 c    ON c.id = i.tblsaleschannel6id
    LEFT JOIN tblcustomer6 cus ON cus.tblperson6id = i.tblcustomer6id
    LEFT JOIN tblperson6 p     ON p.id = cus.tblperson6id
    LEFT JOIN tblfullname6 fn  ON fn.id = p.tblfullname6id
    LEFT JOIN tblemployee6 e   ON e.tblperson6id = i.tblsalesperson6id
    LEFT JOIN tblperson6 sp    ON sp.id = i.tblsalesperson6id
    LEFT JOIN tblfullname6 sfn ON sfn.id = sp.tblfullname6id
    LEFT JOIN (SELECT tblinvoice6id AS iid, COUNT(*) AS sl
                 FROM tblticket6
                WHERE status = 'SOLD'
                GROUP BY tblinvoice6id) tk ON tk.iid = i.id
   WHERE i.tblshowtime6id = p_showtime
     AND i.status = 'PAID'
   ORDER BY i.createdat, i.invoiceno;
END$$

DELIMITER ;

-- =====================================================================
-- DU LIEU MAU
-- Khop Bang 4 (ba suat ST1042, ST1078, ST1105 cua "Mắt Biếc 2") va Bang 5
-- (47 hoa don, 120 ve, 17.970.000 d cua ST1042). Bang 3 chi giu thu tu
-- ba phim, khong tai tao du 189 suat chieu.
-- Khong co khach hang Nguyễn Thị B / 0987654321 / b.nguyen@gmail.com:
-- de danh cho kich ban dang ki thu cua module 1.
-- Mat khau luu dang chu thuong (plaintext) giong doRegister6.jsp.
-- =====================================================================
INSERT INTO tblmembershiprank6(id, name, minpoints, discountrate, description) VALUES
  (1, 'Thường', 0,    0.00, 'Hạng mặc định khi đăng kí thành viên'),
  (2, 'Bạc',    500,  0.05, 'Tích luỹ từ 500 điểm, giảm 5% mỗi hoá đơn'),
  (3, 'Vàng',   2000, 0.10, 'Tích luỹ từ 2000 điểm, giảm 10% mỗi hoá đơn');

INSERT INTO tblfullname6(id, firstname, middlename, lastname) VALUES
  (1, 'Nguyễn', 'Văn', 'A'),
  (2, 'Trần',   'Văn', 'C'),
  (3, 'Lê',     'Văn', 'D'),
  (4, 'Phạm',   'Thị', 'E'),
  (5, 'Hoàng',  'Văn', 'G');

INSERT INTO tbladdress6(id, street, ward, district, city) VALUES
  (1, '12 Trần Phú',     'Mộ Lao',      'Hà Đông',  'Hà Nội'),
  (2, '45 Quang Trung',  'Yết Kiêu',    'Hà Đông',  'Hà Nội'),
  (3, '8 Nguyễn Trãi',   'Thanh Xuân Bắc', 'Thanh Xuân', 'Hà Nội'),
  (4, '21 Lê Lợi',       'Nguyễn Trãi', 'Hà Đông',  'Hà Nội'),
  (5, '3 Hoàng Quốc Việt', 'Nghĩa Đô',  'Cầu Giấy', 'Hà Nội');

INSERT INTO tblperson6(id, username, password, dateofbirth, phone, email, status, note,
                       tblfullname6id, tbladdress6id) VALUES
  (1, 'quanli6',    'quanli6@2026',  '1990-04-12', '0901000001', 'quanli6@cineman6.vn',  'ACTIVE', 'Nhân viên quản lí A', 1, 1),
  (2, 'banhang6',   'banhang6@2026', '1998-09-20', '0901000002', 'banhang6@cineman6.vn', 'ACTIVE', 'Nhân viên bán hàng C', 2, 2),
  (3, '0912000088', 'levand2025',    '1995-02-03', '0912000088', 'le.d@gmail.com',       'ACTIVE', NULL, 3, 3),
  (4, '0912000101', 'phamthie2026',  '2001-11-30', '0912000101', 'pham.e@gmail.com',     'ACTIVE', NULL, 4, 4),
  (5, '0912000015', 'hoangvang2024', '1988-06-15', '0912000015', 'hoang.g@gmail.com',    'ACTIVE', NULL, 5, 5);

INSERT INTO tblemployee6(tblperson6id, employeecode, position, hiredate) VALUES
  (1, 'NV001', 'Quản lí',    '2024-01-02'),
  (2, 'NV002', 'Bán hàng',   '2025-03-01');
INSERT INTO tblmanager6(tblemployee6id, managementlevel) VALUES (1, 'Rạp');
INSERT INTO tblsalesperson6(tblemployee6id, countercode, workshift) VALUES (2, 'Q01', 'Tối');

INSERT INTO tblcustomer6(tblperson6id, customercode, registereddate, points, tblmembershiprank6id) VALUES
  (3, 'MB2025000088', '2025-05-10', 820,  2),
  (4, 'MB2026000101', '2026-06-01', 120,  1),
  (5, 'MB2024000015', '2024-02-14', 2350, 3);

INSERT INTO tblmovie6(id, title, director, mainactors, duration, releasedate, agerating, synopsis, status) VALUES
  (1, 'Mắt Biếc 2', 'Victor Vũ', 'Trần Nghĩa, Trúc Anh', 135, '2026-07-24', 'T13',
      'Phần tiếp theo câu chuyện tình đầu ở làng Đo Đo.', 'SHOWING'),
  (2, 'Kẻ Trộm Mặt Trăng 5', 'Chris Renaud', 'Steve Carell', 95, '2026-07-01', 'P',
      'Gru và các Minion trong một phi vụ mới.', 'SHOWING'),
  (3, 'Nhà Bà Nữ 2', 'Trấn Thành', 'Lê Giang, Uyển Ân', 120, '2026-06-20', 'T16',
      'Chuyện gia đình bà Nữ sau nhiều năm.', 'SHOWING');

-- Them 7 phim, 21 suat chieu thang 8 de xem thong ke (doanh thu moi phim deu thap hon 3 phim cua Bang 3)
INSERT INTO tblmovie6(id, title, director, mainactors, duration, releasedate, agerating, synopsis, status) VALUES
  (4, 'Hẻm Cụt', 'Nguyễn Minh Tâm', 'Quang Tuấn, Hồng Ánh', 110, '2026-07-10', 'T16',
      'Một đêm mất điện trong con hẻm nhỏ giữa lòng thành phố.', 'SHOWING'),
  (5, 'Mùa Hè Ở Phố Cổ', 'Lê Thanh Hà', 'Kaity Nguyễn, Hứa Vĩ Văn', 105, '2026-07-17', 'P',
      'Chuyện tình mùa hè của hai người trẻ ở Hội An.', 'SHOWING'),
  (6, 'Biệt Đội Sấm Sét', 'Đỗ Quang Huy', 'Thanh Sơn, Ngô Kiến Huy', 125, '2026-07-31', 'T13',
      'Nhóm cứu hộ đối mặt với cơn bão lớn nhất thập kỉ.', 'SHOWING'),
  (7, 'Con Đường Cát Trắng', 'Phạm Hoài Nam', 'Thu Trang, Tiến Luật', 100, '2026-08-01', 'P',
      'Hành trình xuyên miền Trung của một gia đình.', 'SHOWING'),
  (8, 'Bí Mật Tầng 13', 'Trần Bảo Khánh', 'Diễm My, Hồng Đào', 98, '2026-08-07', 'T18',
      'Những tiếng động lạ trong toà chung cư cũ.', 'SHOWING'),
  (9, 'Chuyến Tàu Cuối Năm', 'Vũ Ngọc Lan', 'NSND Kim Xuân, Trấn Thành', 115, '2026-08-14', 'P',
      'Những vị khách tình cờ gặp nhau trên chuyến tàu Bắc Nam.', 'SHOWING'),
  (10, 'Cô Gái Đến Từ Sao Hoả', 'Hoàng Anh Đức', 'Ninh Dương Lan Ngọc', 92, '2026-08-21', 'P',
      'Phim hoạt hình phiêu lưu cho cả gia đình.', 'SHOWING');

INSERT INTO tblscreeningroom6(id, name, capacity, description) VALUES
  (1, 'P01', 150, 'Phòng chiếu 2D/3D lớn'),
  (2, 'P02', 100, 'Phòng chiếu 2D/3D vừa'),
  (3, 'P03', 120, 'Phòng chiếu IMAX');

INSERT INTO tbltimeslot6(id, name, starthour, endhour, pricefactor) VALUES
  (1, 'Sáng',  8,  12, 0.9),
  (2, 'Chiều', 12, 18, 1.0),
  (3, 'Tối',   18, 24, 1.2);

INSERT INTO tblshowformat6(id, name, pricefactor, description) VALUES
  (1, '2D',   1.0, 'Định dạng tiêu chuẩn'),
  (2, '3D',   1.2, 'Cần kính 3D'),
  (3, 'IMAX', 1.5, 'Màn hình IMAX');

INSERT INTO tblsaleschannel6(id, name, description) VALUES
  (1, 'Tại quầy',   'Bán trực tiếp tại quầy'),
  (2, 'Trực tuyến', 'Đặt vé qua website');

-- Thu tuc tam de sinh du lieu, xoa ngay sau khi dung
DELIMITER $$
CREATE PROCEDURE taoNgayChieu6(IN p_from DATE, IN p_to DATE)
BEGIN
  DECLARE d DATE;
  SET d = p_from;
  WHILE d <= p_to DO
    INSERT INTO tblshowdate6(showdate, dayofweek, isholiday, pricefactor)
    VALUES (d,
            ELT(DAYOFWEEK(d), 'Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư',
                              'Thứ năm', 'Thứ sáu', 'Thứ bảy'),
            0,
            IF(DAYOFWEEK(d) IN (1, 7), 1.1, 1.0));
    SET d = DATE_ADD(d, INTERVAL 1 DAY);
  END WHILE;
END$$

-- Sinh p_ninv hoa don (khong chiet khau, khach vang lai) chia deu p_ntk ve
-- cho suat chieu p_code; so hoa don bat dau tu p_seq0, so ve tu p_tk0,
-- thoi diem lap bat dau tu p_t0, moi hoa don cach nhau 1 phut.
-- Hoa don thu chan (0, 2, ...): tai quay, nhan vien id 2, khach vang lai;
-- hoa don thu le: truc tuyen, khong co nhan vien, khach thanh vien id 4.
CREATE PROCEDURE sinhHoadon6(IN p_code VARCHAR(20), IN p_ninv INT, IN p_ntk INT,
                             IN p_seq0 INT, IN p_tk0 INT, IN p_t0 DATETIME)
BEGIN
  DECLARE v_st, v_i, v_j, v_n, v_inv, v_tk INT;
  DECLARE v_price BIGINT;
  DECLARE v_day VARCHAR(8);
  DECLARE v_at DATETIME;
  SELECT id, baseprice, DATE_FORMAT(starttime, '%Y%m%d')
    INTO v_st, v_price, v_day
    FROM tblshowtime6 WHERE showtimecode = p_code;
  SET v_i = 0;
  SET v_tk = p_tk0;
  WHILE v_i < p_ninv DO
    SET v_n = FLOOR(p_ntk / p_ninv) + IF(v_i < MOD(p_ntk, p_ninv), 1, 0);
    SET v_at = DATE_ADD(p_t0, INTERVAL v_i MINUTE);
    INSERT INTO tblinvoice6(invoiceno, createdat, totalamount, discountamount, finalamount, status,
                            tblshowtime6id, tblcustomer6id, tblsalesperson6id, tblsaleschannel6id)
    VALUES (CONCAT('HD', v_day, '-', LPAD(p_seq0 + v_i, 3, '0')), v_at,
            v_n * v_price, 0, v_n * v_price, 'PAID', v_st,
            -- truc tuyen bat buoc la thanh vien da dang nhap (A4, A9): gan khach id 4, hang Thuong (khong giam)
            IF(MOD(v_i, 2) = 0, NULL, 4),
            IF(MOD(v_i, 2) = 0, 2, NULL), IF(MOD(v_i, 2) = 0, 1, 2));
    SET v_inv = LAST_INSERT_ID();
    SET v_j = 0;
    WHILE v_j < v_n DO
      INSERT INTO tblticket6(ticketcode, price, status, issuedat, tblinvoice6id, tblshowtime6id)
      VALUES (CONCAT('VE', SUBSTRING(p_code, 3), '-', LPAD(v_tk, 3, '0')), v_price, 'SOLD', v_at, v_inv, v_st);
      SET v_tk = v_tk + 1;
      SET v_j = v_j + 1;
    END WHILE;
    SET v_i = v_i + 1;
  END WHILE;
END$$
DELIMITER ;

CALL taoNgayChieu6('2026-08-01', '2026-08-31');
CALL taoNgayChieu6('2026-09-02', '2026-09-02');

-- Suat chieu: (ma, bat dau, ket thuc, gia goc, phim, phong, khung gio, dinh dang)
INSERT INTO tblshowtime6(showtimecode, starttime, endtime, baseprice, status,
                         tblmovie6id, tblscreeningroom6id, tblshowdate6id,
                         tbltimeslot6id, tblshowformat6id)
SELECT x.code, x.t1, x.t2, x.price, 'FINISHED', x.movie, x.room, sd.id, x.slot, x.fmt
  FROM (
    SELECT 'ST1042' AS code, TIMESTAMP('2026-08-03 19:30:00') AS t1, TIMESTAMP('2026-08-03 21:45:00') AS t2, 150000 AS price, 1 AS movie, 3 AS room, 3 AS slot, 3 AS fmt
    UNION ALL SELECT 'ST1050', '2026-08-05 09:30:00', '2026-08-05 11:05:00',  80000, 2, 1, 1, 1
    UNION ALL SELECT 'ST1060', '2026-08-07 19:00:00', '2026-08-07 21:00:00',  90000, 3, 1, 3, 1
    UNION ALL SELECT 'ST1078', '2026-08-10 20:00:00', '2026-08-10 22:15:00',  90000, 1, 1, 3, 1
    UNION ALL SELECT 'ST1090', '2026-08-12 14:00:00', '2026-08-12 15:35:00', 100000, 2, 2, 2, 2
    UNION ALL SELECT 'ST1105', '2026-08-17 14:00:00', '2026-08-17 16:15:00', 110000, 1, 2, 2, 2
    UNION ALL SELECT 'ST1120', '2026-08-21 20:00:00', '2026-08-21 22:00:00', 140000, 3, 3, 3, 3
    UNION ALL SELECT 'ST1131', '2026-08-24 19:30:00', '2026-08-24 21:45:00', 150000, 1, 3, 3, 3
    UNION ALL SELECT 'ST1150', '2026-09-02 09:30:00', '2026-09-02 11:05:00',  80000, 2, 1, 1, 1
    -- 21 suat cua 7 phim them
    UNION ALL SELECT 'ST2001', '2026-08-02 20:00:00', '2026-08-02 21:50:00', 90000, 4, 1, 3, 1
    UNION ALL SELECT 'ST2002', '2026-08-09 19:00:00', '2026-08-09 20:50:00', 108000, 4, 2, 3, 2
    UNION ALL SELECT 'ST2003', '2026-08-16 14:30:00', '2026-08-16 16:20:00', 80000, 4, 1, 2, 1
    UNION ALL SELECT 'ST2004', '2026-08-04 09:00:00', '2026-08-04 10:45:00', 72000, 5, 2, 1, 1
    UNION ALL SELECT 'ST2005', '2026-08-11 15:00:00', '2026-08-11 16:45:00', 80000, 5, 1, 2, 1
    UNION ALL SELECT 'ST2006', '2026-08-25 19:30:00', '2026-08-25 21:15:00', 96000, 5, 2, 3, 1
    UNION ALL SELECT 'ST2007', '2026-08-01 19:00:00', '2026-08-01 21:05:00', 150000, 6, 3, 3, 3
    UNION ALL SELECT 'ST2008', '2026-08-08 20:30:00', '2026-08-08 22:35:00', 165000, 6, 3, 3, 3
    UNION ALL SELECT 'ST2009', '2026-08-22 14:00:00', '2026-08-22 16:05:00', 100000, 6, 1, 2, 2
    UNION ALL SELECT 'ST2010', '2026-08-06 09:30:00', '2026-08-06 11:10:00', 72000, 7, 1, 1, 1
    UNION ALL SELECT 'ST2011', '2026-08-13 15:30:00', '2026-08-13 17:10:00', 80000, 7, 2, 2, 1
    UNION ALL SELECT 'ST2012', '2026-08-27 18:30:00', '2026-08-27 20:10:00', 96000, 7, 1, 3, 1
    UNION ALL SELECT 'ST2013', '2026-08-08 21:00:00', '2026-08-08 22:38:00', 96000, 8, 2, 3, 1
    UNION ALL SELECT 'ST2014', '2026-08-15 21:30:00', '2026-08-15 23:08:00', 105600, 8, 2, 3, 1
    UNION ALL SELECT 'ST2015', '2026-08-29 22:00:00', '2026-08-29 23:38:00', 96000, 8, 1, 3, 1
    UNION ALL SELECT 'ST2016', '2026-08-14 19:00:00', '2026-08-14 20:55:00', 96000, 9, 1, 3, 1
    UNION ALL SELECT 'ST2017', '2026-08-20 14:00:00', '2026-08-20 15:55:00', 80000, 9, 2, 2, 1
    UNION ALL SELECT 'ST2018', '2026-08-28 19:30:00', '2026-08-28 21:25:00', 150000, 9, 3, 3, 3
    UNION ALL SELECT 'ST2019', '2026-08-21 09:00:00', '2026-08-21 10:32:00', 86400, 10, 2, 1, 2
    UNION ALL SELECT 'ST2020', '2026-08-23 10:00:00', '2026-08-23 11:32:00', 79200, 10, 1, 1, 1
    UNION ALL SELECT 'ST2021', '2026-08-30 15:00:00', '2026-08-30 16:32:00', 110000, 10, 2, 2, 2
  ) x
  JOIN tblshowdate6 sd ON sd.showdate = DATE(x.t1)
 ORDER BY x.t1;

-- ST1042: ba hoa don dau cua Bang 5 (Nguyễn Thị B duoc thay bang Phạm Thị E)
SET @st = (SELECT id FROM tblshowtime6 WHERE showtimecode = 'ST1042');

INSERT INTO tblinvoice6(invoiceno, createdat, totalamount, discountamount, finalamount, status,
                        tblshowtime6id, tblcustomer6id, tblsalesperson6id, tblsaleschannel6id)
VALUES ('HD20260803-011', '2026-08-03 18:05:00', 300000, 0, 300000, 'PAID', @st, 4, 2, 1);
SET @hd = LAST_INSERT_ID();
INSERT INTO tblticket6(ticketcode, price, status, issuedat, tblinvoice6id, tblshowtime6id) VALUES
  ('VE1042-001', 150000, 'SOLD', '2026-08-03 18:05:00', @hd, @st),
  ('VE1042-002', 150000, 'SOLD', '2026-08-03 18:05:00', @hd, @st);

INSERT INTO tblinvoice6(invoiceno, createdat, totalamount, discountamount, finalamount, status,
                        tblshowtime6id, tblcustomer6id, tblsalesperson6id, tblsaleschannel6id)
VALUES ('HD20260803-012', '2026-08-03 18:11:00', 600000, 30000, 570000, 'PAID', @st, 3, NULL, 2);
SET @hd = LAST_INSERT_ID();
INSERT INTO tblticket6(ticketcode, price, status, issuedat, tblinvoice6id, tblshowtime6id) VALUES
  ('VE1042-003', 150000, 'SOLD', '2026-08-03 18:11:00', @hd, @st),
  ('VE1042-004', 150000, 'SOLD', '2026-08-03 18:11:00', @hd, @st),
  ('VE1042-005', 150000, 'SOLD', '2026-08-03 18:11:00', @hd, @st),
  ('VE1042-006', 150000, 'SOLD', '2026-08-03 18:11:00', @hd, @st);

INSERT INTO tblinvoice6(invoiceno, createdat, totalamount, discountamount, finalamount, status,
                        tblshowtime6id, tblcustomer6id, tblsalesperson6id, tblsaleschannel6id)
VALUES ('HD20260803-013', '2026-08-03 18:24:00', 300000, 0, 300000, 'PAID', @st, NULL, 2, 1);
SET @hd = LAST_INSERT_ID();
INSERT INTO tblticket6(ticketcode, price, status, issuedat, tblinvoice6id, tblshowtime6id) VALUES
  ('VE1042-007', 150000, 'SOLD', '2026-08-03 18:24:00', @hd, @st),
  ('VE1042-008', 150000, 'SOLD', '2026-08-03 18:24:00', @hd, @st);

-- 44 hoa don con lai cua ST1042: 112 ve (24 x 3 + 20 x 2)
CALL sinhHoadon6('ST1042', 44, 112, 14, 9, '2026-08-03 18:30:00');
-- Hai suat con lai cua Bang 4
CALL sinhHoadon6('ST1078', 40, 96, 1, 1, '2026-08-10 18:30:00');
CALL sinhHoadon6('ST1105', 20, 45, 1, 1, '2026-08-17 12:50:00');
-- Hai phim con lai (doanh thu nho hon, giu thu tu Bang 3)
CALL sinhHoadon6('ST1050', 25, 60, 1, 1, '2026-08-05 08:30:00');
CALL sinhHoadon6('ST1090', 22, 50, 1, 1, '2026-08-12 13:00:00');
CALL sinhHoadon6('ST1060', 30, 70, 1, 1, '2026-08-07 18:00:00');
CALL sinhHoadon6('ST1120', 10, 20, 1, 1, '2026-08-21 19:30:00');
-- Ngoai khoang 01/08 - 31/08: khong duoc tinh vao thong ke thang 8
CALL sinhHoadon6('ST1150', 5, 10, 1, 1, '2026-09-02 08:45:00');
-- ST1131 khong co hoa don nao: dung de thu ngoai le 10a / 32a
-- Hoa don cua 21 suat chieu them (7 phim moi)
CALL sinhHoadon6('ST2001', 12, 30, 101, 1, '2026-08-02 19:00:00');
CALL sinhHoadon6('ST2002', 9, 22, 131, 1, '2026-08-09 18:00:00');
CALL sinhHoadon6('ST2003', 6, 15, 161, 1, '2026-08-16 13:30:00');
CALL sinhHoadon6('ST2004', 8, 18, 191, 1, '2026-08-04 08:00:00');
CALL sinhHoadon6('ST2005', 10, 25, 221, 1, '2026-08-11 14:00:00');
CALL sinhHoadon6('ST2006', 12, 28, 251, 1, '2026-08-25 18:30:00');
CALL sinhHoadon6('ST2007', 10, 24, 281, 1, '2026-08-01 18:00:00');
CALL sinhHoadon6('ST2008', 8, 18, 311, 1, '2026-08-08 19:30:00');
CALL sinhHoadon6('ST2009', 8, 20, 341, 1, '2026-08-22 13:00:00');
CALL sinhHoadon6('ST2010', 5, 12, 371, 1, '2026-08-06 08:30:00');
CALL sinhHoadon6('ST2011', 7, 16, 401, 1, '2026-08-13 14:30:00');
CALL sinhHoadon6('ST2012', 8, 20, 431, 1, '2026-08-27 17:30:00');
CALL sinhHoadon6('ST2013', 11, 26, 461, 1, '2026-08-08 20:00:00');
CALL sinhHoadon6('ST2014', 12, 30, 491, 1, '2026-08-15 20:30:00');
CALL sinhHoadon6('ST2015', 6, 14, 521, 1, '2026-08-29 21:00:00');
CALL sinhHoadon6('ST2016', 14, 35, 551, 1, '2026-08-14 18:00:00');
CALL sinhHoadon6('ST2017', 4, 10, 581, 1, '2026-08-20 13:00:00');
CALL sinhHoadon6('ST2018', 8, 18, 611, 1, '2026-08-28 18:30:00');
CALL sinhHoadon6('ST2019', 9, 22, 641, 1, '2026-08-21 08:00:00');
CALL sinhHoadon6('ST2020', 11, 26, 671, 1, '2026-08-23 09:00:00');
CALL sinhHoadon6('ST2021', 12, 30, 701, 1, '2026-08-30 14:00:00');

DROP PROCEDURE taoNgayChieu6;
DROP PROCEDURE sinhHoadon6;
