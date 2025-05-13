const db = require('../config/db'); // Import cấu hình kết nối cơ sở dữ liệu

class ProductService {
    /**
     * Phương thức CategoryList: Lấy danh sách tất cả danh mục sản phẩm
     * @returns {Promise<Object>} - Danh sách các danh mục sản phẩm từ bảng DanhMuc
     */
    CategoryList = async (data) => {
        return new Promise(async (resolve, reject) => {
            try {
                // Truy vấn tất cả các danh mục từ bảng DanhMuc
                const [result] = await db.query('SELECT * FROM DanhMuc');
                // Trả về danh sách các danh mục
                resolve({ status: true, Categories: result });
            } catch (error) {
                // Trả về lỗi nếu truy vấn thất bại
                reject({ status: false, error: error.message });
            }
        });
    };

    /**
     * Phương thức CategoryProduct: Lấy danh sách sản phẩm theo mã danh mục
     * @param {Object} data - Dữ liệu chứa mã danh mục sản phẩm
     * @returns {Promise<Object>} - Danh sách các sản phẩm thuộc danh mục cụ thể
     */
    CategoryProduct = async (data) => {
        const { MaDanhMuc } = data; // Lấy mã danh mục từ tham số đầu vào
        return new Promise(async (resolve, reject) => {
            try {
                // Truy vấn các sản phẩm thuộc danh mục cụ thể
                const [products] = await db.query(
                    'SELECT MaSanPham, TenSanPham, Model, Gia, TyLeGiamGia FROM SanPham WHERE MaDanhMuc = ?',
                    [MaDanhMuc]
                );

                // Lấy ảnh sản phẩm cho từng sản phẩm
                const result = await Promise.all(
                    products.map(async (product) => {
                        const [images] = await db.query(
                            'SELECT Anh FROM HinhAnhSanPham WHERE MaSanPham = ?',
                            [product.MaSanPham]
                        );
                        const anh = images.map((image) => image.Anh);

                        // Trả về chi tiết sản phẩm với giá gốc và giá sau khi giảm
                        return {
                            TenSanPham: product.TenSanPham,
                            Model: product.Model,
                            Anh: anh, // Danh sách ảnh sản phẩm
                            TyLeGiamGia: (product.TyLeGiamGia * 100).toString() + '%', // Tỷ lệ giảm giá
                            GiaGoc: product.Gia, // Giá gốc
                            GiaSauKhiGiam: product.Gia - product.Gia * product.TyLeGiamGia, // Giá sau khi giảm
                        };
                    })
                );

                // Trả về kết quả danh sách sản phẩm
                resolve({ status: true, Products: result });
            } catch (error) {
                // Trả về lỗi nếu có vấn đề xảy ra
                reject({ status: false, error: error.message });
            }
        });
    };

    /**
     * Phương thức Search: Tìm kiếm sản phẩm dựa trên từ khóa nhập vào
     * @param {Object} data - Dữ liệu chứa từ khóa tìm kiếm
     * @returns {Promise<Object>} - Danh sách sản phẩm khớp với từ khóa tìm kiếm
     */
    Search = async (data) => {
        const { Keyword } = data; // Lấy từ khóa tìm kiếm từ tham số đầu vào
        return new Promise(async (resolve, reject) => {
            try {
                // Truy vấn sản phẩm khớp với từ khóa trong tên, thương hiệu, mô tả hoặc giá
                const [products] = await db.query(
                    `SELECT MaSanPham, TenSanPham, Model, GioiTinh, ThuongHieu, Gia, TyLeGiamGia, MoTa 
                     FROM SanPham 
                     WHERE TenSanPham REGEXP ? 
                     OR ThuongHieu REGEXP ? 
                     OR MoTa REGEXP ? 
                     OR Gia REGEXP ?`,
                    [Keyword, Keyword, Keyword, Keyword]
                );

                // Lấy ảnh sản phẩm cho từng kết quả tìm kiếm
                const result = await Promise.all(
                    products.map(async (product) => {
                        const [images] = await db.query(
                            'SELECT Anh FROM HinhAnhSanPham WHERE MaSanPham = ?',
                            [product.MaSanPham]
                        );
                        const anh = images.map((image) => image.Anh);

                        // Trả về thông tin sản phẩm tìm kiếm
                        return {
                            TenSanPham: product.TenSanPham,
                            Anh: anh, // Danh sách ảnh sản phẩm
                            MoTa: product.MoTa, // Mô tả sản phẩm
                            Model: product.Model, // Model sản phẩm
                            GioiTinh: product.GioiTinh, // Giới tính phù hợp
                            ThuongHieu: product.ThuongHieu, // Thương hiệu
                            TyLeGiamGia: (product.TyLeGiamGia * 100).toString() + '%', // Tỷ lệ giảm giá
                            GiaGoc: product.Gia, // Giá gốc
                            GiaSauKhiGiam: product.Gia - product.Gia * product.TyLeGiamGia, // Giá sau giảm
                        };
                    })
                );

                // Trả về kết quả tìm kiếm
                resolve({ status: true, Result: result });
            } catch (error) {
                // Trả về lỗi nếu truy vấn thất bại
                reject({ status: false, error: error.message });
            }
        });
    };
}

// Xuất lớp ProductService để sử dụng trong các phần khác của ứng dụng
module.exports = new ProductService();