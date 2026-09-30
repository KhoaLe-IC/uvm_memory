# Contributing

1. Đọc SPEC.md và ánh xạ thay đổi vào TESTPLAN.md.
2. Sửa source gốc trong rtl/ và tb/, chạy `python3 scripts/export_eda.py` để đồng bộ bản gộp.
3. Chạy trên EDA Playground bằng VCS/UVM; ghi phiên bản, cấu hình, seed và link đã lưu nếu có.
4. Nộp RESULT và UVM_ERROR/UVM_FATAL counts. Nếu chưa chạy thì ghi rõ.
5. Giữ generated build, dependency và raw log ngoài commit; không dùng kết quả local để tuyên bố PASS trên EDA Playground.

Có thể chạy `make check` để kiểm tra shell scripts, nhưng đây không phải simulation. Không coi số request là full coverage.
