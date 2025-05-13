const db = require('../config/db'); // Import cấu hình kết nối cơ sở dữ liệu
const nodemailer = require("nodemailer"); // Import thư viện gửi email
const PayOS = require('@payos/node'); // Import SDK PayOS để xử lý thanh toán
const passEmail = process.env.PASS_EMAIL;
const mail = process.env.EMAIL;

// Khởi tạo đối tượng PayOS với các khóa API
const payos = new PayOS(
    '0fac2c77-9c90-4862-afd5-bc6cb5e6c516', 
    'f5a16c19-64de-4e44-8d7c-594b1b22d8ef',
    '6adf7b154ca8a7569e3129b090727dd3ce34e8d99e0b13686ecf5485c37eca45'
);

class OrderService {

    Bank = async () => {
        return new Promise (async (resolve, reject) => {
            const test = await payos.createPaymentLink({
                orderCode: 777888,
                amount: 10000,
                description: "banking",
                buyerName: "hehe",
                buyerEmail: "buyerEmail@gmail.com",
                cancelUrl: "http://localhost:5005",
                returnUrl: "http://localhost:5005"
            });

            console.log(test)
            resolve({ status: true, message: 'Thêm đơn hàng thành công'});
        })
    }
    
    /**
     * Phương thức Order: Xử lý việc tạo đơn hàng và gửi email xác nhận đơn hàng
     * @param {Object} data - Dữ liệu chứa mã người mua và danh sách sản phẩm
     */

    Order = async (data) => {
        const { MaNguoiMua, DanhSachSanPham, PTThanhToan, PhiGiaoHang, GiamGiaKhiGiaoHang, XuatHoaDon, MaKM } = data; // Lấy dữ liệu đầu vào
        return new Promise (async (resolve, reject) => {
            try {
                // Gọi stored procedure 'b' để thêm đơn hàng vào cơ sở dữ liệu
                const [result] = await db.query('CALL b(?, ?, ?, ?, ?, ?, ?)', [MaNguoiMua, JSON.stringify(DanhSachSanPham), PTThanhToan, PhiGiaoHang, GiamGiaKhiGiaoHang, XuatHoaDon, MaKM]);
                
                // Thiết lập cấu hình cho Nodemailer để gửi email qua Gmail
                const transporter = nodemailer.createTransport({
                    service: 'gmail', // Sử dụng dịch vụ Gmail
                    auth: {
                        user: mail, // Địa chỉ email gửi đi
                        pass: passEmail // Mật khẩu ứng dụng Gmail
                    }
                });
                
                console.log(passEmail);

                // Truy vấn email của người mua từ bảng NguoiDung
                const receiver = await db.query('SELECT Email FROM NguoiDung WHERE MaNguoiMua = ?', [MaNguoiMua]);
                
                // Cấu hình nội dung email
                const mailOptions = {
                    from: 'thinh.nguyen04@hcmut.edu.vn', // Địa chỉ email gửi đi
                    to: receiver[0][0].Email, // Địa chỉ email người nhận
                    subject: 'Xác nhận đặt hàng', // Tiêu đề email
                    text: 'Đơn hàng của bạn đã được đặt thành công!' // Nội dung email
                };

                // Gửi email bằng Nodemailer
                transporter.sendMail(mailOptions, function(error, info){
                    if (error) {
                        // Trả về lỗi nếu gửi email thất bại
                        reject({ status: false, error: error.message });
                    } else {
                        // Trả về thành công khi hoàn tất việc thêm đơn hàng và gửi email
                        resolve({ status: true, message: 'Thêm đơn hàng thành công'});
                    }
                })       
            }
            catch (error) {
                // Trả về lỗi nếu có vấn đề xảy ra trong quá trình xử lý
                reject({ status: false, error: error.message });
            }
        })
    }

    /**
     * Phương thức Value: Gọi stored procedure 'c' và trả về kết quả
     */
    Value = async () => {
        return new Promise (async (resolve, reject) => {
            try {
                // Gọi stored procedure 'c' từ cơ sở dữ liệu
                const [result] = await db.query('CALL c()');
                
                // Trả về kết quả từ stored procedure
                resolve({ status: true, message: result[0]});
            }
            catch (error) {
                // Trả về lỗi nếu có vấn đề trong quá trình gọi stored procedure
                reject({ status: false, error: error.message });
            }
        })
    }

    /**
     * Phương thức Payment: Xử lý thanh toán bằng PayOS và cập nhật trạng thái thanh toán đơn hàng
     * @param {Object} data - Dữ liệu chứa thông tin thanh toán
     */
    Payment = async (data) => {
        const { MaDonHang } = data; // Lấy dữ liệu đầu vào từ yêu cầu thanh toán

        return new Promise (async (resolve, reject) => {
            try {
                // Lấy tổng tiền từ bảng HoaDon dựa trên MaDonHang
                const [money] = await db.query('SELECT TongTien FROM HoaDon WHERE MaDonHang = ?', [MaDonHang]);
                const [amount] = await db.query('SELECT SoLuong FROM Co WHERE MaDonHang = ?', [MaDonHang]);

                // Tạo link thanh toán với PayOS
                const pay = await payos.createPaymentLink({
                    orderCode: MaDonHang, 
                    amount: amount[0].SoLuong * money[0].TongTien, // Tổng tiền cần thanh toán
                    description: "banking", // Mô tả thanh toán
                    buyerName: "thinh",
                    buyerEmail: "thinh.nguyen04@hcmut.edu.vn",
                    cancelUrl: "http://localhost:5005", // URL khi thanh toán bị hủy
                    returnUrl: "http://localhost:5005" // URL khi thanh toán thành công
                });
                
                console.log(pay)

                // Cập nhật trạng thái thanh toán trong bảng DonHang
                await db.query('UPDATE DonHang SET TTThanhToan = ? WHERE MaDonHang = ?', [ 'Đã thanh toán', MaDonHang]);
                
                // Trả về thành công khi thanh toán hoàn tất
                resolve({ status: true, message: 'Tạo link thanh toán thành công', link: pay.checkoutUrl});
            }
            catch (error) {
                // Trả về lỗi nếu có vấn đề trong quá trình thanh toán
                reject({ status: false, error: error.message });
            }
        })
    }
}

// Xuất lớp OrderService để sử dụng trong các phần khác của ứng dụng
module.exports = new OrderService;