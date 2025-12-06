import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_screens.dart';
import '../features/home/home_screen.dart';
import '../features/booking/booking_date_screen.dart';
import '../features/booking/booking_traveler_list_screen.dart';
import '../features/booking/booking_traveler_detail_screen.dart';
import '../features/booking/booking_details_form_screen.dart';
import '../features/booking/booking_review_screen.dart';
import '../features/booking/booking_success_screen.dart';
import '../features/booking/booking_timeline_screen.dart';
import '../features/booking/booking_pickup_otp_screen.dart';
import '../features/booking/booking_delivery_otp_screen.dart';
import '../features/booking/booking_under_review_screen.dart';
import '../features/trips/trip_detail_screen.dart';
import '../features/trips/trip_flight_screen.dart';
import '../features/trips/trip_capacity_screen.dart';
import '../features/trips/trip_summary_screen.dart';
import '../features/trips/trip_manage_screen.dart';
import '../features/trips/trip_edit_screen.dart';
import '../features/trips/trip_success_screen.dart';
import '../features/trips/trip_under_review_screen.dart';
import '../features/marketplace/marketplace_list_screen.dart';
import '../features/marketplace/marketplace_detail_screen.dart';
import '../features/marketplace/marketplace_create_screen.dart';
import '../features/marketplace/marketplace_review_screen.dart';
import '../features/marketplace/marketplace_success_screen.dart';
import '../features/marketplace/marketplace_offer_thread_screen.dart';
import '../features/marketplace/marketplace_meetup_screens.dart';
import '../features/marketplace/marketplace_mark_sold_screen.dart';
import '../features/chat/chat_screens.dart';
import '../features/audit/audit_screens.dart';
import '../features/profile/profile_screens.dart';
import '../features/ai/ai_chat_screen.dart';
import '../features/common/shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth/login',
    routes: [
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/auth/forgot',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'book/dates',
                builder: (context, state) => const BookingDateScreen(),
              ),
              GoRoute(
                path: 'book/travelers',
                builder: (context, state) => const TravelerListScreen(),
              ),
              GoRoute(
                path: 'book/traveler/:id',
                builder: (context, state) =>
                    TravelerDetailScreen(id: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                path: 'book/details',
                builder: (context, state) => const BookingDetailsFormScreen(),
              ),
              GoRoute(
                path: 'book/review',
                builder: (context, state) => const BookingReviewScreen(),
              ),
              GoRoute(
                path: 'book/review/under-review',
                builder: (context, state) => const BookingUnderReviewScreen(),
              ),
              GoRoute(
                path: 'book/success',
                builder: (context, state) => const BookingSuccessScreen(),
              ),
              GoRoute(
                path: 'booking/:id/timeline',
                builder: (context, state) =>
                    BookingTimelineScreen(id: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                path: 'booking/:id/pickup-otp',
                builder: (context, state) =>
                    PickupOtpScreen(id: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                path: 'booking/:id/delivery-otp',
                builder: (context, state) =>
                    DeliveryOtpScreen(id: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                path: 'trip/new/flight',
                builder: (context, state) => const TripFlightScreen(),
              ),
              GoRoute(
                path: 'trip/new/capacity',
                builder: (context, state) => const TripCapacityScreen(),
              ),
              GoRoute(
                path: 'trip/new/summary',
                builder: (context, state) => const TripSummaryScreen(),
              ),
              GoRoute(
                path: 'trip/new/success',
                builder: (context, state) => const TripSuccessScreen(),
              ),
              GoRoute(
                path: 'trip/new/under-review',
                builder: (context, state) => const TripUnderReviewScreen(),
              ),
              GoRoute(
                path: 'trip/manage',
                builder: (context, state) => const TripManageScreen(),
              ),
              GoRoute(
                path: 'trip/:id/edit',
                builder: (context, state) => TripEditScreen(
                  id: state.pathParameters['id'] ?? '',
                  trip: state.extra as Map<String, dynamic>?,
                ),
              ),
              GoRoute(
                path: 'trip/:id',
                builder: (context, state) =>
                    TripDetailScreen(id: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                path: 'market',
                builder: (context, state) => const MarketplaceListScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const ListingCreateScreen(),
                  ),
                  GoRoute(
                    path: 'new/review',
                    builder: (context, state) => const ListingReviewScreen(),
                  ),
                  GoRoute(
                    path: 'new/success',
                    builder: (context, state) => const ListingSuccessScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ListingDetailScreen(
                        id: state.pathParameters['id'] ?? ''),
                  ),
                  GoRoute(
                    path: ':id/offer-thread',
                    builder: (context, state) => OfferThreadScreen(
                        listingId: state.pathParameters['id'] ?? ''),
                  ),
                  GoRoute(
                    path: ':id/meetup',
                    builder: (context, state) => MeetupCreateScreen(
                        id: state.pathParameters['id'] ?? ''),
                  ),
                  GoRoute(
                    path: ':id/meetup/otp',
                    builder: (context, state) =>
                        MeetupOtpScreen(id: state.pathParameters['id'] ?? ''),
                  ),
                  GoRoute(
                    path: ':id/mark-sold',
                    builder: (context, state) =>
                        MarkSoldScreen(id: state.pathParameters['id'] ?? ''),
                  ),
                ],
              ),
              GoRoute(
                path: 'chat',
                builder: (context, state) => const ChatListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) =>
                        ChatThreadScreen(id: state.pathParameters['id'] ?? ''),
                  ),
                ],
              ),
              GoRoute(
                path: 'audit',
                builder: (context, state) => const AuditCenterScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) =>
                        IssueDetailScreen(id: state.pathParameters['id'] ?? ''),
                  ),
                  GoRoute(
                    path: 'report/new',
                    builder: (context, state) => const ReportIssueScreen(),
                  ),
                  GoRoute(
                    path: ':id/add-evidence',
                    builder: (context, state) =>
                        AddEvidenceScreen(id: state.pathParameters['id'] ?? ''),
                  ),
                ],
              ),
              GoRoute(
                path: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'kyc',
                    builder: (context, state) => const KycScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'logout',
                    builder: (context, state) => const LogoutScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'ai',
                builder: (context, state) => const AiChatScreen(),
              ),
              GoRoute(
                path: 'admin/audit',
                builder: (context, state) => const AdminAuditPanelScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // Simple mock auth gate: if logged in flag missing, allow all (demo).
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route error: ${state.error}')),
    ),
  );
});
