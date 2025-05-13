USE cv;

-- Thủ tục tạo đơn hàng
DROP PROCEDURE IF EXISTS b;
DELIMITER //
CREATE PROCEDURE b(
    IN o_MaNguoiMua INT,        -- Mã người mua
    IN o_ProductList JSON,      -- Danh sách sản phẩm dưới dạng JSON
    IN o_PTThanhToan CHAR(20),  -- Phương thức thanh toán
    IN h_PhiGiaoHang DECIMAL(18, 2), -- Phí giao hàng
    IN h_GiamGiaKhiGiaoHang DECIMAL(18, 2), -- Giảm giá khi giao hàng
    IN h_XuatHoaDon TINYINT(1), -- Cờ chỉ định có xuất hóa đơn hay không
    IN m_MaKM INT               -- Mã khuyến mãi (nếu có)
)
BEGIN
    -- Khai báo các biến dùng trong thủ tục
    DECLARE done INT DEFAULT 0;              -- Cờ để kiểm soát vòng lặp con trỏ
    DECLARE v_MaSanPham INT;                 -- Mã sản phẩm
    DECLARE v_SoLuong INT;                   -- Số lượng sản phẩm
    DECLARE v_KichThuoc CHAR(12);            -- Kích thước sản phẩm
    DECLARE v_MauSac VARCHAR(100);           -- Màu sắc sản phẩm
    DECLARE v_gia DECIMAL(18, 2);            -- Giá sản phẩm
    DECLARE v_tyle FLOAT;                    -- Tỷ lệ giảm giá sản phẩm
    DECLARE v_MaDonHang INT;                 -- Mã đơn hàng
    DECLARE v_KhuyenMai INT DEFAULT 0;       -- Số lượng khuyến mãi
    DECLARE v_TienGiam DECIMAL(18, 2);       -- Tiền giảm giá từ chương trình khuyến mãi
    DECLARE v_end TIMESTAMP;                 -- Thời gian kết thúc khuyến mãi
    DECLARE v_start TIMESTAMP;               -- Thời gian bắt đầu khuyến mãi

    -- Con trỏ để duyệt qua danh sách sản phẩm từ JSON
    DECLARE cur CURSOR FOR 
        SELECT 
            JSON_UNQUOTE(JSON_EXTRACT(t.value, '$.MaSanPham')),
            JSON_UNQUOTE(JSON_EXTRACT(t.value, '$.SoLuong')),
            JSON_UNQUOTE(JSON_EXTRACT(t.value, '$.KichThuoc')),
            JSON_UNQUOTE(JSON_EXTRACT(t.value, '$.MauSac'))
        FROM JSON_TABLE(o_ProductList, '$[*]' COLUMNS (
            value JSON PATH '$'
        )) AS t;

    -- Xử lý nếu không tìm thấy dữ liệu khi duyệt con trỏ
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Kiểm tra phương thức thanh toán, nếu không hợp lệ thì chỉ tạo đơn hàng với thông tin cơ bản
    IF o_PTThanhToan IS NULL OR o_PTThanhToan = '' OR o_PTThanhToan != 'Đã thanh toán' OR o_PTThanhToan != 'Chưa thanh toán' THEN
        INSERT INTO DonHang (NgayDat, MaNguoiMua) 
        VALUES (CURDATE(), o_MaNguoiMua);
    ELSE
        INSERT INTO DonHang (NgayDat, MaNguoiMua, PTThanhToan) 
        VALUES (CURDATE(), o_MaNguoiMua, o_PTThanhToan);
    END IF;

    -- Lấy mã đơn hàng vừa tạo
    SET v_MaDonHang = LAST_INSERT_ID();
    
    -- Tạo hóa đơn mới cho đơn hàng
    INSERT INTO HoaDon(ThoiGianTao, TongTien, MaDonHang, PhiGiaoHang, GiamGiaKhiGiaoHang, XuatHoaDon)
    VALUES (NOW(), 0, v_MaDonHang, h_PhiGiaoHang, h_GiamGiaKhiGiaoHang, h_XuatHoaDon);

    -- Duyệt qua danh sách sản phẩm trong JSON
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_MaSanPham, v_SoLuong, v_KichThuoc, v_MauSac;

        -- Lấy giá sản phẩm và tỷ lệ giảm giá
        SELECT Gia, TyLeGiamGia INTO v_gia, v_tyle
        FROM SanPham WHERE MaSanPham = v_MaSanPham;

        -- Nếu đã duyệt hết thì thoát vòng lặp
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Kiểm tra dữ liệu hợp lệ
        IF v_SoLuong < 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số lượng sản phẩm không được nhỏ hơn 0.';
        END IF;

        IF v_KichThuoc IS NULL OR v_KichThuoc = '' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kích thước không được để trống.';
        END IF;

        -- Kiểm tra tồn kho và các thuộc tính của sản phẩm
        IF NOT EXISTS (SELECT 1 FROM KichThuoc WHERE MaSanPham = v_MaSanPham AND KichThuoc = v_KichThuoc) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sản phẩm đã hết hàng.';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM HinhAnhSanPham WHERE MaSanPham = v_MaSanPham AND MauSac = v_MauSac) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sản phẩm không có màu này.';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaSanPham = v_MaSanPham) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sản phẩm không tồn tại.';
        END IF;

        -- Thêm sản phẩm vào chi tiết đơn hàng
        INSERT INTO Co (MaDonHang, MaSanPham, SoLuong, KichThuoc, MauSac)
        VALUES (v_MaDonHang, v_MaSanPham, v_SoLuong, v_KichThuoc, v_MauSac);

        -- Cập nhật số lượng tồn kho
        UPDATE KichThuoc SET SoLuong = SoLuong - v_SoLuong
        WHERE MaSanPham = v_MaSanPham AND KichThuoc = v_KichThuoc;
        
        -- Cập nhật tổng tiền hóa đơn
        UPDATE HoaDon SET TongTien = TongTien + v_SoLuong * v_gia * (1 - v_tyle)
        WHERE MaDonHang = v_MaDonHang;
    END LOOP;
    CLOSE cur;

    -- Xử lý giảm giá từ chương trình khuyến mãi (nếu có)
    SELECT SoLuong, GiamGia, ThoiGianKT, ThoiGianBD INTO v_KhuyenMai, v_TienGiam, v_end, v_start 
    FROM ChuongTrinhKhuyenMai WHERE MaKM = m_MaKM;

    IF v_KhuyenMai > 0 AND NOW() < v_end AND NOW() > v_start THEN
        INSERT INTO SuDung (MaKM, MaNguoiMua) VALUES (m_MaKM, o_MaNguoiMua);
        INSERT INTO GiamGia (MaKM, MaDonHang) VALUES (m_MaKM, v_MaDonHang);
        UPDATE ChuongTrinhKhuyenMai SET SoLuong = SoLuong - 1 WHERE MaKM = m_MaKM;
        UPDATE HoaDon SET TongTien = TongTien + h_PhiGiaoHang - h_GiamGiaKhiGiaoHang - v_TienGiam
        WHERE MaDonHang = v_MaDonHang;
    ELSE 
        UPDATE HoaDon SET TongTien = TongTien + h_PhiGiaoHang - h_GiamGiaKhiGiaoHang
        WHERE MaDonHang = v_MaDonHang;
    END IF;
