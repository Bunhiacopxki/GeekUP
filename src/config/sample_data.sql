USE cv;

-- Thêm dữ liệu vào bàng NguoiDung
INSERT INTO NguoiDung (MatKhau, Email, HoTen, SDT, GioiTinh, DiaChi, Xa, Huyen, Tinh, LoaiNha)
VALUES ('password123', 'nguyen.a@email.com', 'Nguyen Van A', '0912345678', 'Nam', '123 Duong ABC', 'Xa ABC', 'Huyen XYZ', 'Tinh 1', 'Nhà riêng'),
       ('password456', 'le.b@email.com', 'Le Thi B', '0987654321', 'Nữ', '456 Duong DEF', 'Xa DEF', 'Huyen LMN', 'Tinh 2', 'Công ty'),
       ('pass789', 'tran.c@email.com', 'Tran Van C', '0911111111', 'Nam', '789 Duong GHI', 'Xa GHI', 'Huyen ABC', 'Tinh 3', 'Nhà riêng'),
       ('pass321', 'pham.d@email.com', 'Pham Thi D', '0944444444', 'Nữ', '101 Duong KLM', 'Xa KLM', 'Huyen XYZ', 'Tinh 4', 'Công ty'),
       ('pass111', 'ly.e@email.com', 'Ly Van E', '0955555555', 'Nam', '202 Duong NOP', 'Xa NOP', 'Huyen LMN', 'Tinh 5', 'Nhà riêng'),
       ('pass222', 'hoang.f@email.com', 'Hoang Thi F', '0966666666', 'Nữ', '303 Duong QRS', 'Xa QRS', 'Huyen OPQ', 'Tinh 6', 'Công ty'),
       ('pass333', 'vu.g@email.com', 'Vu Van G', '0977777777', 'Nam', '404 Duong TUV', 'Xa TUV', 'Huyen DEF', 'Tinh 7', 'Nhà riêng'),
       ('pass444', 'ngo.h@email.com', 'Ngo Thi H', '0988888888', 'Nữ', '505 Duong WXY', 'Xa WXY', 'Huyen KLM', 'Tinh 8', 'Công ty'),
       ('pass555', 'do.i@email.com', 'Do Van I', '0999999999', 'Nam', '606 Duong ZAB', 'Xa ZAB', 'Huyen LMN', 'Tinh 9', 'Nhà riêng'),
       ('geekup', 'gu@gmail.com', 'assessment', '328355333', 'Nam', '73 tân hoà 2', 'Phúc Lộc', 'Ba Bể', 'Bắc Kạn', 'nhà riêng'),
       ('pass666', 'phan.j@email.com', 'Phan Thi J', '0900000000', 'Nữ', '707 Duong CDE', 'Xa CDE', 'Huyen OPQ', 'Tinh 10', 'Công ty');

-- Thêm dữ liệu vào bàng DanhMuc
INSERT INTO DanhMuc (TenDanhMuc, MoTa, Anh, ThuTuHienThi)
VALUES ('Áo thun', 'Danh mục áo thun', 'anh1.jpg', 1),
       ('Áo khoác', 'Danh mục áo khoác', 'anh1.jpg', 2),
       ('Giày thời trang', 'Danh mục giày thời trang', 'anh3.jpg', 3),
       ('Dép thời trang', 'Danh mục dép thời trang', 'anh3.jpg', 4),
       ('Đồ lót', 'Danh mục đồ lót cho nam và nữ', 'anh5.jpg', 5),
       ('Quần jean', 'Danh mục quần jean thời trang', 'anh6.jpg', 6),
       ('Áo sơ mi', 'Danh mục áo sơ mi', 'anh1.jpg', 7),
       ('Giày cao gót', 'Danh mục giày cao gót', 'anh8.jpg', 8),
       ('Nón mũ', 'Danh mục nón mũ cho nam nữ', 'anh9.jpg', 9),
       ('Quần tây', 'Danh mục vớ cho nam nữ', 'anh10.jpg', 10),
       ('Đồng hồ', 'Danh mục đồng hồ cho nam nữ', 'anh11.jpg', 11);
       
-- Thêm dữ liệu vào bàng DiaChi
INSERT INTO DiaChi (Duong, ThanhPho, Quan, MoTa)
VALUES ('789 Duong GHI', 'Ha Noi', 'Quan Ba Dinh', 'Cửa hàng chính'),
       ('101 Duong KLM', 'Ho Chi Minh', 'Quan 1', 'Cửa hàng phát triển');

-- Thêm dữ liệu vào bàng CuaHang
INSERT INTO CuaHang (TenCuaHang, MaDiaChi)
VALUES ('CuaHangABC', 1),
       ('CuaHangXYZ', 2);

