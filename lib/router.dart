import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/listing_detail_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/post_listing_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/listing/:id',
      builder: (_, state) => ListingDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(path: '/saved', builder: (_, __) => const SavedScreen()),
    GoRoute(path: '/post', builder: (_, __) => const PostListingScreen()),
  ],
);
