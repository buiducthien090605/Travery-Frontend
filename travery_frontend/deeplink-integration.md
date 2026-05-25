# Deep Link Integration Guide

> Deeplink cho app Travery — dùng để redirect về app sau khi thanh toán VNPay.

## Deep Link URL

```
travery://payment-result
```

## Query Parameters

Backend cần gửi kèm khi redirect:

| Param          | Type   | Required | Description             |
|----------------|--------|----------|-------------------------|
| `txnRef`       | String |    Yes   | Transaction ID từ VNPay |
| `status`       | String |    Yes   | `success` hoặc `failed` |
| `responseCode` | String |    No    |  Mã phản hồi từ VNPay   |

## URL Đầy Đủ

### Thành công
```
travery://payment-result?txnRef=363aa397-1ec1-4571-ae62-c282e02e0b89&status=success&responseCode=00
```

### Thất bại (user hủy)
```
travery://payment-result?txnRef=363aa397-1ec1-4571-ae62-c282e02e0b89&status=failed&responseCode=24
```

## Mã Phản Hồi VNPay (responseCode)

| Code | Ý nghĩa |
|---|---|
| `00` | Giao dịch thành công |
| `24` | User hủy giao dịch |
| `51` | Tài khoản không đủ số dư |
| `65` | Vượt hạn mức thanh toán trong ngày |
| `75` | Ngân hàng đang bảo trì |

## Backend Redirect Flow

```
VNPay Gateway
    │
    │  Redirect về Return URL của BE
    ▼
https://{backend}/api/v1/payments/vnpay-return?vnp_TxnRef=xxx&vnp_ResponseCode=00
    │
    │  BE verify checksum → build deeplink → HTTP 302
    ▼
travery://payment-result?txnRef=xxx&status=success&responseCode=00
    │
    │  Mobile OS bắt deeplink → mở app
    ▼
App Travery → PaymentResultScreen → Poll API → Xác nhận PAID
```

## Cấu Hình App (đã xong bên FE)

### Android — `android/app/src/main/AndroidManifest.xml`
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="travery"
        android:host="payment-result" />
</intent-filter>
```

### iOS — `ios/Runner/Info.plist`
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>travery</string>
        </array>
        <key>CFBundleURLName</key>
        <string>com.travery.app</string>
    </dict>
</array>
```

## Màn Hình Kết Quả Trong App

Sau khi nhận deeplink, app sẽ hiện 4 trạng thái:

1. **Đang xác nhận** (spinner) — poll API để xác nhận PAID
2. **Thành công** — booking đã được xác nhận PAID
3. **Thất bại** — user hủy hoặc booking CANCELLED
4. **Đang xử lý** — poll timeout, user có thể bấm "Kiểm tra lại"

## Lưu Ý Quan Trọng

- Backend **trả về 302** (không phải 200) thì mobile OS mới bắt được deeplink
- `app_links` package đã được thêm vào Flutter — cần **build lại app** sau khi thêm
- VNPay IPN (Instant Payment Notification) có thể delay 1-5 giây, nên app poll với exponential backoff
