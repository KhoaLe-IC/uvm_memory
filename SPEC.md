# Specification: bộ nhớ đồng bộ một cổng

Bộ nhớ gồm 16 ô, mỗi ô 8 bit. Clock cạnh lên, chu kỳ testbench 10 ns. `rst_n` active-low và đồng bộ.

| ID | Hành vi |
|---|---|
| M01 | Khi `rst_n=0` tại cạnh lên: `rvalid=0`, `rdata=0`; bộ nhớ giữ nội dung; các request bị bỏ qua. |
| M02 | Khi `rst_n=1`, `req=1`, `we=1`: ghi `wdata` vào ô `addr` tại cạnh lên; `rvalid=0`; `rdata` giữ nguyên. |
| M03 | Khi `rst_n=1`, `req=1`, `we=0`: sau cạnh lên, `rdata` là nội dung ô `addr`, `rvalid=1`. |
| M04 | Khi `req=0`: không truy cập bộ nhớ; `rvalid=0`; `rdata` giữ nguyên. |
| M05 | Đọc địa chỉ chưa từng ghi có dữ liệu không xác định và nằm ngoài phạm vi test này. |

Đây là giao diện request một chu kỳ, mỗi cạnh lên xử lý tối đa một request. Testbench drive trước cạnh lên và monitor đọc response sau NBA. Không có ready/stall. Reset không khởi tạo các ô nhớ. Phép đo coverage trong project là bộ đếm scenario, chưa phải native functional coverage.
