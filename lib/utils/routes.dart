import 'package:flutter/material.dart';
import 'package:mystory_flutter/screens/create_journal_story_screen.dart';
import 'package:mystory_flutter/screens/edit_permission_screen.dart';
import 'package:mystory_flutter/screens/family_member_manual_profile_screen.dart';
import 'package:mystory_flutter/screens/family_member_tree_screen.dart';
import 'package:mystory_flutter/screens/notification_screen.dart';
import 'package:mystory_flutter/screens/familymember_storybook_screen.dart';
import 'package:mystory_flutter/screens/linkStories_familyMember_screen.dart';
import 'package:mystory_flutter/screens/linkStories_myprofile_screen.dart';
import 'package:mystory_flutter/screens/post_comments_screen.dart';
import 'package:mystory_flutter/screens/search_screen_new.dart';
import 'package:mystory_flutter/widgets/gallery_widget.dart';
import 'package:mystory_flutter/widgets/main_drawer_widget.dart';
import 'package:mystory_flutter/widgets/news_feed_widget_dynamic.dart';

import '../screens/Categories_seacrh.dart';
import '../screens/categories_list_screen.dart';
import '../screens/settings_screen.dart';

import '../screens/create_profile_screen.dart';

import '../screens/my_journal_screen.dart';
import '../screens/home_screen.dart';
import '../widgets/video-player.dart';
import '../screens/media_gallery.dart';
import '../screens/create_story_screen.dart';
import '../screens/my_family_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/invite_member_screen.dart';
import '../screens/reset_screen.dart';
import '../screens/forget_password_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/maindeshboard_screen.dart';
import '../screens/search_storybook_screen.dart';
import '../screens/myprofile_screen.dart';
import '../screens/family_member_profile_screen.dart';
import '../screens/comment.dart';
import '../screens/add_familymember_screen.dart';
import '../screens/storybook_screen.dart';
import '../screens/profilelist_screen.dart';
import '../screens/link_storybook.dart';
import '../screens/newss_feed_no_data_screen.dart';
import '../screens/changerelation_request_screen.dart';
import '../screens/email_verification_screen.dart';
import '../screens/resent_password_successfully.dart';
import '../screens/add_family_member_manually_screen.dart';
import 'package:mystory_flutter/screens/invite_member_notification_screen.dart';

// import '../screens/match_screen.dart';
// import '../screens/create_campaign_screen.dart';

const SplashScreenRoute = '/splash-screen';
const LoginScreenRoute = '/login-screen';
const SignUpScreenRoute = '/signup-screen';
const ForgetPasswordScreenRoute = '/forgetPassword-Screen';
const ResetPasswordScreenRoute = '/reset-password-screen';
const NotificationScreenRoute = '/notification-screen';
const CategoriesListScreenRoute = '/categories-list-screen';
const CategorySeacrhScreenRoute = '/categories-seacrh-screen';
const MaindeshboardRoute = '/maindeshboard-screen';
const DynamicLinkStoryRoute = '/dynamicStory-screen';
const NotificationTabRoute = '/notification-screen ';
const SearchStoryBookScreenRoute = '/search-Storybook-screen';
const MyProfileScreenRoute = '/myprofile-screen';
const CreateStoryScreenRoute = '/create-story-screen';
const CreateJournalStoryScreenRoute = '/create-journal-story-screen';
const MediaGalleryScreenRoute = '/media-galleryscreen';
const VideoplayerRoute = '/video-player';
const HomeScreenRoute = '/home-screen';
const MessagesScreenRoute = '/chat-screen';
const MyFamilyScreenRoute = '/my-family-screen';
const FamilyMemberProfileScreenRoute = '/family-member-profile-screen';
//routes by chetu
const FamilyMemberManualProfileScreenRoute = '/family-member-manual-profile-screen';
const InviteMemberNotificationScreenRoute = '/invite_member_notification_screen';
//const FamilyMemberTreeProfileRoutes = '/family-member-tree-profile';
const ChatMessageScreenRoute = '/chatmessage-screen';
const CreaterofileScreenRoute = '/createprofile-screen';
const AddFamilyMemberScreenRoute = '/ add-familymember-screen';
const StoryBookscreenRoute = '/storybook-screen';
const CommentsScreenRoute = '/comment';
const InviteMemberScreenRoute = '/invite-member-screen';
const TravelWidgetRoute = '/travel-widget';
const MyJournalScreenRoute = '/myjournal-screen';
const SearchScreenRoute = '/search -screen';
const ProfileListScreenRoute = '/proffilelist-screen';
const FamilyTreeListRoute = '/familytree-screen';
// const LinkStoryBookRoute = '/link-storybook-screen';
const NotificationsScreenRoute = '/notifications-screen';
const NewsFeedNoDataScreenRoute = '/newsfeed-no-data-screen';
const NewsFeedScreenRoute = '/newsfeed-screen';
const ChanngeRelationScreenRoute = '/change-relation-screen';
const MaindashboardSearchRoute = '/maindeshboard-search-screen';
const MaindashboardFamilyTreehRoute = '/maindeshboard-family--tree-screen';
const EmailVerificationScreenRoute = '/emailverification-screen';
const settingScreenRoute = '/setting-Screen';
const ResetPasswordSuccessfullyScreenRoute =
    '/resetpasswordsuccessfully-screen';
