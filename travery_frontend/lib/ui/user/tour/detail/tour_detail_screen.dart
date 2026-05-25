import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/user/tour/detail/view_models/tour_detail_view_model.dart';
import 'package:travery_frontend/ui/user/tour/booking/view_models/booking_view_model.dart';
import 'package:travery_frontend/utils/format_utils.dart';
import 'package:travery_frontend/data/seed_models/tour_instance/tour_instance.dart';
import 'package:travery_frontend/data/models/tour/tour_detail_page_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'widgets/tour_image_carousel.dart';
import 'widgets/section_title.dart';
import 'widgets/departure_item.dart';

class TourDetailScreen extends StatefulWidget {
  final String? tourId;

  const TourDetailScreen({super.key, this.tourId});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  late TourDetailViewModel _viewModel;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<TourDetailViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTour();
    });
  }

  void _loadTour() {
    if (widget.tourId != null) {
      _viewModel.loadTourDetail(widget.tourId!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<TourDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.tourId != null) {
                        viewModel.loadTourDetail(widget.tourId!);
                      }
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final tour = viewModel.tour;
          if (tour == null) {
            return const Center(child: Text('Không tìm thấy tour'));
          }

          final images = tour.images?.map((img) => img.url).toList() ?? [];
          final priceAdult = FormatUtils.formatCurrency(tour.pricePerAdult);
          final priceChild = FormatUtils.formatCurrency(tour.pricePerChild);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TourImageCarousel(
                      images: images,
                      pageController: _pageController,
                      currentPage: _currentPage,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildPriceSection(priceAdult, priceChild),
                          const SizedBox(height: 32),
                          _buildScheduleSection(viewModel),
                          const SizedBox(height: 32),
                          _buildDetailedItinerarySection(tour),
                          const SizedBox(height: 32),
                          _buildRefundPolicySection(tour),
                          _buildDescriptionSection(tour),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomBookingBar(viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriceSection(String priceAdult, String priceChild) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.payments, title: 'Giá tour'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPriceCard('Giá người lớn', priceAdult)),
            const SizedBox(width: 12),
            Expanded(child: _buildPriceCard('Giá trẻ em', priceChild)),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceCard(String label, String price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(TourDetailViewModel viewModel) {
    final instances = viewModel.availableInstances;
    if (instances.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.calendar_month, title: 'Lịch khởi hành'),
        const SizedBox(height: 16),
        ...instances.map((instance) {
          final idx = instances.indexOf(instance);
          final isSelected = idx == viewModel.selectedInstanceIndex;
          return DepartureItem(
            instance: instance,
            isSelected: isSelected,
            onTap: () => viewModel.selectInstance(idx),
          );
        }),
      ],
    );
  }

  String _formatInstanceStatus(TourInstanceStatus status) {
    switch (status) {
      case TourInstanceStatus.PLANNING:
        return 'Đang lên kế hoạch';
      case TourInstanceStatus.OPEN:
        return 'Mở bán';
      case TourInstanceStatus.FULL:
        return 'Đã đầy';
      case TourInstanceStatus.IN_PROGRESS:
        return 'Đang diễn ra';
      case TourInstanceStatus.COMPLETED:
        return 'Hoàn thành';
      case TourInstanceStatus.CANCELLED:
        return 'Đã hủy';
      case TourInstanceStatus.POSTPONED:
        return 'Tạm hoãn';
    }
  }

  Widget _buildDetailedItinerarySection(TourDetailPageData tour) {
    final itineraries = tour.itineraryList ?? [];

    if (itineraries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.route, title: 'Lịch trình chi tiết'),
        const SizedBox(height: 16),
        ...itineraries.map((day) => _buildItineraryDay(day)),
      ],
    );
  }

  Widget _buildItineraryDay(TourItineraryPageData day) {
    final hasImages = day.images != null && day.images!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Ngày ${day.dayNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      day.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (hasImages)
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(12),
                  itemCount: day.images!.length,
                  itemBuilder: (context, index) {
                    final image = day.images![index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < day.images!.length - 1 ? 8 : 0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: image.url,
                          width: 250,
                          height: 156,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 250,
                            height: 156,
                            color: AppColors.inputBackground,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 250,
                            height: 156,
                            color: AppColors.inputBackground,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (day.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  day.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(TourDetailPageData tour) {
    final description = tour.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.description, title: 'Mô tả'),
        const SizedBox(height: 16),
        if (description != null && description.isNotEmpty)
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          )
        else
          const Text(
            'Không có mô tả cho tour này.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
      ],
    );
  }

  Widget _buildRefundPolicySection(TourDetailPageData tour) {
    final refundPolicy = tour.refundPolicy;
    if (refundPolicy == null || refundPolicy.rules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.policy, title: 'Chính sách hoàn tiền'),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.policy,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        refundPolicy.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...refundPolicy.rules.asMap().entries.map((entry) {
                final idx = entry.key;
                final rule = entry.value;
                final isLast = idx == refundPolicy.rules.length - 1;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: AppColors.inputBorder,
                              width: 0.5,
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${rule.daysBefore}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primary,
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
                              rule.daysBefore == 0
                                  ? 'Trước giờ khởi hành'
                                  : '${rule.daysBefore} ngày trước',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hoàn ${rule.refundPercentage.toInt()}%',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: rule.refundPercentage >= 100
                              ? Colors.green.withValues(alpha: 0.1)
                              : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${rule.refundPercentage.toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: rule.refundPercentage >= 100
                                ? Colors.green
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void _handleBookTour(TourDetailViewModel viewModel) {
    // Get BookingViewModel from parent (root) provider, not from router's new instance
    final rootProvider = Provider.of<BookingViewModel>(context, listen: false);

    if (viewModel.tour == null) return;

    rootProvider.setTourData(
      tour: viewModel.tour!,
      selectedInstance: viewModel.selectedInstance,
    );
    context.push(Routes.tourBooking);
  }

  Widget _buildBottomBookingBar(TourDetailViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          border: const Border(
            top: BorderSide(color: AppColors.inputBorder, width: 0.5),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => _handleBookTour(viewModel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: AppColors.buttonPrimaryText,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'ĐẶT TOUR NGAY',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
