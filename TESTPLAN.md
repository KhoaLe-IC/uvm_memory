# Test plan

| ID | Requirement | Stimulus | Checker |
|---|---|---|---|
| T01 | M01 | Giữ reset qua ít nhất hai cạnh clock | `rvalid=0`, `rdata=0` |
| T02 | M02 | Ghi cả 16 địa chỉ với pattern xác định | Model lưu dữ liệu; `rvalid=0` |
| T03 | M03 | Đọc lại cả 16 địa chỉ | So sánh với model, `rvalid=1` |
| T04 | M02–M03 | Ghi đè và đọc địa chỉ biên 0, 15 | Dữ liệu mới được trả về |
| T05 | M02–M03 | 100 thao tác ngẫu nhiên có seed | Model độc lập kiểm tra mọi read |
| T06 | M04 | Chu kỳ idle giữa request | `rvalid=0` |
| T07 | M01 | Reset sau khi đã ghi, thử ghi trong reset, rồi đọc lại | Response reset và nội dung giữ nguyên |

T07 chạy sau chuỗi chính; báo cáo thực tế ở `results/VALIDATION.md`. Test không đọc ô chưa ghi. Không kết luận “full coverage” từ số lượng request.
