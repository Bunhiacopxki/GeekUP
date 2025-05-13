# Project Readme

## Mô tả

Dự án này là một ứng dụng backend Node.js kết nối đến cơ sở dữ liệu MySQL để quản lý người dùng, sản phẩm, giỏ hàng và đơn hàng.

## Yêu cầu (Prerequisites)

* **Node.js** (phiên bản 14.x hoặc cao hơn)
* **MySQL** (phiên bản 5.7+ hoặc 8.0+)

## Cài đặt (Installation)

1. Clone repository về máy:

   ```bash
   git clone <URL_REPO>
   cd <THU_MUC_DU_AN>
   ```
2. Cài đặt các package cần thiết:

   ```bash
   npm install
   ```

## Thiết lập cơ sở dữ liệu (Database Setup)

1. Mở MySQL và đăng nhập bằng user có quyền tạo database.
2. Thực thi các file SQL theo thứ tự:

   * `create_database.sql`: Tạo database và các bảng.
   * `sample_data.sql`: Chèn dữ liệu mẫu ban đầu.
   * `solution.sql`: Lời giải cho các yêu cầu trong đề.

## Cấu hình kết nối (Configuration)

* Mở file `.envs`  và sửa các thông tin phù hợp với bạn

## Chạy ứng dụng (Run the Application)

Sau khi đã cài đặt package và thiết lập database:

```bash
npm start
```