-- Thêm dữ liệu cho bảng SanPham
INSERT INTO SanPham (TenSanPham, MoTa, Model, GioiTinh, ThuongHieu, Gia, TyLeGiamGia, MaDanhMuc, MaCuaHang)
VALUES 
-- Cửa hàng 1
('Áo sơ mi nam', 'Áo sơ mi công sở nam', 'ASM123', 'Nam', 'Zara', 500000, 0.1, 7, 1),
('Quần tây nam', 'Quần tây công sở nam', 'QTN001', 'Nam', 'Zara', 600000, 0.05, 10, 1),
('Giày thể thao nam', 'Giày chạy bộ', 'GTN555', 'Nam', 'Nike', 1200000, 0.15, 3, 1),
('Đồng hồ nam', 'Đồng hồ thể thao nam', 'DHN456', 'Nam', 'Casio', 2000000, 0.2, 11, 1),
('Áo khoác gió', 'Áo khoác mùa đông', 'AKG111', 'Nam', 'Uniqlo', 800000, 0.1, 2, 1),

-- Cửa hàng 2
('Váy dạ hội', 'Váy dài sang trọng', 'VDH123', 'Nữ', 'Chanel', 3000000, 0.2, 2, 2),
('Quần jean nữ', 'Quần jean cao cấp', 'QJN456', 'Nữ', 'Levis', 800000, 0.1, 6, 2),
('Áo len nữ', 'Áo len mùa đông', 'ALN222', 'Nữ', 'H&M', 600000, 0.05, 2, 2),
('Giày cao gót', 'Giày cao gót nữ', 'GCG678', 'Nữ', 'Gucci', 2000000, 0.2, 8, 2),
('Túi xách nữ', 'Túi thời trang cao cấp', 'TXN888', 'Nữ', 'Louis Vuitton', 5000000, 0.25, 4, 2);

-- Thêm dữ liệu vào bảng KichThuoc
INSERT INTO KichThuoc (KichThuoc, SoLuong, MaSanPham)
VALUES 
-- Sản phẩm 1: Áo sơ mi nam
('S', 25, 1),
('M', 25, 1),
('L', 25, 1),
('XL', 
25, 1),

-- Sản phẩm 2: Quần tây nam
('S', 10, 2),
('M', 15, 2),
('L', 15, 2),
('XL', 10, 2),

-- Sản phẩm 3: Giày thể thao nam
('40', 15, 3),
('41', 20, 3),
('42', 20, 3),
('43', 15, 3),

-- Sản phẩm 4: Đồng hồ nam
('Free Size', 30, 4),
('Small', 0, 4),
('Medium', 0, 4),
('Large', 0, 4),

-- Sản phẩm 5: Áo khoác gió
('S', 50, 5),
('M', 50, 5),
('L', 50, 5),
('XL', 50, 5),

-- Sản phẩm 6: Váy dạ hội
('S', 10, 6),
('M', 10, 6),
('L', 10, 6),
('XL', 10, 6),

-- Sản phẩm 7: Quần jean nữ
('S', 40, 7),
('M', 40, 7),
('L', 40, 7),
('XL', 30, 7),

-- Sản phẩm 8: Áo len nữ
('S', 40, 8),
('M', 40, 8),
('L', 40, 8),
('XL', 30, 8),

-- Sản phẩm 9: Giày cao gót
('36', 10, 9),
('37', 10, 9),
('38', 10, 9),
('39', 10, 9),

-- Sản phẩm 10: Túi xách nữ
('Free Size', 25, 10),
('Small', 0, 10),
('Medium', 0, 10),
('Large', 0, 10);

-- Thêm dữ liệu vào bảng Thich
INSERT INTO Thich (MaNguoiMua, MaSanPham)
VALUES (1, 1),
       (2, 2);
       
-- Thêm dữ liệu vào bảng HinhAnhSanPham
INSERT INTO HinhAnhSanPham (Anh, MaSanPham, MauSac)
VALUES ('anh1.jpg', 1, 'Trắng'),
       ('anh2.jpg', 2, 'Đen'),
       ('anh3.jpg', 3, 'Trắng'),
       ('anh4.jpg', 4, 'Xanh'),
       ('anh5.jpg', 5, 'Đỏ'),
       ('anh6.jpg', 6, 'Hồng'),
       ('anh7.jpg', 7, 'Xanh'),
       ('anh8.jpg', 8, 'Vàng'),
       ('anh9.jpg', 9, 'Đỏ'),
       ('anh10.jpg', 10, 'Đen');

-- Thêm dữ liệu vào bảng GioHang
INSERT INTO GioHang (MaNguoiMua)
VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(2),(3),(4),(5);                

-- Thêm dữ liệu vào bảng Chua
INSERT INTO Chua (MaGioHang, MaSanPham, SoLuong, KichThuoc)
VALUES
(1, 1, 2, 'S'),
(2, 2, 1, 'S'),
(3,  1, 1, 'M'),
(4,  2, 2, 'L'),
(5,  3, 1, '41'),
(6,  4, 1, 'Free Size'),
(7,  5, 2, 'XL'),
(8,  6, 1, 'M'),
(9,  7, 3, 'L'),
(10, 8, 1, 'S'),
(11, 9, 2, '37'),
(12, 10, 1, 'Free Size'),
(13, 1, 1, 'S'),
(14, 2, 1, 'M'),
(15, 3, 2, '42');

