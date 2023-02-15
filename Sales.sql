SE master
CREATE DATABASE Sales
-- ON
-- PRIMARY
-- (
-- NAME = tuan1_data,
-- FILENAME =&#39;T:\ThucHanhSQL\tuan1_data.mdf&#39;,
-- SIZE = 10MB,
-- MAXSIZE = 20MB,
-- FILEGROWTH = 20%
-- )
-- LOG ON
-- (
-- NAME = tuan1_log,
-- FILENAME = &#39;T:\ThucHanhSQL\tuan1_log.ldf&#39;,
-- SIZE = 10MB,
-- MAXSIZE = 20MB,
-- FILEGROWTH = 20%
-- )
USE Sales
-- 1. Kiểu dữ liệu tự định nghĩa
EXEC sp_addtype 'Mota','NVARCHAR(40)';
EXEC sp_addtype 'IDKH', 'CHAR(10)', 'NOT NULL'
EXEC sp_addtype 'DT', 'CHAR(12)';
-- 2. Tạo table
CREATE TABLE SanPham (
MaSP CHAR(6) NOT NULL,
TenSP VARCHAR(20),
NgayNhap Date,
DVT CHAR(10),
SoLuongTon INT,
DonGiaNhap money,
)
CREATE TABLE HoaDon (
MaHD CHAR(10) NOT NULL,
NgayLap Date,
NgayGiao Date,
MaKH IDKH,
DienGiai Mota,
)
CREATE TABLE KhachHang (
MaKH IDKH,
TenKH NVARCHAR(30),
DiaCHi NVARCHAR(40),
DienThoai DT,
)
CREATE TABLE ChiTietHD (
MaHD CHAR(10) NOT NULL,
MaSP CHAR(6) NOT NULL,
SoLuong INT
)

-- 3. Trong Table HoaDon, sửa cột DienGiai thành nvarchar(100).
ALTER TABLE HoaDon
ALTER COLUMN DienGiai NVARCHAR(100)

-- 4. Thêm vào bảng SanPham cột TyLeHoaHong float
ALTER TABLE SanPham
ADD TyLeHoaHong float

-- 5. Xóa cột NgayNhap trong bảng SanPham
ALTER TABLE SanPham
DROP COLUMN NgayNhap

--6. Tạo các ràng buộc khóa chính và khóa ngoại cho các bảng trên
ALTER TABLE SanPham ADD CONSTRAINT PK_SanPham PRIMARY KEY (MaSP);
ALTER TABLE HoaDon ADD CONSTRAINT PK_HoaDon PRIMARY KEY (MaHD);
ALTER TABLE KhachHang ADD CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH);
ALTER TABLE ChiTietHD ADD CONSTRAINT FK_ChiTietHoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD);
ALTER TABLE ChiTietHD ADD CONSTRAINT FK_ChiTietSanPham FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP);
ALTER TABLE ChiTietHD ADD CONSTRAINT PK_ChiTietHD PRIMARY KEY (MaHD,MaSP);
ALTER TABLE HoaDon ADD CONSTRAINT FK_HoaDonKhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH);

--7. Thêm vào bảng HoaDon các ràng buộc sau:
---NgayGiao >= NgayLap
ALTER TABLE HoaDon ADD CONSTRAINT CHECK_NgayGiao CHECK (NgayGiao>=NgayLap)
---MaHD gồm 6 ký tự, 2 ký tự đầu là chữ, các ký tự còn lại là số
ALTER TABLE HoaDon ADD CONSTRAINT chk_MaHD CHECK (MaHD LIKE '[a-zA-Z][a-zA-Z0-9][0-9][0-9][0-9][0-9]')
---Giá trị mặc định ban đầu cho cột NgayLap luôn luôn là ngày hiện hành
ALTER TABLE HoaDon ADD CONSTRAINT df_Ngay_Lap DEFAULT GETDATE() FOR NgayLap;

