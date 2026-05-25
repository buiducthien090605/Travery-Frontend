import 'package:flutter/foundation.dart';
import 'package:travery_frontend/data/models/tour/tour_detail_page_data.dart';
import 'package:travery_frontend/data/seed_models/tour_instance/tour_instance.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_request/create_tour_booking_request.dart';
import 'package:travery_frontend/data/services/api/model/booking/create_tour_booking_response/create_tour_booking_response.dart';
import 'package:travery_frontend/data/services/tour/tour_service.dart';
import 'package:travery_frontend/utils/core_result.dart';

class BookingInfo {
  final String fullName;
  final String phone;
  final String? specialNotes;

  const BookingInfo({
    required this.fullName,
    required this.phone,
    this.specialNotes,
  });
}

enum MemberType { adult, child }

class MemberInfo {
  final int index;
  final String fullName;
  final String identityNumber;
  final DateTime? dateOfBirth;
  final MemberType type;

  const MemberInfo({
    required this.index,
    required this.fullName,
    required this.identityNumber,
    this.dateOfBirth,
    required this.type,
  });

  MemberInfo copyWith({
    int? index,
    String? fullName,
    String? identityNumber,
    DateTime? dateOfBirth,
    MemberType? type,
  }) {
    return MemberInfo(
      index: index ?? this.index,
      fullName: fullName ?? this.fullName,
      identityNumber: identityNumber ?? this.identityNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      type: type ?? this.type,
    );
  }

