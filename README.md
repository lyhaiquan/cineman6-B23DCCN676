# CineMan 6 — Hệ thống quản lí rạp chiếu phim

Bài tập môn Phân tích và Thiết kế Hệ thống Thông tin (PTIT), đề 16. Hậu tố tên lớp: `6`.

Mã nguồn cài đặt hai module của bài, đúng theo các biểu đồ thiết kế trong báo cáo:

| Module | Use case | Biểu đồ lớp thiết kế | Kịch bản |
|---|---|---|---|
| 1 | Khách hàng đăng kí thành viên (Register Membership 6) | Hình 15 | v.3, 26 bước |
| 2 | Nhân viên quản lí xem thống kê phim theo doanh thu (View Movie Revenue Statistics 6) | Hình 16 | v.3, 33 bước |

Công nghệ: JSP + JDBC + stored procedure (không servlet, không framework), Java 17, Tomcat 9, MariaDB 10.11 / MySQL 8.

## Cấu trúc

```
src/model/       lớp thực thể (khớp Hình 15, 16, 23)
src/dao/         DAO6 (lớp cha, giữ #con) và 5 lớp DAO của hai module
WebContent/
  khachhang/     module 1: gdCustomerHome6, gdRegisterMember6, doRegister6, gdRegisterResult6
  quanli/        module 2: gdManagerHome6, gdSelectReport6, gdMovieRevenueStat6,
                           gdShowtimeStat6, gdInvoiceStat6
  gdLogin6.jsp   trang đăng nhập thử (ngoài phạm vi hai module, theo giả định A23)
  css/           một file CSS tối giản
sql/cineman6.sql tạo CSDL, bảng, stored procedure và dữ liệu mẫu
build.ps1        biên dịch src/ vào WebContent/WEB-INF/classes
```

Mỗi phần tử HTML có `id` và `name` trùng tên thuộc tính của lớp giao diện trong biểu đồ (tiền tố `in`, `out`, `sub`, `inout`, `outsub`). Mỗi bước kịch bản v.3 có chú thích `// buoc N` tại dòng code tương ứng.

## Luồng

**Module 1:** trang chủ → `subRegister` → biểu mẫu 7 ô → kiểm tra định dạng (5a) và tuổi ≥ 13 (5b) → `doRegister6.jsp`: `CustomerDAO6.checkExistedAccount()` (trùng → 9a) → `MembershipRankDAO6.getDefaultRank()` → `CustomerDAO6.addCustomer()` (lỗi → 21a) → trang kết quả → `subHome` về trang chủ. `subCancel` về trang chủ, không lưu.

**Module 2:** đăng nhập → trang chủ quản lí → `subViewReport` → chọn loại thống kê (`inoutReportType`) → `subContinue` → chọn khoảng ngày → `subView` → bảng phim (`MovieStatisticDAO6.getMovieRevenueStat()`) → click một phim → bảng suất chiếu (`ShowtimeStatisticDAO6.getShowtimeStatOfMovie()`) → click một suất chiếu → bảng hoá đơn (`InvoiceStatisticDAO6.getInvoiceStatOfShowtime()`). Mọi trang có `subBack` quay về giao diện ngay trước.

## Chạy thử

1. Tạo CSDL (lệnh này **xoá** CSDL `cineman6` nếu đã có):
   ```
   mysql -uroot -p --default-character-set=utf8mb4 -e "source sql/cineman6.sql"
   ```
2. Tải MySQL Connector/J 8.4.0, chép `mysql-connector-j-8.4.0.jar` vào `WebContent/WEB-INF/lib/`.
3. Biên dịch: `powershell -ExecutionPolicy Bypass -File build.ps1` (sửa đường dẫn `javac` trong file nếu cần).
4. Đặt biến môi trường cho Tomcat (không ghi mật khẩu vào mã nguồn):
   ```
   set CINEMAN6_DB_USER=root
   set CINEMAN6_DB_PASS=<mật khẩu MariaDB/MySQL>
   rem tuỳ chọn: set CINEMAN6_DB_URL=jdbc:mysql://localhost:3306/cineman6?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8
   ```
5. Chép thư mục `WebContent` vào `webapps/cineman6` của Tomcat rồi khởi động Tomcat.
6. Mở `http://localhost:8080/cineman6/` (module 1) và `http://localhost:8080/cineman6/gdLogin6.jsp` (module 2).

### Chạy bằng terminal PowerShell (ví dụ terminal của VS Code)

Sửa đường dẫn Tomcat, JDK cho đúng máy của bạn. Các biến môi trường phải đặt trong cùng cửa sổ terminal với lệnh `startup.bat`.

```powershell
# 1. tạo CSDL (hỏi mật khẩu)
& "C:\Program Files\MariaDB 10.11\bin\mysql.exe" -uroot -p --default-character-set=utf8mb4 -e "source sql/cineman6.sql"

# 2. biên dịch src/ (cần mysql-connector-j-8.4.0.jar trong WebContent/WEB-INF/lib)
powershell -ExecutionPolicy Bypass -File build.ps1

# 3. chép sang Tomcat
$tomcat = "D:\tomcat9\apache-tomcat-9.0.124"
New-Item -ItemType Directory -Force "$tomcat\webapps\cineman6" | Out-Null
Copy-Item -Recurse -Force WebContent\* "$tomcat\webapps\cineman6\"

# 4. đặt biến môi trường rồi bật Tomcat
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot"
$env:CINEMAN6_DB_USER = "root"
$env:CINEMAN6_DB_PASS = "<mật khẩu>"
& "$tomcat\bin\startup.bat"
```

Tắt Tomcat: `& "$tomcat\bin\shutdown.bat"`. Sửa JSP, CSS thì chỉ cần chép lại (bước 3) rồi tải lại trang; sửa Java thì biên dịch, chép lại và khởi động lại Tomcat.

## Dữ liệu mẫu

- Đăng kí thử theo kịch bản: Nguyễn Thị B, 0987654321, b.nguyen@gmail.com (chưa có trong CSDL). Đăng kí lần hai với cùng số điện thoại sẽ ra thông báo "Số điện thoại hoặc email đã được đăng kí."
- Thống kê: chọn 01/08/2026 – 31/08/2026; phim "Mắt Biếc 2", suất ST1042 có 47 hoá đơn, 120 vé, 17.970.000 đồng. Suất ST1131 chưa có hoá đơn (thử ngoại lệ). Chọn tháng 01/2025 để thử trường hợp không có dữ liệu.
- Hoá đơn tại quầy luôn có nhân viên lập, có thể là khách vãng lai; hoá đơn trực tuyến luôn gắn khách thành viên, không có nhân viên lập.
- Có 10 phim, 30 suất chiếu (29 suất trong tháng 8/2026), 389 hoá đơn. Ba phim đầu khớp thứ tự Bảng 3; 7 phim thêm (ST2001–ST2021, mỗi phim 3 suất) có doanh thu thấp hơn để bảng thống kê dài hơn. Thống kê 01/08/2026 – 31/08/2026 ra 10 phim, 920 vé, 96.482.000 đồng.
- Số phim, số suất của dữ liệu mẫu nhỏ hơn số liệu minh hoạ trong báo cáo; riêng suất ST1042 và ba hoá đơn đầu khớp Bảng 4, Bảng 5.

## Ngoài phạm vi

Đăng nhập thật, đăng xuất, thống kê khách hàng và thống kê doanh thu toàn rạp không thuộc hai module này. Ở giao diện chọn loại thống kê, chọn hai loại đó thì trang giữ nguyên.