--8. Thêm vào bảng Sản phẩm các ràng buộc sau:
---SoLuongTon chỉ nhập từ 0 đến 500
ALTER TABLE SanPham ADD CONSTRAINT CHECK_SoLuongTon CHECK(0<=SoLuongTon and SoLuongTon>=500)
---DonGiaNhap lớn hơn 0
ALTER TABLE SanPham ADD CONSTRAINT CHECK_DonGiaNhap CHECK(DonGiaNhap>0)
---Giá trị mặc định cho NgayNhap là ngày hiện hành
ALTER TABLE SanPham ADD NgayNhap date
ALTER TABLE SanPham ADD CONSTRAINT df_Ngay_Nhap DEFAULT GETDATE() FOR NgayNhap;
---DVT chỉ nhập vào các giá trị ‘KG’, ‘Thùng’, ‘Hộp’, ‘Cái’
ALTER TABLE SanPham ADD CONSTRAINT CHECK_DVT CHECK(DVT='KG'OR DVT='THÙNG'OR DVT='HOP'OR DVT='CAI')

--9. Dùng lệnh T-SQL nhập dữ liệu vào 4 table trên, dữ liệu tùy ý, chú ý các ràng buộc của mỗi Table
--Sản Phẩm
insert into SanPham (MaSP, TenSP, NgayNhap, DVT, SoLuongTon, DonGiaNhap)
values ('A001', 'Bút bi', '10/02/2023', 'hộp', 200, '5000')
insert into SanPham (MaSP, TenSP, NgayNhap, DVT, SoLuongTon, DonGiaNhap)
values ('A002', 'Mì gói', '10/02/2023', 'thùng', 100, '120000')
insert into SanPham (MaSP, TenSP, NgayNhap, DVT, SoLuongTon, DonGiaNhap)
values ('A003', 'Đường', '10/02/2023', 'kg', 20, '20000')
insert into SanPham (MaSP, TenSP, NgayNhap, DVT, SoLuongTon, DonGiaNhap)
values ('A004', 'Vợt', '10/02/2023', 'cái', 10, '25000')
--Hóa Đơn
insert into HoaDon(MaHD, NgayLap, NgayGiao, MaKH, DienGiai)
values ('AA01', '14/02/2023', '15/02/2023', 'KH01', 'Thanks')
insert into HoaDon(MaHD, NgayLap, NgayGiao, MaKH, DienGiai)
values ('AA02', '13/02/2023', '14/02/2023', 'KH02', 'Thanks')
insert into HoaDon(MaHD, NgayLap, NgayGiao, MaKH, DienGiai)
values ('AA03', '12/02/2023', '13/02/2023', 'KH03', 'Thanks')
insert into HoaDon(MaHD, NgayLap, NgayGiao, MaKH, DienGiai)
values ('AA04', '11/02/2023', '12/02/2023', 'KH04', 'Thanks')
--Khách Hàng
insert into KhachHang(MaKH, TenKH, DiaCHi, DienThoai)
values ('KH01', N'Nguyễn Văn A', 'Phường 5, Tân Bình', '0123398645')
insert into KhachHang(MaKH, TenKH, DiaCHi, DienThoai)
values ('KH02', N'Trần Thị B', 'Phường 12, Tân Phú', '0936946235')
insert into KhachHang(MaKH, TenKH, DiaCHi, DienThoai)
values ('KH03', N'Võ Đông H', 'Bình Thạnh', '0936923235')
insert into KhachHang(MaKH, TenKH, DiaCHi, DienThoai)
values ('KH04', N'Nguyễn Minh T','Đồng Nai', '0936946125')
--Chi tiết Hóa Đơn
insert into ChiTietHD(MaHD, MaSP, SoLuong)
values ('AA01', 'A001', 12)
insert into ChiTietHD(MaHD, MaSP, SoLuong)
values ('AA02', 'A002', 5)
insert into ChiTietHD(MaHD, MaSP, SoLuong)
values ('AA03', 'A003', 2)
insert into ChiTietHD(MaHD, MaSP, SoLuong)
values ('AA04', 'A004', 1)
--10.Xóa 1 hóa đơn bất kỳ trong bảng HoaDon. Có xóa được không? Tại sao? Nếu vẫn muốn xóa thì phải dùng cách nào?


--11.Nhập 2 bản ghi mới vào bảng ChiTietHD với MaHD = ‘HD999999999’ và MaHD=’1234567890’. Có nhập được không? Tại sao?


--12.Đổi tên CSDL Sales thành BanHang


--13.Tạo thư mục T:\QLBH, chép CSDL BanHang vào thư mục này, bạn có sao chép được không? Tại sao? Muốn sao chép được bạn phải làm gì? Sau khi sao chép bạn thực hiện Attach vào lại SQL.