const PostCommentsScreenRoute = '/post-comments-screen-screen';
const GalleryWidgetRoute = '/gallery-widget-route';
const DrawerWidgetRoute = '/drawer-widget-route';
const FamilyTreeMemberRoute = '/familtTreeMember-route';

TextEditingController controller = TextEditingController();
const MyProfileLinkedStoryBookScreenRoute = '/myprofile-linked-story-route';

const FamilyMemberLinkedStoryBookScreenRoute =
    '/familymember-linked-story-route';
const FamilyMemberStoryBookScreenRoute = '/familymember-story-book-route';

const AddFamilyMemberManuallyScreenRoute = '/add-family-member-manually-screen';
const EditPermissionScreenRoute = '/edit-permission-screen';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case FamilyTreeMemberRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => FamilyMemberTreeScreen());
    case SplashScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen());

    case FamilyTreeMemberRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => FamilyMemberTreeScreen());

    case DrawerWidgetRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDrawerWidget());

    case FamilyMemberStoryBookScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => FamilyMemberStoryBookScreen());

    case FamilyMemberLinkedStoryBookScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) =>
              FamilyMemberLinkedStoryBookScreen());
    case MyProfileLinkedStoryBookScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MyProfileLinkedStoryBookScreen());
    case PostCommentsScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => PostCommentsScreen());

    case settingScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SettingScreen());

    case LoginScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => LogInScreen());

    case ForgetPasswordScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ForgetPasswordScreen());

    case SignUpScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SignUpScreen());

    case ResetPasswordScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ResetPasswordScreen());
    case CreateStoryScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CreateStoryScreen());
    case CreateJournalStoryScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CreateJournalStoryScreen());

    case MediaGalleryScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MediaGalleryScreen());

    case VideoplayerRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => GalleryVideoplayerWidget());

    case GalleryWidgetRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => GalleryWidget());
    case HomeScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());

    case MaindeshboardRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDashboardScreen(0));

    case DynamicLinkStoryRoute:
      return MaterialPageRoute(builder: (BuildContext context)=> NewsFeedWidgetDynamic(postID: "",postCreatorID: ""));

    case MaindashboardSearchRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDashboardScreen(1));

    case MaindashboardFamilyTreehRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDashboardScreen(3));
    case NotificationTabRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDashboardScreen(4));

    case SearchStoryBookScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SearchStoryBookScreen());

    case MyProfileScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MyProfileScreen());
    case MessagesScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MessagesScreen());

    case MyFamilyScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MyFamilyScreen());

    case FamilyMemberProfileScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => FamilyMemberProfileScreen());

      // route by chetu
 // case FamilyMemberManualProfileScreenRoute:
 //      return MaterialPageRoute(
 //          builder: (BuildContext context) => FamilyMemberManualProfileScreen(userData: {},));

    case CommentsScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CommentsScreen());
    // case NotificationScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (BuildContext context) => NotificationScreen());

    case CategoriesListScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CategoriesListScreen(
              // heightController: controller,
              ));

    case CategorySeacrhScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CategorySeacrhScreen());
    case InviteMemberScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => InviteMemberScreen());

    //by chetu
    case InviteMemberNotificationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => InviteMemberNotificationScreen());  

    // case NewsFeedScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (BuildContext context) => NewsFeedScreen());

    case MyJournalScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MyJournalScreen());

    case CreaterofileScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CreateProfile());

    case SearchScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SearchScreen());

    case AddFamilyMemberScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => AddFamilyMemberScreen());

    case StoryBookscreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => StoryBookscreen());

    case ProfileListScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ProfileListScreen());

    case FamilyTreeListRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDashboardScreen(3));

    case NotificationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDashboardScreen(4));

    // case LinkStoryBookRoute:
    //   return MaterialPageRoute(
    //       builder: (BuildContext context) => LinkStoryBook());

    case NewsFeedNoDataScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => NewsFeedNoDataScreen());

    case ChanngeRelationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ChanngeRelationScreen(settings: settings,));

    case EmailVerificationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => EmailVerificationScreen());

    case ResetPasswordSuccessfullyScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ResetPasswordSuccessfullyScreen());

    case AddFamilyMemberManuallyScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => AddFamilyMemberManuallyScreen());

    case EditPermissionScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context)=> EditPermissionScreen());

    default:
      return MaterialPageRoute(
          builder: (BuildContext context) => LogInScreen());
  }
}
