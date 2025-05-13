DROP DATABASE IF EXISTS cv;
CREATE DATABASE cv;
USE cv;

-- Bảng Người dùng
CREATE TABLE NguoiDung (
    MaNguoiMua INT AUTO_INCREMENT PRIMARY KEY,
    MatKhau VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    HoTen VARCHAR(100) NOT NULL,
    SDT CHAR(10) UNIQUE,
    GioiTinh ENUM('Nam', 'Nữ', 'Khác'),
    DiaChi VARCHAR(50),
    Xa VARCHAR(50),
    Huyen VARCHAR(50),
    Tinh VARCHAR(50),
    LoaiNha ENUM('Nhà riêng', 'Công ty'),
    Admin tinyint(1) default 0
);

DROP TRIGGER IF EXISTS KiemTraEmailHopLe;
-- Trigger kiểm tra email
DELIMITER //
CREATE TRIGGER KiemTraEmailHopLe BEFORE INSERT ON NguoiDung
FOR EACH ROW
BEGIN
    IF NOT (NEW.Email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Địa chỉ email không hợp lệ.';
    END IF;
END; //
DELIMITER ;

-- Bảng Danh mục
CREATE TABLE DanhMuc (
    MaDanhMuc INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    TenDanhMuc VARCHAR(100) NOT NULL UNIQUE,
    MoTa VARCHAR(255),
    Anh TEXT,
    ThuTuHienThi INT NOT NULL
);

-- Bảng Địa chỉ cửa hàng
CREATE TABLE DiaChi (
    MaDiaChi INT AUTO_INCREMENT PRIMARY KEY,
    Duong VARCHAR(255) NOT NULL,
    ThanhPho VARCHAR(255) NOT NULL,
    Quan VARCHAR(255) NOT NULL,
    MoTa VARCHAR(255)
);

-- Bảng Cửa hàng
CREATE TABLE CuaHang (
    MaCuaHang INT AUTO_INCREMENT PRIMARY KEY,
    TenCuaHang VARCHAR(100) NOT NULL,
    MaDiaChi INT NOT NULL,
    FOREIGN KEY (MaDiaChi) REFERENCES DiaChi(MaDiaChi)
);

-- Bảng Sản phẩm
CREATE TABLE SanPham (
    MaSanPham INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    TenSanPham VARCHAR(100) NOT NULL,
    MoTa VARCHAR(255),
    Model VARCHAR(100),
    GioiTinh ENUM('Nam', 'Nữ'),
    ThuongHieu  VARCHAR(100),
    Gia DECIMAL(18, 2) NOT NULL,
    TyLeGiamGia FLOAT default 0.0,
    MaDanhMuc INT,
    MaCuaHang INT,
    CONSTRAINT fk_SanPham_DanhMuc FOREIGN KEY (MaDanhMuc) REFERENCES DanhMuc(MaDanhMuc)
    ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_SanPham_CuaHang FOREIGN KEY (MaCuaHang) REFERENCES CuaHang(MaCuaHang)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- Bảng kích thước sản phẩm
CREATE TABLE KichThuoc (
	KichThuoc CHAR(12),
	MaSanPham INT,
    SoLuong INT CHECK (SoLuong >= 0),
	PRIMARY KEY (KichThuoc, MaSanPham),
	FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

-- Bảng sản phẩm đã thích
CREATE TABLE Thich (
	MaNguoiMua INT,
	MaSanPham INT,
	PRIMARY KEY (MaNguoiMua, MaSanPham),
	FOREIGN KEY (MaNguoiMua) REFERENCES NguoiDung(MaNguoiMua),
	FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

-- Bảng Hình ảnh sản phẩm
CREATE TABLE HinhAnhSanPham (
	MaHinhAnh INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Anh TEXT,
	MaSanPham INT,
    MauSac VARCHAR(100),
	FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

-- Bảng Giỏ hàng
CREATE TABLE GioHang (
    MaGioHang INT AUTO_INCREMENT PRIMARY KEY,
    MaNguoiMua INT NOT NULL,
    CONSTRAINT fk_GioHang_NguoiMua FOREIGN KEY (MaNguoiMua) REFERENCES NguoiDung(MaNguoiMua)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng Giỏ hàng chứa sản phẩm
CREATE TABLE Chua (
    MaGioHang INT NOT NULL,
    MaSanPham INT NOT NULL,
    SoLuong INT CHECK (SoLuong > 0),
    KichThuoc CHAR(12),
    PRIMARY KEY (MaGioHang, MaSanPham, KichThuoc),
    CONSTRAINT fk_Chua_GioHang FOREIGN KEY (MaGioHang) REFERENCES GioHang(MaGioHang)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Chua_SanPham FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (KichThuoc, MaSanPham) REFERENCES KichThuoc(KichThuoc, MaSanPham)
);

DROP TRIGGER IF EXISTS KiemTraSoLuongSanPhamGioHang;
-- Trigger kiểm tra số lượng sản phẩm còn lại trong kho khi thêm vào giỏ hàng
DELIMITER //
CREATE TRIGGER KiemTraSoLuongSanPhamGioHang BEFORE INSERT ON Chua
FOR EACH ROW
BEGIN
    DECLARE SoLuongSanPham INT;
    SELECT SoLuong INTO SoLuongSanPham
    FROM KichThuoc
    WHERE MaSanPham = NEW.MaSanPham AND KichThuoc = NEW.KichThuoc;

    IF SoLuongSanPham < NEW.SoLuong THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ để thêm vào giỏ hàng.';
    END IF;
END; //
DELIMITER ;

-- Bảng Đơn hàng
CREATE TABLE DonHang (
    MaDonHang INT PRIMARY KEY AUTO_INCREMENT,
    NgayDat DATE NOT NULL,
    PTThanhToan ENUM('Thanh toán online', 'Trả tiền mặt') DEFAULT 'Trả tiền mặt',
    TTThanhToan ENUM('Đã thanh toán', 'Chưa thanh toán') DEFAULT 'Chưa thanh toán',
    TTDonHang ENUM('Đã giao hàng', 'Chưa giao hàng', 'Huỷ giao hàng') DEFAULT 'Chưa giao hàng',
    MaNguoiMua INT NOT NULL,
    GhiChu VARCHAR(500),
    CONSTRAINT fk_DonHang_NguoiMua FOREIGN KEY (MaNguoiMua) REFERENCES NguoiDung(MaNguoiMua)
    ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS KiemTraSoDonHangTrongNgay;
-- Trigger kiểm tra số đơn hàng trong ngày
DELIMITER //
CREATE TRIGGER KiemTraSoDonHangTrongNgay BEFORE INSERT ON DonHang
FOR EACH ROW
BEGIN
    DECLARE SoDonHangTrongNgay INT;
    SELECT COUNT(*) INTO SoDonHangTrongNgay
    FROM DonHang
    WHERE NgayDat = CURDATE() AND MaNguoiMua = NEW.MaNguoiMua;

    IF SoDonHangTrongNgay > 20 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số đơn đặt hàng không được vượt quá 20 đơn hàng trong một ngày.';
    END IF;
END; //
DELIMITER ;

-- Bảng Thông tin thanh toán
CREATE TABLE ThongTinThanhToan (
    MaNguoiMua INT NOT NULL,
    Loai VARCHAR(50) NOT NULL,
    SoTaiKhoan VARCHAR(20) NOT NULL,
    PRIMARY KEY (MaNguoiMua, Loai, SoTaiKhoan),
    CONSTRAINT fk_ThongTinThanhToan_NguoiMua FOREIGN KEY (MaNguoiMua) REFERENCES NguoiDung(MaNguoiMua)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng Hóa đơn
CREATE TABLE HoaDon (
    MaHoaDon INT PRIMARY KEY AUTO_INCREMENT,
    ThoiGianTao TIMESTAMP NOT NULL,
    PhiGiaoHang DECIMAL(18, 2) DEFAULT 0.00,
    GiamGiaKhiGiaoHang DECIMAL(18, 2) DEFAULT 0.00,
    TongTien DECIMAL(18, 2),
    XuatHoaDon tinyint(1) DEFAULT 0,
    MaDonHang INT NOT NULL,
    CONSTRAINT fk_HoaDon_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng Đơn hàng có sản phẩm
CREATE TABLE Co (
    MaDonHang INT NOT NULL,
    MaSanPham INT NOT NULL,
    SoLuong INT,
    KichThuoc CHAR(12),
    MauSac VARCHAR(100),
    PRIMARY KEY (MaSanPham, MaDonHang),
    CONSTRAINT fk_Co_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_Co_SanPham FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS KiemTraSoLuongSanPhamDonHang;
-- Trigger kiểm tra số lượng sản phẩm còn lại trong kho khi thêm vào đơn hàng 
DELIMITER //
CREATE TRIGGER KiemTraSoLuongSanPhamDonHang BEFORE INSERT ON Co
FOR EACH ROW
BEGIN
    DECLARE SoLuongSanPham INT;
    SELECT SoLuong INTO SoLuongSanPham
    FROM KichThuoc
    WHERE MaSanPham = NEW.MaSanPham AND KichThuoc = NEW.KichThuoc;

    IF SoLuongSanPham < NEW.SoLuong THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ để thêm vào đơn hàng.';
    END IF;
END; //
DELIMITER ;

-- Bảng Chương trình khuyến mãi
CREATE TABLE ChuongTrinhKhuyenMai (
    MaKM INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Ten VARCHAR(50) NOT NULL,
    MoTa VARCHAR(255),
    ThoiGianBD DATETIME NOT NULL,
    ThoiGianKT DATETIME NOT NULL,
    GiamGia DECIMAL(18, 2) NOT NULL,
    SoLuong INT NOT NULL
);

DROP TRIGGER IF EXISTS KiemTraNgay;
-- Trigger kiểm tra thời gian chương trình khuyến mãi
DELIMITER //
CREATE TRIGGER KiemTraNgay BEFORE INSERT ON ChuongTrinhKhuyenMai
FOR EACH ROW
BEGIN
    IF NEW.ThoiGianBD > NEW.ThoiGianKT THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không hợp lệ.';
    END IF;
END; //
DELIMITER ;

-- Bảng Giảm giá
CREATE TABLE GiamGia (
    MaDonHang INT NOT NULL,
    MaKM INT NOT NULL,
    PRIMARY KEY (MaDonHang, MaKM),
    CONSTRAINT fk_GiamGia_DonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_GiamGia_KhuyenMai FOREIGN KEY (MaKM) REFERENCES ChuongTrinhKhuyenMai(MaKM)
    ON UPDATE CASCADE
);

-- Bảng Sử dụng
CREATE TABLE SuDung (
    MaKM INT NOT NULL,
    MaNguoiMua INT NOT NULL,
    PRIMARY KEY (MaNguoiMua, MaKM),
    CONSTRAINT fk_SuDung_KhuyenMai FOREIGN KEY (MaKM) REFERENCES ChuongTrinhKhuyenMai(MaKM)
    ON UPDATE CASCADE,
    CONSTRAINT fk_SuDung_NguoiMua FOREIGN KEY (MaNguoiMua) REFERENCES NguoiDung(MaNguoiMua)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS KiemTraSoLuongKhuyenMai;
-- Trigger kiểm tra số số lượng khuyến mãi trước khi sử dụng
DELIMITER //
CREATE TRIGGER KiemTraSoLuongKhuyenMai BEFORE INSERT ON SuDung
FOR EACH ROW
BEGIN
    DECLARE SoLuongKhuyenMai INT;
    SELECT SoLuong INTO SoLuongKhuyenMai
    FROM ChuongTrinhKhuyenMai
    WHERE MaKM = NEW.MaKM;
    
    IF SoLuongKhuyenMai <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khuyến mãi này đã hết số lượng.';
    END IF;
END; //
DELIMITER ;