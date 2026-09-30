# Học UVM testbench này như thế nào

## Thứ tự đọc

1. SPEC.md: viết ra expected cho một lần ghi và một lần đọc trước khi nhìn code.
2. `rtl/sync_memory.sv`: xác định trạng thái nào được reset, trạng thái nào được giữ.
3. `tb/top.sv` và `tb/mem_if.sv`: xác định clock, chân DUT, virtual interface.
4. `tb/mem_pkg.sv`: lần lượt xem item, sequence, driver, monitor, scoreboard, env, test.
5. Chạy script và tìm một request cụ thể trong log hoặc thêm `uvm_info` tạm để quan sát.

## Vì sao có từng thành phần?

| Thành phần | Câu hỏi nó trả lời |
|---|---|
| sequence item | Một request gồm những thông tin gì? |
| sequence | Các request được tạo theo thứ tự nào? |
| sequencer | Ai cấp item tiếp theo cho driver? |
| driver | Request được đặt lên pin ở thời điểm nào? |
| monitor | DUT thực sự đã thấy input gì và trả gì? |
| scoreboard | Response có đúng theo spec và lịch sử ghi không? |
| test | Test bắt đầu, reset, chờ hoàn tất và kết thúc ra sao? |

Ở memory này, model là mảng 16 byte và cờ `known` cho từng ô. `known` tránh so sánh với dữ liệu chưa được spec quy định. Monitor quan sát pin thật sau cạnh clock, nên scoreboard kiểm tra những gì DUT nhận được thay vì chỉ dựa vào item sequence muốn gửi.

## Câu hỏi tự trả lời

1. Tại sao driver đặt tín hiệu ở falling edge, monitor chụp input ở rising edge và đọc output sau 1 ps?
2. Nếu `rvalid` sai ở chu kỳ idle, checker nào bắt được?
3. Nếu ghi đè một địa chỉ rồi đọc lại, expected được cập nhật tại đâu?
4. Reset có xóa memory không? Test nào chứng minh điều đó?
5. `checked_ops` khác số chu kỳ clock ở điểm nào?
6. Nếu chỉ có dòng PASS nhưng UVM_ERROR khác 0, kết quả có đạt không?
7. Random seed giúp tái hiện lỗi như thế nào? Điều gì có thể khiến cùng seed vẫn cho kết quả khác?

## Bài mở rộng sau khi chạy được

- Thêm coverage theo địa chỉ 0, 15 và các địa chỉ giữa; phân biệt read/write.
- Thêm phép thử reset đúng khi một request đang chờ ở cạnh kế tiếp; xác định rõ spec trước khi viết checker.
- Tạo DUT lỗi riêng có read data sai ở địa chỉ 15. Chạy lại cùng seed và giải thích mismatch đầu tiên.
- Chuyển memory sang read latency thêm một clock. Trước khi sửa scoreboard, vẽ bảng thời gian của request và response.

Báo cáo mỗi thay đổi: requirement → scenario → expected → log thực tế → kết luận và giới hạn.
