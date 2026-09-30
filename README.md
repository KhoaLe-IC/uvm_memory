# UVM Memory Verification — EDA Playground

Project học kiểm chứng **memory đồng bộ một cổng, 16 × 8 bit** bằng SystemVerilog và UVM. Môi trường chạy được hướng dẫn là **Synopsys VCS trên EDA Playground**.

## Chạy trên EDA Playground

1. Mở [EDA Playground](https://www.edaplayground.com/) bằng tài khoản có quyền dùng VCS.
2. Chọn ngôn ngữ SystemVerilog, simulator Synopsys VCS và thư viện UVM có sẵn. Ghi phiên bản simulator/UVM hiển thị trong log.
3. Dán [design.sv](eda_playground/design.sv) vào ô `design.sv`.
4. Dán [testbench.sv](eda_playground/testbench.sv) vào ô `testbench.sv`.
5. Bấm Run; kiểm tra RESULT, UVM_ERROR và UVM_FATAL trong log. Khi đã chạy, lưu link playground cùng cấu hình và seed.

Hai file đã gộp đúng thứ tự interface → package → top; không cần dán riêng các file trong `tb/`. Không compile thêm bản sao của cùng module/package. Thư viện UVM do simulator cung cấp; không dán `uvm_pkg.sv` vào playground.

**Trạng thái:** source đã chạy trên máy local; chưa có log chạy thực tế trên EDA Playground. Không coi kết quả local là bằng chứng PASS trên EDA Playground. Xem [VALIDATION.md](results/VALIDATION.md).

Nếu sửa RTL/testbench nguồn, tạo lại hai file bằng:

```bash
python3 scripts/export_eda.py
```

## Phạm vi kiểm tra

Sequence → sequencer → driver → DUT → monitor → scoreboard. Scoreboard kiểm tra dữ liệu đọc từ model, rvalid, reset response, giữ rdata khi idle/ghi, ghi đè, địa chỉ biên, truy cập ngẫu nhiên, bỏ qua ghi trong reset và giữ nội dung memory qua reset.

Mỗi test hiện có 138 request được kiểm tra. Chưa đo native coverage hoặc kiểm chứng với DUT lỗi độc lập. Đọc địa chỉ chưa ghi nằm ngoài spec.

## Nội dung

| File/thư mục | Vai trò |
|---|---|
| [SPEC.md](SPEC.md) | Đặc tả memory |
| [TESTPLAN.md](TESTPLAN.md) | Requirement và scenario |
| [LEARNING_GUIDE.md](LEARNING_GUIDE.md) | Giải thích từng thành phần và bài tập |
| `rtl/` | Source DUT |
| `tb/` | Interface, UVM package, top |
| `eda_playground/` | Hai file gộp để dán lên Playground |
| `scripts/` | Export EDA và công cụ chạy local tùy chọn |

## Đưa lên GitHub

Đọc [GITHUB_UPLOAD.md](GITHUB_UPLOAD.md). Repo dùng [MIT License](LICENSE); xem [CONTRIBUTING.md](CONTRIBUTING.md) khi thay đổi code và [DEPENDENCIES.md](DEPENDENCIES.md) cho dependency. Các file build, dependency tải về và raw log được bỏ qua bởi `.gitignore`.
