import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travery_frontend/data/repositories/admin/admin_repository.dart';

import 'package:travery_frontend/data/repositories/authentication/auth_repository.dart';
import 'package:travery_frontend/data/repositories/coordinator/coordinator_repository.dart';
import 'package:travery_frontend/data/repositories/mission_repository.dart';
import 'package:travery_frontend/data/repositories/check_in_repository.dart';
import 'package:travery_frontend/data/repositories/tour_progress_repository.dart';
import 'package:travery_frontend/data/repositories/tour_completed_repository.dart';
import 'package:travery_frontend/data/services/api/model/booking/cancel_booking_response/cancel_booking_response.dart';
import 'package:travery_frontend/data/services/security_storage_service.dart';
import 'package:travery_frontend/ui/core/auth_guard.dart';
import 'package:travery_frontend/ui/admin/view/admin_main_screen.dart';
import 'package:travery_frontend/ui/admin/view/view_detail_account_screen.dart';
import 'package:travery_frontend/ui/admin/view_model/view_detail_account_view_model.dart';
import 'package:travery_frontend/ui/authentication/view_models/confirm_password_view_model.dart';
import 'package:travery_frontend/ui/authentication/view_models/forgot_password_view_model.dart';
import 'package:travery_frontend/ui/authentication/view_models/register_view_model.dart';
import 'package:travery_frontend/ui/coordinator/view/coordinator_main_screen.dart';
import 'package:travery_frontend/ui/user/tour/booking/cancel_confirmation/cancel_confirmation_screen.dart';
import 'package:travery_frontend/ui/user/tour/booking/cancel_confirmation/view_models/cancel_confirmation_view_model.dart';
import 'package:travery_frontend/ui/user/tour/booking/cancellation_success/cancellation_success_screen.dart';
import 'package:travery_frontend/ui/user/tour/booking/cancellation_success/view_models/cancellation_success_view_model.dart';
import 'package:travery_frontend/ui/guide/home/guide_home_screen.dart';
import 'package:travery_frontend/ui/guide/mission/mission_detail_screen.dart';
import 'package:travery_frontend/ui/guide/mission/view_models/mission_detail_view_model.dart';
import 'package:travery_frontend/ui/guide/mission/check_in/check_in_screen.dart';
import 'package:travery_frontend/ui/guide/mission/check_in/view_models/check_in_view_model.dart';
import 'package:travery_frontend/ui/guide/mission/tour_progress/tour_progress_screen.dart';
import 'package:travery_frontend/ui/guide/mission/tour_progress/view_models/tour_progress_view_model.dart';
import 'package:travery_frontend/ui/guide/mission/tour_completed/our_completed_screen.dart';
import 'package:travery_frontend/ui/guide/mission/tour_completed/view_models/our_completed_view_model.dart';
import 'routes.dart';

