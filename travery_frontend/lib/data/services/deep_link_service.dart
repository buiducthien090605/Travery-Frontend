import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:travery_frontend/routing/routes.dart';

typedef DeepLinkHandler = void Function(Uri uri);

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  final _streamController = StreamController<Uri>.broadcast();
  Stream<Uri> get uriStream => _streamController.stream;

  GoRouter? _router;
  DeepLinkHandler? _paymentHandler;

  Uri? _pendingUri;

  void registerRouter(GoRouter router) {
    _router = router;

    Logger.root.info('DeepLinkService: Router registered');

    // Xử lý URI đã nhận trước đó (cold start)
    if (_pendingUri != null) {
      Logger.root.info('DeepLinkService: Processing pending URI: $_pendingUri');
      _processDeepLink(_pendingUri!);
      _pendingUri = null;
    }
  }

  void registerPaymentHandler(DeepLinkHandler handler) {
    _paymentHandler = handler;
  }

  /// Xử lý URI từ app_links
  void handleUri(Uri uri) {
    Logger.root.info('DeepLinkService: Received URI: $uri');
    Logger.root.info('  scheme: ${uri.scheme}, host: ${uri.host}');

    _streamController.add(uri);

    // Chỉ xử lý deep link của app
    if (uri.scheme == 'travery' && uri.host == 'payment-result') {
      Logger.root.info('DeepLinkService: Processing as payment deep link');

      _paymentHandler?.call(uri);

      if (_router != null) {
        _processDeepLink(uri);
      } else {
        Logger.root.info(
          'DeepLinkService: Router not ready, saving pending URI',
        );
        _pendingUri = uri;
      }
    } else {
      Logger.root.warning(
        'DeepLinkService: URI not handled - scheme/host mismatch',
      );
    }
  }

  void _processDeepLink(Uri uri) {
    if (_router == null) {
      Logger.root.warning('DeepLinkService: Cannot process, router is null');
      return;
    }

    // Trích xuất query parameters từ URI
    final txnRef = uri.queryParameters['txnRef'];
    final status = uri.queryParameters['status'];
    final responseCode = uri.queryParameters['responseCode'];

    Logger.root.info('DeepLinkService: Navigating to payment result screen');
    Logger.root.info(
      '  txnRef: $txnRef, status: $status, responseCode: $responseCode',
    );

    // Navigate đến màn hình kết quả thanh toán với dữ liệu từ deep link
    _router!.push(
      Routes.paymentResult,
      extra: {'txnRef': txnRef, 'status': status, 'responseCode': responseCode},
    );
  }

  void dispose() {
    _streamController.close();
  }
}
