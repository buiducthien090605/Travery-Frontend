import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/user/tour/booking/view_models/booking_view_model.dart';
import 'package:travery_frontend/utils/format_utils.dart';

class TourBookingScreen extends StatefulWidget {
  const TourBookingScreen({super.key});

  @override
  State<TourBookingScreen> createState() => _TourBookingScreenState();
}

class _TourBookingScreenState extends State<TourBookingScreen> {
  final Map<int, TextEditingController> _nameControllers = {};
  final Map<int, TextEditingController> _identityControllers = {};
  final _specialNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _specialNotesController.addListener(_onSpecialNotesChanged);
  }

  void _onSpecialNotesChanged() {
    context.read<BookingViewModel>().setSpecialNotes(
      _specialNotesController.text,
    );
  }

  @override
  void dispose() {
    for (final c in _nameControllers.values) {
      c.dispose();
    }
    for (final c in _identityControllers.values) {
      c.dispose();
    }
    _specialNotesController.dispose();
    super.dispose();
  }

  TextEditingController _getNameController(int index) {
    return _nameControllers.putIfAbsent(index, () {
      final vm = context.read<BookingViewModel>();
      final member = index < vm.members.length ? vm.members[index] : null;
      return TextEditingController(text: member?.fullName ?? '');
    });
  }

  TextEditingController _getIdentityController(int index) {
    return _identityControllers.putIfAbsent(index, () {
      final vm = context.read<BookingViewModel>();
      final member = index < vm.members.length ? vm.members[index] : null;
      return TextEditingController(text: member?.identityNumber ?? '');
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'DD/MM/YYYY';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _selectBirthDate(
    BuildContext context,
    int index,
    bool isChild,
  ) async {
    final vm = context.read<BookingViewModel>();
    final DateTime now = DateTime.now();

    final DateTime firstDate;
    final DateTime lastDate;

    if (isChild) {
      firstDate = DateTime(now.year - 10);
      lastDate = now;
    } else {
      firstDate = DateTime(1920);
      lastDate = now;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          index < vm.members.length && vm.members[index].dateOfBirth != null
          ? vm.members[index].dateOfBirth!
          : (isChild
                ? DateTime(now.year - 5, now.month, now.day)
                : DateTime(2000, 1, 1)),
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      vm.updateMember(index, dateOfBirth: picked);
    }
  }

  void _handleSubmit() {
    final vm = context.read<BookingViewModel>();
    final errors = vm.getAllErrors();

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errors.first),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.push(Routes.tourBookingReview);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Thông tin đặt tour',
          style: TextStyle(
            fontFamily: 'Be Vietnam Pro',
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: AppColors.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<BookingViewModel>(
        builder: (context, vm, child) {
          if (vm.isSubmitting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('Đang xử lý đặt tour...'),
                ],
              ),
            );
          }

          final tour = vm.tour;
          if (tour == null) {
            return const Center(child: Text('Không có thông tin tour'));
          }

          final pricePerAdult = tour.pricePerAdult.toInt();
          final pricePerChild = tour.pricePerChild.toInt();
          int totalAmount =
              (vm.adultCount * pricePerAdult) + (vm.childCount * pricePerChild);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTourInfoCard(tour, vm),
                    const SizedBox(height: 24),
                    _buildPassengerCountSection(vm),
                    const SizedBox(height: 24),
                    _buildPassengerListSection(vm),
                    const SizedBox(height: 24),
                    _buildPriceSummarySection(
                      totalAmount,
                      vm,
                      pricePerAdult,
                      pricePerChild,
                    ),
                    const SizedBox(height: 24),
                    _buildSpecialNotesSection(),
                  ],
                ),
              ),
              _buildBottomActionBar(totalAmount, vm),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTourInfoCard(dynamic tour, BookingViewModel vm) {
    final instance = vm.selectedInstance;
    String dateRange = 'N/A';
    if (instance != null) {
      dateRange =
          '${FormatUtils.formatDateString(instance.startDate)} - ${FormatUtils.formatDateString(instance.endDate)}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  tour.images?.isNotEmpty == true
                      ? tour.images!.first.url
                      : 'https://picsum.photos/80',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.inputBackground,
                    child: const Icon(
                      Icons.image,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.name,
                      style: const TextStyle(
                        fontFamily: 'Be Vietnam Pro',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'MÃ TOUR: N/A',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.inputBorder),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            children: [
              _buildInfoGridItem('NGÀY KHỞI HÀNH', dateRange),
              _buildInfoGridItem(
                'THỜI GIAN',
                '${tour.durationDays} ngày ${tour.durationDays - 1} đêm',
              ),
              _buildInfoGridItem('ĐIỂM ĐÓN', tour.startLocation ?? 'Hà Nội'),
              _buildInfoGridItem('SỐ LƯỢNG KHÁCH', 'Min 10 - Max 30 người'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGridItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerCountSection(BookingViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Số lượng hành khách',
            style: TextStyle(
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Người lớn',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Từ 12 tuổi trở lên',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  _buildCounterButton(
                    value: vm.adultCount,
                    onRemove: () => vm.setAdultCount(vm.adultCount - 1),
                    onAdd: () => vm.setAdultCount(vm.adultCount + 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Trẻ em',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Dưới 10 tuổi',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  _buildCounterButton(
                    value: vm.childCount,
                    onRemove: () => vm.setChildCount(vm.childCount - 1),
                    onAdd: () => vm.setChildCount(vm.childCount + 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Yêu cầu tối thiểu 10 khách để khởi hành.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterButton({
    required int value,
    required VoidCallback onRemove,
    required VoidCallback onAdd,
  }) {
    final bool isMinusDisabled = value <= 1;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isMinusDisabled ? null : onRemove,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surface,
              child: Icon(
                Icons.remove,
                size: 20,
                color: isMinusDisabled ? AppColors.textHint : AppColors.primary,
              ),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              value.toString().padLeft(2, '0'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAdd,
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerListSection(BookingViewModel vm) {
    int totalMembers = vm.adultCount + vm.childCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách thành viên',
                style: TextStyle(
                  fontFamily: 'Be Vietnam Pro',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${totalMembers.toString().padLeft(2, '0')} Thành viên',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalMembers,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final isAdult = index < vm.adultCount;
            int displayIndex = isAdult ? index + 1 : index - vm.adultCount + 1;
            String typeLabel = isAdult ? 'Người lớn' : 'Trẻ em';

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Hành khách $displayIndex ($typeLabel)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.inputBorder),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'HỌ VÀ TÊN *',
                    placeholder: 'Nguyễn Văn A',
                    controller: _getNameController(index),
                    onChanged: (value) =>
                        vm.updateMember(index, fullName: value),
                    validator: (v) => vm.validateMemberName(v ?? ''),
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    label: 'SỐ CMND/HỘ CHIẾU *',
                    placeholder: '123456789',
                    controller: _getIdentityController(index),
                    onChanged: (value) =>
                        vm.updateMember(index, identityNumber: value),
                    validator: (v) => vm.validateIdentityNumber(v ?? ''),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildDatePickerField(
                    label: isAdult
                        ? 'NGÀY SINH (KHÔNG BẮT BUỘC)'
                        : 'NGÀY SINH * (DƯỚI 10 TUỔI)',
                    index: index,
                    vm: vm,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: AppColors.textHint),
              fillColor: AppColors.inputBackground,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required int index,
    required BookingViewModel vm,
  }) {
    final member = index < vm.members.length ? vm.members[index] : null;
    final dateOfBirth = member?.dateOfBirth;
    final bool isChild = member?.type == MemberType.child;
    final bool hasValue = dateOfBirth != null;

    String? ageError;
    if (isChild && hasValue) {
      ageError = vm.validateChildAge(dateOfBirth, index);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _selectBirthDate(context, index, isChild),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ageError != null
                    ? AppColors.error
                    : AppColors.inputBorder,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(dateOfBirth),
                  style: TextStyle(
                    fontSize: 14,
                    color: hasValue
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: hasValue ? AppColors.primary : AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
        if (ageError != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              ageError,
              style: const TextStyle(fontSize: 11, color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSummarySection(
    int totalAmount,
    BookingViewModel vm,
    int pricePerAdult,
    int pricePerChild,
  ) {
    String formatCurrency(int amount) {
      return '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Tạm tính',
            style: TextStyle(
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Người lớn (${vm.adultCount} x ${formatCurrency(pricePerAdult)})',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    formatCurrency(vm.adultCount * pricePerAdult),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trẻ em (${vm.childCount} x ${formatCurrency(pricePerChild)})',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    formatCurrency(vm.childCount * pricePerChild),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.inputBorder),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Tổng cộng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    formatCurrency(totalAmount),
                    style: const TextStyle(
                      fontFamily: 'Be Vietnam Pro',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Ghi chú đặc biệt',
            style: TextStyle(
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            children: [
              TextField(
                controller: _specialNotesController,
                maxLines: 4,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'VD: Dị ứng hải sản, yêu cầu phòng tầng cao, v.v.',
                  hintStyle: const TextStyle(color: AppColors.textHint),
                  fillColor: AppColors.inputBackground,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Danh sách khách phải được chốt trước 5 ngày khởi hành.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(int totalAmount, BookingViewModel vm) {
    String formatCurrency(int amount) {
      return '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
    }

    int totalPeople = vm.adultCount + vm.childCount;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TỔNG CỘNG ($totalPeople NGƯỜI)',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatCurrency(totalAmount),
                      style: const TextStyle(
                        fontFamily: 'Be Vietnam Pro',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: vm.isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.textHint,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Tiếp tục thanh toán',
                      style: TextStyle(
                        fontFamily: 'Be Vietnam Pro',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