-- Thêm dữ liệu vào bảng DonHang
INSERT INTO DonHang (NgayDat, PTThanhToan, TTThanhToan, TTDonHang, MaNguoiMua, GhiChu)
VALUES ('2025-02-10', 'Thanh toán online', 'Chưa thanh toán', 'Chưa giao hàng', 1, 'Giao hàng giờ hành chính'),
('2025-02-15', 'Trả tiền mặt', 'Chưa thanh toán', 'Chưa giao hàng', 2, 'Giao hàng nhanh'),
('2025-02-11','Thanh toán online','Đã thanh toán','Đã giao hàng',  3,'Giao trong ngày'),
('2025-02-12','Trả tiền mặt'    ,'Chưa thanh toán','Chưa giao hàng',4,'Giao giờ hành chính'),
('2025-02-13','Thanh toán online','Đã thanh toán','Đã giao hàng',  5,'Khách tự nhận'),
('2025-02-14','Trả tiền mặt'    ,'Chưa thanh toán','Chưa giao hàng',6,'Giao nhanh'),
('2025-02-16','Thanh toán online','Đã thanh toán','Đã giao hàng',  7,'Khách vắng nhà, giao lại'),
('2025-02-17','Trả tiền mặt'    ,'Chưa thanh toán','Chưa giao hàng',8,'Để trước cửa'),
('2025-02-18','Thanh toán online','Đã thanh toán','Đã giao hàng',  9,'Gói quà miễn phí'),
('2025-02-19','Trả tiền mặt'    ,'Chưa thanh toán','Chưa giao hàng',10,'Giao sau 2 giờ');

-- Thêm dữ liệu vào bảng ThongTinThanhToan
INSERT INTO ThongTinThanhToan (MaNguoiMua, Loai, SoTaiKhoan)
VALUES (1, 'Visa', '1234567890123456'),
       (2, 'Mastercard', '9876543210987654');

-- Thêm dữ liệu vào bảng HoaDon
INSERT INTO HoaDon (ThoiGianTao, PhiGiaoHang, GiamGiaKhiGiaoHang, TongTien, XuatHoaDon, MaDonHang)
VALUES 
(NOW(), 30000, 5000, 915000, 0, 1),
(NOW(), 30000, 10000, 570000, 0, 2),
(NOW(), 20000, 0,    650000, 1, 3),
(NOW(), 25000, 5000, 900000, 0, 4),
(NOW(), 30000, 0,   1200000, 1, 5),
(NOW(), 15000, 2000, 550000, 0, 6),
(NOW(), 30000, 1000, 800000, 1, 7),
(NOW(), 20000, 5000, 700000, 0, 8),
(NOW(), 25000, 0,    950000, 1, 9),
(NOW(), 30000, 0,   1100000, 0,10);

-- Thêm dữ liệu vào bảng Co
INSERT INTO Co (MaDonHang, MaSanPham, SoLuong, KichThuoc, MauSac)
VALUES 
(1, 1, 2, 'S', 'Trắng'),
(2, 2, 1, 'M', 'Đen'),
(3,  1, 1, 'M',  'Trắng'),
(3,  3, 2, '42', 'Trắng'),
(4,  2, 1, 'L',  'Đen'),
(5,  5, 1, 'XL', 'Đỏ'),
(5, 10, 1, 'Free Size','Đen'),
(6,  4, 2, 'Free Size','Xanh'),
(7,  6, 1, 'M',  'Hồng'),
(7,  7, 1, 'L',  'Xanh'),
(8,  8, 1, 'S',  'Vàng'),
(9,  9, 2, '37', 'Đỏ'),
(10, 1, 1, 'S',  'Trắng'),
(10, 2, 1, 'M',  'Đen');

-- Thêm dữ liệu vào bảng ChuongTrinhKhuyenMai
INSERT INTO ChuongTrinhKhuyenMai (Ten, MoTa, ThoiGianBD, ThoiGianKT, GiamGia, SoLuong)
VALUES ('Tet Sale', 'Giam gia 10000', '2024-01-01 00:00:00', '2024-01-31 23:59:59', 10000, 100),
       ('Summer Sale', 'Giam gia 20000', '2024-06-01 00:00:00', '2024-06-30 23:59:59', 20000, 50);

-- Thêm dữ liệu vào bảng GiamGia
INSERT INTO GiamGia (MaDonHang, MaKM)
VALUES (1, 1),
       (2, 2);

-- Thêm dữ liệu vào bảng SuDung
INSERT INTO SuDung (MaKM, MaNguoiMua)
VALUES (1, 1),
       (2, 2);