  String get apiMemberType => type == MemberType.adult ? 'ADULT' : 'CHILD';
}

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({required TourService tourService})
    : _tourService = tourService;

  final TourService _tourService;

  TourDetailPageData? _tour;
  TourDetailPageData? get tour => _tour;

  TourInstance? _selectedInstance;
  TourInstance? get selectedInstance => _selectedInstance;

  int _adultCount = 1;
  int get adultCount => _adultCount;

  int _childCount = 0;
  int get childCount => _childCount;

  String _contactName = '';
  String get contactName => _contactName;

  String _contactPhone = '';
  String get contactPhone => _contactPhone;

  String _specialNotes = '';
  String get specialNotes => _specialNotes;

  List<MemberInfo> _members = [];
  List<MemberInfo> get members => _members;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _tourId;
  String? get tourId => _tourId;

  TourBookingData? _bookingResult;
  TourBookingData? get bookingResult => _bookingResult;

  void setTourData({
    required TourDetailPageData tour,
    TourInstance? selectedInstance,
  }) {
    _tour = tour;
    _selectedInstance = selectedInstance;
    _tourId = tour.id;
    _updateMembers();
    notifyListeners();
  }

  void _updateMembers() {
    final List<MemberInfo> newMembers = [];

    for (int i = 0; i < _adultCount; i++) {
      if (i < _members.length && _members[i].type == MemberType.adult) {
        newMembers.add(_members[i]);
      } else {
        newMembers.add(
          MemberInfo(
            index: i,
            fullName: '',
            identityNumber: '',
            type: MemberType.adult,
          ),
        );
      }
    }

    for (int i = 0; i < _childCount; i++) {
      final memberIndex = _adultCount + i;
      if (memberIndex < _members.length &&
          _members[memberIndex].type == MemberType.child) {
        newMembers.add(_members[memberIndex]);
      } else {
        newMembers.add(
          MemberInfo(
            index: memberIndex,
            fullName: '',
            identityNumber: '',
            type: MemberType.child,
          ),
        );
      }
    }

    _members = newMembers;
  }

  void setAdultCount(int count) {
    if (count >= 1 && count <= 20) {
      _adultCount = count;
      _updateMembers();
      notifyListeners();
    }
  }

  void setChildCount(int count) {
    if (count >= 0 && count <= 10) {
      _childCount = count;
      _updateMembers();
      notifyListeners();
    }
  }

  void setContactName(String name) {
    _contactName = name;
    notifyListeners();
  }

  void setContactPhone(String phone) {
    _contactPhone = phone;
    notifyListeners();
  }

  void setSpecialNotes(String notes) {
    _specialNotes = notes;
    notifyListeners();
  }

  void updateMember(
    int index, {
    String? fullName,
    String? identityNumber,
    DateTime? dateOfBirth,
  }) {
    if (index >= 0 && index < _members.length) {
      _members[index] = _members[index].copyWith(
        fullName: fullName,
        identityNumber: identityNumber,
        dateOfBirth: dateOfBirth,
      );
      notifyListeners();
    }
  }

  double get totalPrice {
    if (_tour == null) return 0;
    final adultPrice = _tour!.pricePerAdult * _adultCount;
    final childPrice = _tour!.pricePerChild * _childCount;
    return adultPrice + childPrice;
  }

  int get totalMembers => _adultCount + _childCount;

  String? validateContactName() {
    if (_contactName.isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    if (_contactName.trim().length < 2) {
      return 'Họ và tên phải có ít nhất 2 ký tự';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(_contactName.trim())) {
      return 'Họ và tên không được chứa số hoặc ký tự đặc biệt';
    }
    return null;
  }

  String? validateContactPhone() {
    if (_contactPhone.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final phoneRegex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
    if (!phoneRegex.hasMatch(_contactPhone.replaceAll(' ', ''))) {
      return 'Số điện thoại không hợp lệ (VD: 0901234567)';
    }
    return null;
  }

  String? validateMemberName(String name) {
    if (name.isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    if (name.trim().length < 2) {
      return 'Họ và tên phải có ít nhất 2 ký tự';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(name.trim())) {
      return 'Họ và tên không được chứa số hoặc ký tự đặc biệt';
    }
    return null;
  }

  String? validateIdentityNumber(String number) {
    if (number.isEmpty) {
      return 'Vui lòng nhập CCCD/CMND';
    }
    final cleanNumber = number.replaceAll(' ', '');
    if (cleanNumber.length != 9 && cleanNumber.length != 12) {
      return 'CCCD phải có 9 hoặc 12 số';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return 'CCCD chỉ được chứa số';
    }
    return null;
  }

  /// Validate child age - must be under 10 years old
  /// Returns error message if invalid, null if valid
  String? validateChildAge(DateTime? dateOfBirth, int memberIndex) {
    final member = memberIndex < _members.length ? _members[memberIndex] : null;
    if (member == null || member.type != MemberType.child) {
      return null; // Not a child, no age validation needed
    }

    if (dateOfBirth == null) {
      return 'Trẻ em phải có ngày sinh và tuổi phải dưới 10';
    }

    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    if (age >= 10) {
      return 'Trẻ em phải dưới 10 tuổi (hiện tại: $age tuổi)';
    }

    return null;
  }

  bool validateAll() {
    for (final member in _members) {
      if (member.fullName.isEmpty || member.identityNumber.isEmpty) {
        return false;
      }
    }

    return true;
  }

  List<String> getAllErrors() {
    final errors = <String>[];

    for (int i = 0; i < _members.length; i++) {
      final member = _members[i];
      if (member.fullName.isEmpty) {
        errors.add('Thành viên ${i + 1}: Vui lòng nhập họ và tên');
      }
      if (member.identityNumber.isEmpty) {
        errors.add('Thành viên ${i + 1}: Vui lòng nhập CCCD/CMND');
      }

      // Validate child age for children
      final childAgeError = validateChildAge(member.dateOfBirth, i);
      if (childAgeError != null) {
        errors.add('Thành viên ${i + 1}: $childAgeError');
      }
    }

    return errors;
  }

  Future<void> createBooking() async {
    if (!validateAll()) {
      _errorMessage = 'Vui lòng điền đầy đủ thông tin';
      notifyListeners();
      return;
    }

    final instance = _selectedInstance;
    if (instance == null || instance.id == null) {
      _errorMessage = 'Không tìm thấy thông tin tour';
      notifyListeners();
      return;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    final memberRequests = _members.map((m) {
      return BookingMemberRequest(
        fullName: m.fullName,
        identityNumber: m.identityNumber,
        dateOfBirth: m.dateOfBirth != null
            ? '${m.dateOfBirth!.year}-${m.dateOfBirth!.month.toString().padLeft(2, '0')}-${m.dateOfBirth!.day.toString().padLeft(2, '0')}'
            : '',
        memberType: m.apiMemberType,
      );
    }).toList();

    final request = CreateTourBookingRequest(
      members: memberRequests,
      specialRequests: _specialNotes,
    );

    final result = await _tourService.createTourBooking(
      instanceId: instance.id!,
      request: request,
    );

    switch (result) {
      case Ok<TourBookingData>():
        _bookingResult = result.value;
      case Error<TourBookingData>():
        _errorMessage = result.error.toString();
    }

    _isSubmitting = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _adultCount = 1;
    _childCount = 0;
    _contactName = '';
    _contactPhone = '';
    _specialNotes = '';
    _members = [];
    _errorMessage = null;
    _isSubmitting = false;
    _bookingResult = null;
    _updateMembers();
    notifyListeners();
  }
}
