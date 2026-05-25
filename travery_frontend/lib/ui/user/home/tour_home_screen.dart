import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/routing/routes.dart';
import 'package:travery_frontend/ui/core/themes/app_colors.dart';
import 'package:travery_frontend/ui/core/themes/app_text_theme.dart';
import 'package:travery_frontend/ui/user/home/view_models/tour_home_view_model.dart';
import 'package:travery_frontend/ui/user/home/widgets/consultation_banner.dart';
import 'package:travery_frontend/ui/user/home/widgets/search_bar_widget.dart';
import 'package:travery_frontend/ui/user/home/widgets/service_grid.dart';
import 'package:travery_frontend/ui/user/home/widgets/section_header.dart';
import 'package:travery_frontend/ui/user/home/widgets/tour_card_compact.dart';
import 'package:travery_frontend/utils/format_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourHomeViewModel>().loadTours();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer<TourHomeViewModel>(
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
                    'Đã xảy ra lỗi',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppTextTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => viewModel.loadTours(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadTours(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchBarWidget(),
                  const SizedBox(height: 24),
                  const ServiceGrid(),
                  const SizedBox(height: 32),
                  SectionHeader(
                    title: 'Tour nổi bật',
                    onViewAllPressed: () => context.push(Routes.tourList),
                  ),
                  const SizedBox(height: 16),
                  _buildTourList(viewModel),
                  const SizedBox(height: 32),
                  ConsultationBanner(onContactPressed: () {}),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 20,
      title: const Row(
        children: [
          Icon(Icons.waving_hand, color: AppColors.primary, size: 24),
          SizedBox(width: 8),
          Text(
            'Xin chào, User',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTextTheme.labelLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  String _getValidImageUrl(String? url) {
    if (url != null && url.isNotEmpty) {
      return url;
    }
    return 'https://picsum.photos/400?random=${DateTime.now().millisecondsSinceEpoch}';
  }

  Widget _buildTourList(TourHomeViewModel viewModel) {
    final tours = viewModel.featuredTours;

    if (tours.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        child: const Text(
          'Không có tour nào',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: tours.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final tour = tours[index];
          return TourCardCompact(
            imageUrl: _getValidImageUrl(tour.thumbnailUrl),
            rating: '★ ${tour.averageRating?.toStringAsFixed(1) ?? 'N/A'}',
            duration:
                '${tour.durationDays ?? 0}N${(tour.durationDays ?? 1) - 1}Đ',
            title: tour.name,
            price: FormatUtils.formatCurrency(tour.price),
            onTap: () {
              context.push(Routes.tourDetail.replaceFirst(':id', tour.id));
            },
          );
        },
      ),
    );
  }
}
