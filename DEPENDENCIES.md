# Dependencies

## EDA Playground

Cần tài khoản EDA Playground có quyền dùng Synopsys VCS và thư viện UVM tương ứng. Chọn version có sẵn trong tài khoản; ghi version thực tế vào báo cáo. Repo chưa xác minh simulation trên nền tảng này.

## Công cụ local tùy chọn

Các script local dùng compiler được gọi trong `scripts/run.sh`, Bash, Git, GNU Make, C++ và ripgrep. Set UVM_HOME tới checkout UVM tương thích nếu dùng script local; không cần các công cụ này để dán source lên Playground.

`scripts/setup_uvm.sh` tải thư viện từ [CHIPS Alliance uvm-verilator](https://github.com/chipsalliance/uvm-verilator), pin commit `5d72b6618acfddece7f09382a032ccbc05862fdc`. Dependency giữ Apache-2.0 license và NOTICE riêng, không được phân phối trong repo. Thư viện này phục vụ script local, không thay thế thư viện UVM của EDA Playground.