import '../ui/authentication/view/login_screen.dart';
import '../ui/authentication/view/register_screen.dart';
import '../ui/authentication/view/otp_verification_screen.dart';
import '../ui/authentication/view/forgot_password_screen.dart';
import '../ui/authentication/view/confirm_password_screen.dart';
import '../ui/authentication/widgets/role_selection_screen.dart';
import '../ui/authentication/view_models/login_view_model.dart';
import '../ui/authentication/view_models/otp_verification_view_model.dart';
import '../ui/user/home/tour_home_screen.dart';
import '../ui/user/home/view_models/tour_home_view_model.dart';
import '../ui/user/tour/list/tour_list_screen.dart';
import '../ui/user/tour/list/view_models/tour_list_view_model.dart';
import '../ui/user/tour/detail/tour_detail_screen.dart';
import '../ui/user/tour/detail/view_models/tour_detail_view_model.dart';
import '../ui/user/tour/booking/tour_booking_screen.dart';
import '../ui/user/tour/booking/view_models/booking_view_model.dart';
import '../ui/admin/view/create_account_screen.dart';
import '../ui/admin/view/account_management_screen.dart';
import '../ui/admin/view/tour_management_screen.dart';
import '../ui/admin/view/vehicle_management_screen.dart';
import '../ui/admin/view/dashboard_screen.dart';
import '../ui/admin/view/hotel_management_screen.dart';
import '../ui/user/tour/booking/review/booking_review_screen.dart';
import '../ui/user/tour/booking/payment/vnpay_payment_screen.dart';
import '../ui/user/tour/booking/payment/payment_result_screen.dart';
import '../ui/user/tour/booking/payment/view_models/payment_view_model.dart';
import '../ui/user/tour/booking/booking_success_screen.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import '../ui/user/tour/booking/booking_detail/booking_detail_screen.dart';
import '../ui/admin/view/create_hotel_screen.dart';
import '../ui/admin/view/update_hotel_screen.dart';
import '../ui/admin/view/create_vehicle_screen.dart';
import '../ui/admin/view/update_vehicle_screen.dart';
import 'package:travery_frontend/ui/coordinator/view/coordinator_view_tour_list_screen.dart';
import 'package:travery_frontend/ui/coordinator/view_models/coordinator_tour_list_view_model.dart';
import 'package:travery_frontend/ui/coordinator/view/coordinator_view_tour_screen.dart';
import 'package:travery_frontend/ui/coordinator/view/coordinator_view_tour_template_list_screen.dart';
import 'package:travery_frontend/ui/coordinator/view_models/coordinator_tour_template_list_view_model.dart';
import 'package:travery_frontend/ui/coordinator/view/coordinator_create_tour_template_screen.dart';
import 'package:travery_frontend/ui/coordinator/view/coordinator_create_tour_screen.dart';
import 'package:travery_frontend/ui/coordinator/view_models/coordinator_create_tour_view_model.dart';
import 'package:travery_frontend/ui/coordinator/view/coordinator_view_template_screen.dart';
import 'package:travery_frontend/domain/models/coordinator/coordinator_tour/coordinator_tour.dart';
import 'package:travery_frontend/domain/models/coordinator/coordinator_tour_template/coordinator_tour_template.dart';
import 'package:travery_frontend/ui/admin/view_model/dashboard_view_model.dart';
import 'package:travery_frontend/ui/admin/view_model/account_management_view_model.dart';
import 'package:travery_frontend/ui/admin/view_model/create_account_view_model.dart';

