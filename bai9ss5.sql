SELECT film_id, title, rating, length, rental_rate
FROM sakila.film
WHERE (rating = 'PG' OR rating = 'G')
  AND length > 100
  AND rental_rate >= 2.99
ORDER BY rental_rate DESC;

UPDATE sakila.film
SET rental_rate = rental_rate / 2
WHERE (rating = 'PG' OR rating = 'G')
  AND length > 100
  AND rental_rate >= 2.99;

/*

PHÂN TÍCH RỦI RO VÀ KẾ HOẠCH HOÀN TÁC
RỦI RO LỚN NHẤT:
- Nếu lệnh UPDATE bị thực thi mà KHÔNG có mệnh đề WHERE,
toàn bộ các bộ phim trong bảng 'film' sẽ bị giảm giá 50%.
- Hậu quả:
Mất doanh thu nghiêm trọng do tất cả phim bị giảm giá ngoài ý muốn.
Gây rối loạn dữ liệu lịch sử giá thuê, khó khôi phục.
Làm sai lệch các báo cáo tài chính và KPI của hệ thống.

KẾ HOẠCH HOÀN TÁC:
Giả sử bạn đã chạy lệnh UPDATE sai và cần khôi phục giá thuê gốc.

-- Câu lệnh hoàn tác:
UPDATE sakila.film
SET rental_rate = rental_rate * 2
WHERE (rating = 'PG' OR rating = 'G')
AND length > 100
AND rental_rate < 2.99;  -- giả định giá đã bị giảm một nửa

Giải thích:
- Lệnh này nhân đôi lại giá thuê cho những phim bị ảnh hưởng.
- Điều kiện WHERE được viết ngược lại (rental_rate < 2.99)
để chỉ ảnh hưởng đến các phim đã bị giảm trong chiến dịch.


TẠI SAO CẦN CÓ KẾ HOẠCH HOÀN TÁC:
- Trong môi trường sản xuất (production), mọi UPDATE hàng loạt
đều có rủi ro cao và thường không thể “Ctrl + Z”.
- Một kế hoạch rollback giúp khôi phục nhanh hệ thống,
giảm thiểu thiệt hại tài chính và thời gian downtime.


ĐỀ XUẤT CẢI TIẾN:
Tạo thêm một cột mới `original_rental_rate` để lưu giá gốc:
ALTER TABLE sakila.film ADD COLUMN original_rental_rate DECIMAL(4,2);
Sau đó, trước khi giảm giá:
UPDATE sakila.film
SET original_rental_rate = rental_rate;

Điều này cho phép:
- Khôi phục giá ban đầu chỉ với một lệnh:
UPDATE sakila.film SET rental_rate = original_rental_rate;
- Giúp kiểm toán, đối chiếu dữ liệu và đánh giá hiệu quả chiến dịch.


KẾT LUẬN:
- Chiến dịch "Chào Thu, Giá Sốc!" giúp kích cầu phim gia đình dài tập.
- Tuy nhiên, việc có kế hoạch hoàn tác và sao lưu dữ liệu trước khi chạy UPDATE
là bắt buộc trong quản trị dữ liệu chuyên nghiệp.

*/