END //
DELIMITER ;

-- Thủ tục tính trung bình giá trị đơn hàng
DROP PROCEDURE if exists c;
DELIMITER //
CREATE PROCEDURE c()
BEGIN
	SELECT
		YEAR(DH.NgayDat) AS Year,
		MONTH(DH.NgayDat) AS Month,
		AVG(HD.TongTien) AS AverageOrderValue -- average order value
	FROM
		DonHang DH
	JOIN
		HoaDon HD ON DH.MaDonHang = HD.MaDonHang
	WHERE
		YEAR(DH.NgayDat) = YEAR(CURDATE()) -- Trong năm nay
	GROUP BY
		YEAR(DH.NgayDat),
		MONTH(DH.NgayDat)
	ORDER BY
		Month desc;
END //
DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS d;
CREATE FUNCTION d() 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE Previous INT DEFAULT 0;
    DECLARE Churned INT DEFAULT 0;

    -- Tính Previous: số lượng khách hàng đã mua đơn hàng trong 6 tháng trước
    SELECT COUNT(DISTINCT MaNguoiMua)
    INTO Previous
    FROM DonHang
    WHERE NgayDat >= CURDATE() - INTERVAL 12 MONTH
      AND NgayDat < CURDATE() - INTERVAL 6 MONTH;

    -- Tính Churned: khách hàng đã mua 6 tháng trước nhưng không mua trong 6 tháng gần đây
    SELECT COUNT(DISTINCT p.MaNguoiMua)
    INTO Churned
    FROM (
        SELECT DISTINCT MaNguoiMua
        FROM DonHang
        WHERE NgayDat >= CURDATE() - INTERVAL 12 MONTH
          AND NgayDat < CURDATE() - INTERVAL 6 MONTH
    ) p
    LEFT JOIN (
        SELECT DISTINCT MaNguoiMua
        FROM DonHang
        WHERE NgayDat >= CURDATE() - INTERVAL 6 MONTH
    ) l ON p.MaNguoiMua = l.MaNguoiMua
    WHERE l.MaNguoiMua IS NULL;

    -- Tính tỷ lệ Churn Rate
    IF Previous = 0 THEN 
        RETURN 0.00;
    ELSE 
        RETURN (Churned / Previous) * 100;
    END IF;
END //
DELIMITER ;