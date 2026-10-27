# Universe Liquid Glass

Vũ trụ thu nhỏ cho **Zen Browser**: nền đen sâu, sao trắng lấp lánh, thiên thể đi ngang qua và tab **liquid glass** sáng rõ.

[Tải bản cài đặt](https://github.com/psy-zney/UniverseLiquidGlass/releases/latest) · [Xem video demo](media/theme-demo.mp4) · [English](../README.md)

## Video demo

https://github.com/user-attachments/assets/91497d1d-f244-4eb9-b1db-a82097c5d6c2

*53,5 giây: đủ 9 sự kiện vũ trụ với khung phóng to 2,3×, chuyển tab sidebar, loading và Downloads. [Tải MP4](media/theme-demo.mp4) · [Phụ đề tiếng Việt](media/theme-demo.vi.srt).*

## Có gì bên trong?

- Các điểm sao rải bất quy tắc, nhấp nháy lệch nhịp; nền gần đen, không dùng tông tím.
- **9 sự kiện:** sao chổi bay chéo, ngôi sao, hành tinh, sao lùn trắng, hố đen, sao neutron, tinh vân, sao xanh và thiên hà.
- Ánh sáng cục bộ đi theo thiên thể, xuyên nhẹ qua tab kính. Hố đen có đĩa bồi tụ và mô phỏng bẻ cong ánh sao.
- Hiệu ứng ở sidebar, thanh trên và viền luôn nằm sau nội dung/nút bấm, không chặn chuột.
- Tab đang chọn có viền kính sáng; tab đang tải có chuyển động riêng.
- Downloads rộng hơn, tên tệp dễ đọc; chỉnh tương phản ở Library, Spaces, History và popup chọn của trang web.
- CSS + SVG nội bộ; không tải ảnh, font hay JavaScript từ Internet khi sử dụng theme.

## Video sử dụng

**[▶ Xem hoặc tải MP4 — 54 giây](https://github.com/psy-zney/UniverseLiquidGlass/raw/refs/heads/main/docs/media/theme-demo.mp4)**

| Đoạn | Nội dung |
| --- | --- |
| 00:00 | Giao diện nền đen và tab kính |
| 00:03–00:34 | Lần lượt 9 sự kiện, gồm hố đen, sao neutron và tinh vân |
| 00:34–00:42 | Chuyển ba tab bằng sidebar |
| 00:42–00:45 | Trạng thái loading |
| 00:45–00:49 | Downloads |
| 00:49–00:54 | Cách cài đặt |

Khung zoom chỉ nằm trong video dựng, không phải lớp phủ của theme. Video quay giao diện Zen thật bằng profile riêng; các trang và tệp tải là dữ liệu demo. Thời gian từng sự kiện được dựng gọn để xem hết trong một video. Theme thực tế dùng chu kỳ sidebar **70 giây**, thanh trên **84 giây**.

<details>
<summary>Xem nhanh animation sidebar</summary>

![Animation sidebar](media/sidebar-preview.gif)

</details>

## Cài nhanh trên Windows

1. Tải **UniverseLiquidGlass-v1.1.9.zip** (hoặc bản mới nhất) ở [Releases](https://github.com/psy-zney/UniverseLiquidGlass/releases/latest) và giải nén hoàn toàn.
2. **Thoát hoàn toàn Zen Browser.** Chạy `install.cmd` trong thư mục đã giải nén (nếu Zen đang mở, bộ cài sẽ nhắc bạn đóng Zen rồi mới tiếp tục).
3. Mở lại Zen, bật giao diện **Dark** và sidebar tab dọc mở rộng để trải nghiệm.

Bộ cài tự động quét và nhận diện tất cả profile Zen (dù là Zen mới cài hay đã sử dụng lâu với nhiều profile) và áp dụng theme cho tất cả profile một cách an toàn (mỗi profile đều có bản sao lưu riêng). Nếu chỉ muốn cài cho một profile nhất định, bạn có thể truyền thêm `-ProfilePath`:

```powershell
.\install.cmd -ProfilePath "C:\path\to\your\Zen\profile"
```

Kiểm tra trước, chưa thay đổi tệp:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -ProfilePath "C:\path\to\your\Zen\profile" -WhatIf
```

### Bộ cài thay đổi gì?

- Sao lưu `chrome/userChrome.css`, `chrome/userContent.css`, `user.js` và bản theme cũ nếu có, vào `.universe-liquid-glass-backups/<thời điểm>/` trong profile.
- Đặt hai CSS của theme trong `chrome/UniverseLiquidGlass/`; thêm đúng một dòng `@import` vào mỗi CSS gốc. CSS riêng của bạn được giữ lại.
- Thêm một khối có nhãn vào `user.js` để bật `toolkit.legacyUserProfileCustomizations.stylesheets`.
- Không chạm vào bookmark, mật khẩu, tiện ích hay lịch sử. Không tự đóng Zen. Profile đang bị khóa sẽ được từ chối cài.

Nếu đã có theme khác, quy tắc của theme đó có thể ghi đè giao diện này. Hãy sao lưu rồi tắt các import theme xung đột.

## Cài thủ công — Windows, macOS, Linux

1. Mở `about:profiles` → mở **Root Directory** của profile dùng theme. Thoát Zen.
2. Tạo thư mục `chrome/UniverseLiquidGlass/` bên trong profile; chép `theme/userChrome.css` và `theme/userContent.css` vào đó.
3. Tạo hoặc sửa `chrome/userChrome.css`, đặt ở đầu tệp (sau `@charset` nếu có):

   ```css
   @import url("UniverseLiquidGlass/userChrome.css");
   ```

4. Trong `chrome/userContent.css`, thêm tương tự:

   ```css
   @import url("UniverseLiquidGlass/userContent.css");
   ```

5. Trong `about:config`, đặt `toolkit.legacyUserProfileCustomizations.stylesheets` thành `true` rồi khởi động lại Zen.

Đã kiểm tra trên **Zen 1.23.2b / Windows**. macOS/Linux có hướng dẫn thủ công nhưng chưa được kiểm tra trực tiếp. Đây là theme CSS cục bộ; repo này **chưa được gửi lên kho Zen Mods chính thức**.

## Gỡ và khôi phục

Thoát Zen rồi chạy `uninstall.cmd`, hoặc:

```powershell
.\uninstall.cmd -ProfilePath "C:\path\to\your\Zen\profile"
```

Bộ gỡ bỏ import và tệp do bộ cài quản lý, giữ CSS tùy chỉnh, sửa đổi thêm sau khi cài và các bản sao lưu. Tùy chọn bật CSS có thể vẫn được Zen giữ trong `prefs.js`; nó không nạp theme sau khi đã gỡ import.

Nếu cài thủ công, tự xóa hai dòng import và thư mục `chrome/UniverseLiquidGlass/`. Muốn trở về chính xác cấu hình cũ, dùng các tệp trong thư mục sao lưu khi Zen đã đóng.

## Tùy chỉnh và phát triển

```text
theme/                  CSS sẵn dùng
src/sidebar.css         Lớp sao và chuyển động sidebar
src/cosmic_events.py     Thiên thể, ánh sáng và lịch sự kiện
src/deep_space_assets.py Bầu trời và chi tiết SVG
src/ui.css              Tab kính, thanh trên, Library và popup
scripts/build.py        Tạo CSS bằng Python, không cần package ngoài
videos/demo/            Timeline, trang demo và mã quay video
```

```powershell
python scripts/build.py
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/test-install.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/package.ps1
```

Muốn tăng/giảm thời gian sự kiện: sửa `SCHEDULE` trong `src/cosmic_events.py`, rồi build lại. Muốn sửa độ sáng tab: chỉnh nền và viền `.tab-background` trong `src/ui.css`.

## Lưu ý

- Hố đen và ánh sáng là mô phỏng đồ họa; không phải mô phỏng vật lý đầy đủ.
- CSS không thể tự suy ra độ tương phản của mọi website. Bản sửa xử lý các popup và bề mặt Zen đã kiểm tra; không ép toàn bộ trang web sang nền tối.
- Compact mode vẫn hoạt động: khi thanh công cụ tự ẩn, sự kiện hiện trong phần viền trên còn lộ ra.
- Backdrop blur và animation có thể tốn GPU. Giao diện của Zen có thể thay đổi selector khi cập nhật.

MIT · [psy-zney](https://github.com/psy-zney)