GoRouter appRouter(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Xử lý deep link từ Android/iOS - convert scheme://host/path sang app route
      final uri = state.uri;

      // Nếu là deep link scheme của app
      if (uri.scheme == 'travery' && uri.host == 'payment-result') {
        // Trả về route path với query parameters để GoRouter navigate
        // GoRouter sẽ match /payment/result route và truyền query params qua state
        return '/payment/result';
      }

      return null; // Tiếp tục với route bình thường
    },
    routes: [
      // --- AUTHENTICATION ROUTES ---
      GoRoute(
        path: Routes.login,
        builder: (context, state) => LoginScreen(
          viewModel: LoginViewModel(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => RegisterScreen(
          viewModel: RegisterViewModel(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final email = extra['email'] as String;
          final password = extra['password'] as String?;
          final confirmPassword = extra['confirmPassword'] as String?;

          return OtpVerificationScreen(
            viewModel: OtpVerificationViewModel(
              authRepository: context.read<AuthRepository>(),
            ),
            email: email,
            password: password,
            confirmPassword: confirmPassword,
          );
        },
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => ForgotPasswordScreen(
          viewModel: ForgotPasswordViewModel(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.confirmPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final email = extra['email'] as String;
          final otp = extra['otp'] as String;

          return ConfirmPasswordScreen(
            viewModel: ConfirmPasswordViewModel(
              authRepository: context.read<AuthRepository>(),
            ),
            email: email,
            otp: otp,
          );
        },
      ),

      GoRoute(
        path: Routes.tourHome,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => TourHomeViewModel(tourService: context.read()),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => TourHomeViewModel(tourService: context.read()),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.tourList,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => TourListViewModel(tourService: context.read()),
          child: const TourListScreen(),
        ),
      ),
      GoRoute(
        path: Routes.tourDetail,
        builder: (context, state) {
          final tourId = state.pathParameters['id'];
          return ChangeNotifierProvider(
            create: (context) =>
                TourDetailViewModel(tourService: context.read()),
            child: TourDetailScreen(tourId: tourId),
          );
        },
      ),
      GoRoute(
        path: Routes.tourBooking,
        builder: (context, state) =>
            const AuthGuard(child: TourBookingScreen()),
      ),
      GoRoute(
        path: Routes.tourBookingReview,
        builder: (context, state) => const BookingReviewScreen(),
      ),
      GoRoute(
        path: Routes.vnpayPayment,
        builder: (context, state) {
          final bookingData = state.extra as TourBookingData?;
          return ChangeNotifierProvider(
            create: (ctx) {
              final vm = PaymentViewModel(tourService: ctx.read());
              if (bookingData != null) {
                vm.initPayment(bookingData);
              }
              return vm;
            },
            child: VNPayPaymentScreen(bookingData: bookingData),
          );
        },
      ),
      GoRoute(
        path: Routes.paymentResult,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          TourBookingData? bookingData;
          if (extra != null && extra['bookingData'] != null) {
            bookingData = extra['bookingData'] as TourBookingData;
          }

          // Đọc query parameters từ deep link (redirect) hoặc từ extra (manual navigation)
          final txnRef =
              state.uri.queryParameters['txnRef'] ??
              extra?['txnRef'] as String?;
          final status =
              state.uri.queryParameters['status'] ??
              extra?['status'] as String?;
          final responseCode =
              state.uri.queryParameters['responseCode'] ??
              extra?['responseCode'] as String?;

          return PaymentResultScreen(
            txnRef: txnRef,
            status: status,
            responseCode: responseCode,
            bookingData: bookingData,
          );
        },
      ),
      GoRoute(
        path: Routes.bookingSuccess,
        builder: (context, state) => const BookingSuccessScreen(),
      ),
      GoRoute(
        path: Routes.bookingDetail,
        builder: (context, state) {
          final bookingId = state.pathParameters['id'] ?? '';
          return BookingDetailScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: Routes.cancelConfirmation,
        builder: (context, state) {
          final bookingId = state.pathParameters['id'] ?? '';
          return CancelConfirmationScreen(
            bookingId: bookingId,
            viewModel: CancelConfirmationViewModel(tourService: context.read()),
          );
        },
      ),
      GoRoute(
        path: Routes.cancellationSuccess,
        builder: (context, state) {
          final bookingId = state.pathParameters['id'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          CancelBookingData? cancelData;
          if (extra != null && extra['cancelData'] != null) {
            cancelData = extra['cancelData'] as CancelBookingData;
          }
          return CancellationSuccessScreen(
            bookingId: bookingId,
            cancelData: cancelData,
          );
        },
      ),

      // --- COORDINATOR ROUTES ---
      GoRoute(
        path: Routes.coordinatorMain,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => CoordinatorTourListViewModel(
            coordinatorRepository: context.read<CoordinatorRepository>(),
          ),
          child: const CoordinatorMainScreen(),
        ),
      ),
      GoRoute(
        path: Routes.coordinatorHome,
        builder: (context, state) => CoordinatorTourListScreen(
          viewModel: CoordinatorTourListViewModel(
            coordinatorRepository: context.read<CoordinatorRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.coordinatorTourDetail,
        builder: (context, state) {
          final tour = state.extra as CoordinatorTour;
          return CoordinatorViewTourScreen(tour: tour);
        },
      ),
      GoRoute(
        path: Routes.coordinatorTourTemplateList,
        builder: (context, state) => CoordinatorViewTourTemplateListScreen(
          viewModel: CoordinatorTourTemplateListViewModel(
            coordinatorRepository: context.read<CoordinatorRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.coordinatorCreateTourTemplate,
        builder: (context, state) =>
            const CoordinatorCreateTourTemplateScreen(),
      ),
      GoRoute(
        path: Routes.coordinatorCreateTour,
        builder: (context, state) {
          final template = state.extra as CoordinatorTourTemplate?;
          return CoordinatorCreateTourScreen(
            viewModel: context.read<CoordinatorCreateTourViewModel>(),
            tourId: template?.id ?? '',
            tourName: template?.name,
          );
        },
      ),
      GoRoute(
        path: Routes.coordinatorViewTemplate,
        builder: (context, state) {
          final template = state.extra as CoordinatorTourTemplate;
          return CoordinatorViewTemplateScreen(template: template);
        },
      ),

      // --- GUIDE ROUTES ---
      GoRoute(
        path: Routes.guideHome,
        builder: (context, state) => const GuideHomeScreen(),
      ),
      GoRoute(
        path: Routes.missionDetail,
        builder: (context, state) {
          final missionId = state.pathParameters['id'] ?? '';
          return MissionDetailScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: Routes.checkIn,
        builder: (context, state) {
          final missionId = state.pathParameters['id'] ?? '';
          return CheckInScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: Routes.tourProgress,
        builder: (context, state) {
          final missionId = state.pathParameters['id'] ?? '';
          return TourProgressScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: Routes.tourCompleted,
        builder: (context, state) {
          final missionId = state.pathParameters['id'] ?? '';
          return TourCompletedScreen(missionId: missionId);
        },
      ),

      // --- USER ROUTES ---

      // --- ADMIN ROUTES ---
      GoRoute(
        path: Routes.adminMain,
        builder: (context, state) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => DashboardViewModel(
                adminRepository: context.read<AdminRepository>(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => AccountManagementViewModel(
                adminRepository: context.read<AdminRepository>(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => CreateAccountViewModel(
                adminRepository: context.read<AdminRepository>(),
              ),
            ),
          ],
          child: const AdminMainScreen(),
        ),
      ),
      GoRoute(
        path: Routes.adminDashboard,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => DashboardViewModel(
            adminRepository: context.read<AdminRepository>(),
          ),
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: Routes.adminCreateAccount,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => CreateAccountViewModel(
            adminRepository: context.read<AdminRepository>(),
          ),
          child: const CreateAccountScreen(),
        ),
      ),
      GoRoute(
        path: Routes.adminCreateHotel,
        builder: (context, state) => CreateHotelScreen(),
      ),
      GoRoute(
        path: Routes.adminHotelManagement,
        builder: (context, state) => HotelManagementScreen(),
      ),
      GoRoute(
        path: Routes.adminCreateHotel,
        builder: (context, state) => CreateHotelScreen(),
      ),
      GoRoute(
        path: Routes.adminCreateVehicle,
        builder: (context, state) => CreateVehicleScreen(),
      ),
      GoRoute(
        path: Routes.adminAccountManagement,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => AccountManagementViewModel(
            adminRepository: context.read<AdminRepository>(),
          ),
          child: const AccountManagementScreen(),
        ),
      ),
      GoRoute(
        path: Routes.adminViewDetailAccountWithId(':id'),
        builder: (context, state) {
          final accountId = state.pathParameters['id']!;
          final viewModel = ViewDetailAccountViewModel(
            adminRepository: context.read<AdminRepository>(),
          );
          return ViewDetailAccountScreen(
            viewModel: viewModel,
            accountId: accountId,
          );
        },
      ),
      GoRoute(
        path: Routes.adminCreateHotel,
        builder: (context, state) => CreateHotelScreen(),
      ),
      // GoRoute(
      //   path: Routes.adminUpdateHotelWithId(':id'),
      //   builder: (context, state) {
      //     final hotelId = state.pathParameters['id']!;
      //     final viewModel = UpdateHotelViewModel(
      //       adminRepository: context.read<AdminRepository>(),
      //     );
      //     return UpdateHotelScreen(viewModel: viewModel, hotelId: hotelId);
      //   },
      // ),
      GoRoute(
        path: Routes.adminVehicleManagement,
        builder: (context, state) => const VehicleManagementScreen(),
      ),
      GoRoute(
        path: Routes.adminCreateVehicle,
        builder: (context, state) => CreateVehicleScreen(),
      ),
      // GoRoute(
      //   path: Routes.adminUpdateVehicleWithId(':id'),
      //   builder: (context, state) {
      //     final vehicleId = state.pathParameters['id']!;
      //     final viewModel = UpdateVehicleViewModel(
      //       adminRepository: context.read<AdminRepository>(),
      //     );
      //     return UpdateVehicleScreen(
      //       viewModel: viewModel,
      //       vehicleId: vehicleId,
      //     );
      //   },
      // ),
      GoRoute(
        path: Routes.adminTourManagement,
        builder: (context, state) => const TourManagementScreen(),
      ),
      GoRoute(
        path: Routes.adminVehicleManagement,
        builder: (context, state) => const VehicleManagementScreen(),
      ),
    ],
  );
}
