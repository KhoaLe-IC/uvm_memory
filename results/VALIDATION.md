# Trạng thái kiểm chứng

## EDA Playground — môi trường mục tiêu

Simulator mục tiêu: Synopsys VCS, thư viện UVM do EDA Playground cung cấp. Đã có source gộp trong `eda_playground/`. **Chưa chạy thực tế trên EDA Playground và chưa có share link hoặc log từ nền tảng này.**

Khi chạy, bổ sung version VCS/UVM, cấu hình, seed, share link, RESULT và tổng UVM_ERROR/UVM_FATAL. Chỉ đánh dấu PASS trên nền tảng này sau khi có bằng chứng.

## Kết quả local tham khảo

Source gốc đã được chạy local ngày 2026-09-29. Seed 1: 77 writes, 61 reads. Seed 42: 67 writes, 71 reads. Mỗi lần: 138 request, 5 reset edges, UVM_ERROR=0, UVM_FATAL=0.

Ngày 2026-09-30 đã chạy lại seed 42 trên binary local có sẵn và xác nhận các số trên. Các kết quả này không xác nhận khả năng compile hoặc PASS trên EDA Playground. Chưa có native coverage hoặc thử DUT lỗi độc lập. Raw log và binary local không được đưa vào repo.
