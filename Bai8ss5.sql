INSERT INTO sakila.customer (store_id, first_name, last_name, email, address_id)
VALUES (2, 'ANNA', 'HILL', 'ANNA.HILL@sakilacustomer.org', 5);

UPDATE sakila.customer
SET email = REPLACE(email, '@sakilacustomer.org', '@sakilacustomer.com')
WHERE first_name = 'JENNIFER';

UPDATE sakila.customer
SET active = 0
WHERE customer_id = 25;

/*

GIẢI THÍCH: VÌ SAO NÊN "SOFT DELETE" THAY VÌ "HARD DELETE"
Bảo toàn dữ liệu lịch sử:
   - Việc chỉ "đánh dấu là không hoạt động" (soft delete) giúp giữ lại toàn bộ thông tin khách hàng, 
     bao gồm lịch sử giao dịch, thanh toán, và hành vi tiêu dùng.
   - Đây là dữ liệu quý giá cho các phân tích kinh doanh, thống kê hoặc khôi phục tài khoản trong tương lai.

Tránh mất mối liên kết dữ liệu:
   - Trong các hệ thống có nhiều bảng liên kết (VD: payment, rental, address),
     xóa vĩnh viễn (hard delete) có thể gây lỗi quan hệ khóa ngoại (foreign key constraint) 
     hoặc làm mất tính toàn vẹn dữ liệu.
   - Soft delete giúp đảm bảo toàn bộ hệ thống vẫn nhất quán mà không phá vỡ các mối quan hệ.

Dễ dàng khôi phục tài khoản:
   - Nếu khách hàng quay lại, chỉ cần cập nhật lại cột `active = 1` mà không cần tạo lại toàn bộ thông tin mới.
   - Điều này tiết kiệm thời gian, công sức, và giúp duy trì trải nghiệm người dùng liên tục.

TỔNG KẾT:
- Soft Delete giúp bảo vệ dữ liệu, đảm bảo toàn vẹn hệ thống và hỗ trợ phân tích lâu dài.

