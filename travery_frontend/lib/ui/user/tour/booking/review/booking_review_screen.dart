import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/user/tour/booking/view_models/booking_view_model.dart';
import 'package:travery_frontend/utils/format_utils.dart';

class BookingReviewScreen extends StatefulWidget {
  const BookingReviewScreen({super.key});

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  bool _isAgreed = true;
  bool _isLoading = false;
  String? _errorMessage;
  final _specialNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BookingViewModel>();
      _specialNotesController.text = vm.specialNotes;
    });
  }

  @override
  void dispose() {
    _specialNotesController.dispose();
    super.dispose();
  }

  Future<void> _handleProceedPayment() async {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng đồng ý với điều khoản dịch vụ.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final vm = context.read<BookingViewModel>();
    vm.setSpecialNotes(_specialNotesController.text);
    await vm.createBooking();

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (vm.errorMessage != null) {
      setState(() => _errorMessage = vm.errorMessage);
      vm.clearError();
      return;
    }

    if (vm.bookingResult != null && mounted) {
      context.pushReplacement(Routes.vnpayPayment, extra: vm.bookingResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: _isLoading ? null : () => Navigator.pop(context),
          ),
          title: const Text(
            'Kiểm tra thông tin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: Consumer<BookingViewModel>(
          builder: (context, vm, child) {
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailsSection(vm),
                        const SizedBox(height: 16),
                        _buildPassengerListSection(vm),
                        const SizedBox(height: 16),
                        _buildSpecialNotesSection(),
                        const SizedBox(height: 16),
                        _buildTermsCheckbox(),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          _buildErrorBanner(),
                        ],
                        const SizedBox(height: 160),
                      ],
                    ),
                  ),
                ),
                _buildFooterActionBar(vm),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BookingViewModel vm) {
    final tour = vm.tour;
    final instance = vm.selectedInstance;

    String dateRange = 'N/A';
    if (instance != null) {
      dateRange =
          '${FormatUtils.formatDateString(instance.startDate)} - ${FormatUtils.formatDateString(instance.endDate)}';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tour?.name ?? 'N/A',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                dateRange,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Điểm đón: ${tour?.startLocation ?? 'Hà Nội'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '${tour?.durationDays ?? 0} ngày ${(tour?.durationDays ?? 1) - 1} đêm',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerListSection(BookingViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DANH SÁCH KHÁCH',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          ...vm.members.asMap().entries.map<Widget>((entry) {
            final idx = entry.key;
            final member = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: idx < vm.members.length - 1 ? 12 : 0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${idx + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.fullName.isEmpty
                              ? 'Chưa nhập'
                              : member.fullName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: member.fullName.isEmpty
                                ? AppColors.textHint
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'CCCD/Hộ chiếu: ${member.identityNumber.isEmpty ? 'Chưa nhập' : member.identityNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: member.identityNumber.isEmpty
                                ? AppColors.textHint
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: member.type == MemberType.adult
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      member.type == MemberType.adult ? 'Người lớn' : 'Trẻ em',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: member.type == MemberType.adult
                            ? AppColors.primary
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                FormatUtils.formatCurrency(vm.totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ghi chú đặc biệt',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _specialNotesController,
            maxLines: 3,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'VD: Dị ứng hải sản, yêu cầu phòng tầng cao...',
              hintStyle: const TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
              ),
              fillColor: AppColors.inputBackground,
              filled: true,
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _isAgreed,
            activeColor: AppColors.primary,
            onChanged: (value) => setState(() => _isAgreed = value ?? false),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isAgreed = !_isAgreed),
            child: const Text.rich(
              TextSpan(
                text: 'Tôi đã đọc và đồng ý với các ',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Điều khoản sử dụng',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' và '),
                  TextSpan(
                    text: 'Chính sách hoàn hủy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' của Travery.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 13, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActionBar(BookingViewModel vm) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.inputBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, -8),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'TỔNG THANH TOÁN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  FormatUtils.formatCurrency(vm.totalPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleProceedPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.textHint,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tiếp tục',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
