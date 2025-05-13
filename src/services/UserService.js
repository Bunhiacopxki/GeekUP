const db = require('../config/db'); // Import cấu hình kết nối cơ sở dữ liệu

class UserService {
    /**
     * Phương thức Churn: Tính toán tỷ lệ khách hàng rời bỏ hệ thống
     * @returns {Promise<Object>} - Kết quả tỷ lệ churn (rời bỏ hệ thống) dưới dạng phần trăm
     */
    Churn = async () => {
        return new Promise(async (resolve, reject) => {
            try {
                // Gọi hàm d() từ cơ sở dữ liệu để tính toán churn rate
                const [result] = await db.query('SELECT d() AS ChurnRate');
                // Trả về churn rate kèm ký hiệu phần trăm (%)
                resolve({ status: true, ChurnRate: result[0].ChurnRate + '%' });
            } catch (error) {
                // Trả về lỗi nếu có vấn đề xảy ra
                reject({ status: false, error: error.message });
            }
        });
    };
}

// Xuất lớp UserService để sử dụng trong các phần khác của ứng dụng
module.exports = new UserService