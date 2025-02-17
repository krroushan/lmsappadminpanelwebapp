// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../pages/classes_page/edit_class_view.dart';
import '../pages/exams/add_question_view.dart';
import '../pages/exams/question_list_view.dart';
import '../pages/pages.dart';
import '../pages/classes_page/classes_list_view.dart';
import '../pages/classes_page/add_class_view.dart';
import '../pages/students/edit_student_view.dart';
import '../pages/students/add_student_view.dart';
import '../pages/subjects/edit_subject_view.dart';
import '../pages/teachers/teacher_list_view.dart';
import '../pages/teachers/add_teacher_view.dart';
import '../pages/teachers/edit_teacher_view.dart'; 
import '../pages/students/student_list_view.dart';
import '../providers/providers.dart';
import 'package:provider/provider.dart';
import '../pages/admins/admin_list_view.dart';
import '../pages/admins/add_admin_view.dart';
import '../pages/admins/edit_admin_view.dart';
import '../pages/my_dashboard/dashboard_view.dart';
import '../pages/subjects/subject_list_view.dart';
import '../pages/subjects/add_subject_view.dart';
import '../pages/lectures/add_lecture_view.dart';
import '../pages/study_material/study_material_list.dart';
import '../pages/study_material/add_study_material.dart';
import '../pages/lectures/publishLiveStream.dart';
import '../pages/lectures/view_lecture_view.dart';
import '../pages/lectures/lecture_video_player2.dart';
import '../pages/study_material/sm_pdf_viewer.dart';
import '../pages/exams/add_exam_view.dart';
import '../pages/exams/exam_list_view.dart';
import '../pages/boards/add_board_view.dart';
import '../pages/boards/board_list_view.dart';
import '../pages/students/view_student_view.dart';
import '../pages/lectures/lecture_card_list_view.dart';
import '../pages/syllabus/syllabus_list_view.dart';
import '../pages/syllabus/add_syllabus_view.dart';
import '../pages/syllabus/edit_syllabus_view.dart';
import '../pages/syllabus/view_pdf_syllabus_view.dart';
import '../pages/schedule/view_schedule_view.dart';
import '../pages/schedule/add_schedule_view.dart';
import '../pages/schedule/schedules_list_view.dart';
import '../pages/study_material/update_study_material.dart';
import '../pages/settings/admin_setting_view.dart';
import '../pages/settings/app_setting_view.dart';
import '../pages/settings/page_setting_view.dart';
import '../pages/lectures/edit_lecture_view.dart';
import '../pages/schedule/edit_schedule_view.dart';
abstract class AcnooAppRoutes {
  //--------------Navigator Keys--------------//
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _emailShellNavigatorKey = GlobalKey<NavigatorState>();
  //--------------Navigator Keys--------------//

  static const _initialPath = '/';
  static final routerConfig = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: _initialPath,
    redirect: (context, state) async {
      final authProvider = context.read<AuthProvider>();
      await authProvider.checkAuthentication();
      final isAuthenticated = authProvider.isAuthenticated;
      final userRole = authProvider.getRole;

      //If the user is not authenticated, redirect to login
      if (!isAuthenticated && state.fullPath != '/') {
        return '/';
      }

      // If the user is authenticated and tries to access '/login', redirect to the default route
      if (isAuthenticated && state.fullPath == '/') {
        return '/dashboard';
      }

      // Role-based route restrictions
      if (isAuthenticated) {
        final path = state.fullPath ?? '';

        // Teacher restrictions
        if (userRole == 'teacher') {
          if (path.contains('/dashboard/admins') ||
              path.contains('/dashboard/teachers/add-teacher')) {
            return '/dashboard';
          }
        }
      }

      // No redirect if conditions are not met
      return null;
    },
    routes: [
      //Landing Route Handler
      // GoRoute(
      //   path: _initialPath,
      //   redirect: (context, state) async {
      //     return '/dashboard/ecommerce-admin';
      //   },
      // ),

      //how to check if the user is logged in or not

      // Login Route
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SigninView(),
        ),
      ),

      // GoRoute(
      //   path: '/',
      //   pageBuilder: (context, state) => NoTransitionPage(
      //     child: HomePage(),
      //   ),
      // ),

      // Global Shell Route
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: ShellRouteWrapper(child: child),
          );
        },
        routes: [

          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: DashboardView(),
            ),
          ),


GoRoute(
            path: '/dashboard/influencer-admin',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: RewardEarningAdminDashboard(),
            ),
          ),
          // GoRoute(
          //   path: '/card',
          //   pageBuilder: (context, state) => const NoTransitionPage<void>(
          //     child: ProjectsView(),
          //   ),
          // ),

          // Lectures Route
          GoRoute(
            path: '/dashboard/lectures',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/lectures') {
                return '/dashboard/lectures/all-lectures';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-lectures',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: LectureCardListView(),
                ),
              ),
              GoRoute(
                path: 'add-lecture',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddLectureView(),
                ),
              ),
              GoRoute(
                path: 'publish-live-stream/:streamId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: PublishLiveStream(streamId: state.pathParameters['streamId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'edit-lecture/:lectureId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: EditLectureView(lectureId: state.pathParameters['lectureId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'view-lecture/:lectureId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: ViewLectureView(lectureId: state.pathParameters['lectureId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'play-lecture/:lectureId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: LectureVideoPlayer2(lectureId: state.pathParameters['lectureId'] ?? ''),
                ),
              ),
            ],
          ),

// Lectures Route
          GoRoute(
            path: '/dashboard/study-materials',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/study-materials') {
                return '/dashboard/study-materials/all-study-materials';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-study-materials',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: StudyMaterialListView(),
                ),
              ),
              GoRoute(
                path: 'add-study-material',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddStudyMaterialView(),
                ),
              ),
              // GoRoute(
              //   path: 'edit-study-material',
              //   pageBuilder: (context, state) => const NoTransitionPage<void>(
              //     child: EditStudyMaterialView(),
              //   ),
              // ),
              GoRoute(
                path: 'update-study-material/:studyMaterialId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: UpdateStudyMaterialView(studyMaterialId: state.pathParameters['studyMaterialId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'view-pdf/:studyMaterialId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: SMPDFViewer(smId: state.pathParameters['studyMaterialId'] ?? ''),
                ),
              ),
            ],
          ),


          GoRoute(
            path: '/dashboard/exams',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/exams') {
                return '/dashboard/exams/all-exams';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-exams',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ExamListView(),
                ),
              ),
              GoRoute(
                path: 'add-exam',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddExamView(),
                ),
              ),
              GoRoute(
                path: 'all-questions',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: QuestionListView(),
                ),
              ),
              GoRoute(
                path: 'add-question',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddQuestionView(),
                ),
              ),
            ],
          ),


          // Students Route
          GoRoute(
            path: '/dashboard/students',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/students') {
                return '/dashboard/students/all-students';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-students',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: StudentListView(),
                ),
              ),
              GoRoute(
                path: 'add-student',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddStudentView(),
                ),
              ),
              GoRoute(
                path: 'edit-student/:studentId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: EditStudentView(studentId: state.pathParameters['studentId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'student-profile/:studentId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: ViewStudentView(studentId: state.pathParameters['studentId'] ?? ''),
                ),
              ),
            ],
          ),

          // Schedule Route
          // GoRoute(
          //   path: '/dashboard/schedule',
          //   pageBuilder: (context, state) => const NoTransitionPage<void>(
          //     child: CalendarView(),
          //   ),
          // ),

          GoRoute(
            path: '/dashboard/schedule',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/schedule') {
                return '/dashboard/schedule/all-schedule';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-schedule',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SchedulesListView(),
                ),
              ),
              GoRoute(
                path: 'add-schedule',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddScheduleView(),
                ),
              ),
              GoRoute(
                path: 'edit-schedule/:scheduleId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: EditScheduleView(scheduleId: state.pathParameters['scheduleId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'view-schedule/:scheduleId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: ViewScheduleView(scheduleId: state.pathParameters['scheduleId'] ?? ''),
                ),
              ),
            ],
          ),

          // Syllabus Route
          GoRoute(
            path: '/dashboard/syllabus',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/syllabus') {
                return '/dashboard/syllabus/all-syllabus';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-syllabus',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SyllabusListView(),
                ),
              ),
              GoRoute(
                path: 'add-syllabus',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddSyllabusView(),
                ),
              ),
              GoRoute(
                path: 'edit-syllabus/:syllabusId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: EditSyllabusView(syllabusId: state.pathParameters['syllabusId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'view-syllabus/:syllabusId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: ViewPDFSyllabus(syllabusId: state.pathParameters['syllabusId'] ?? ''),
                ),
              ),
            ],
          ),

          // Teachers Route
          GoRoute(
            path: '/dashboard/teachers',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/teachers') {
                return '/dashboard/teachers/all-teachers';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-teachers',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TeacherListView(),
                ),
              ),
              GoRoute(
                path: 'add-teacher',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddTeacherView(),
                ),
              ),
              GoRoute(
                path: 'edit-teacher/:teacherId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: EditTeacherView(teacherId: state.pathParameters['teacherId'] ?? ''),
                ),
              ),
              GoRoute(
                path: 'teacher-profile',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UserProfileView(studentId: ''),
                ),
              ),
            ],
          ),

          // Classes Route
          GoRoute(
            path: '/dashboard/classes',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/classes') {
                return '/dashboard/classes/all-classes';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-classes',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ClassesListView(),
                ),
              ),
              GoRoute(
                path: 'add-class',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddClassView(),
                ),
              ),
              // GoRoute(
              //   path: 'class-profile',
              //   pageBuilder: (context, state) => NoTransitionPage<void>(
              //     child: UserProfileView(studentId: state.extra as String),
              //   ),
              // ),
              GoRoute(
                path: 'edit-class/:classId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: EditClassView(classId: state.pathParameters['classId'] ?? ''),
                ),
              ),
            ],
          ),

// Classes Route
          GoRoute(
            path: '/dashboard/subjects',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/subjects') {
                return '/dashboard/subjects/all-subjects';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-subjects',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SubjectListView(),
                ),
              ),
              GoRoute(
                path: 'add-subject',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddSubjectView(),
                ),
              ),
              GoRoute(
                path: 'edit-subject/:subjectId',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: EditSubjectView(subjectId: state.pathParameters['subjectId'] ?? ''),
                ),
              ),
            ],
          ),

// Boards Route
          GoRoute(
            path: '/dashboard/boards',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/boards') {
                return '/dashboard/boards/all-boards';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-boards',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BoardListView(),
                ),
              ),
              GoRoute(
                path: 'add-board',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddBoardView(),
                ),
              ),
            ],
          ),


// Admins Route
          GoRoute(
            path: '/dashboard/admins',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/admins') {
                return '/dashboard/admins/all-admins';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'all-admins',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AdminListView(),
                ),
              ),
              GoRoute(
                path: 'add-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AddAdminView(),
                ),
              ),
              GoRoute(
                path: 'edit-admin',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: EditAdminView(),
                ),
              ),
              GoRoute(
                path: 'admin-profile',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UserProfileView(studentId: ''),
                ),
              ),
            ],
          ),


GoRoute(
            path: '/dashboard/settings',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard/settings') {
                return '/dashboard/settings/admin-setting';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'admin-setting',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AdminSettingView(),
                ),
              ),
              GoRoute(
                path: 'app-setting',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AppSettingView(),
                ),
              ),
              GoRoute(
                path: 'page-setting',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PageSettingView(),
                ),
              ),
            ],
          ),
          // Dashboard Routes
          // GoRoute(
          //   path: '/dashboard',
          //   redirect: (context, state) async {
          //     if (state.fullPath == '/dashboard') {
          //       return '/dashboard/ecommerce-admin';
          //     }
          //     return null;
          //   },
          //   routes: [
          //     GoRoute(
          //       path: 'ecommerce-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: ECommerceAdminDashboardView(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'open-ai-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: OpenAIDashboardView(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'erp-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: ERPAdminDashboardView(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'pos-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage(
          //         child: POSAdminDashboard(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'earning-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage<void>(
          //         child: RewardEarningAdminDashboard(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'sms-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage<void>(
          //         child: SMSAdminDashboard(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'influencer-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage<void>(
          //         child: InfluencerAdminDashboard(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'hrm-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage<void>(
          //         child: HRMAdminDashboard(),
          //       ),
          //     ),
          //     GoRoute(
          //       path: 'news-admin',
          //       pageBuilder: (context, state) => const NoTransitionPage<void>(
          //         child: NewsAdminDashboard(),
          //       ),
          //     )
          //   ],
          // ),

          // Widgets Routes
          GoRoute(
            path: '/widgets',
            redirect: (context, state) async {
              if (state.fullPath == '/widgets') {
                return '/widgets/general-widgets';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'general-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GeneralWidgetsView(),
                ),
              ),
              GoRoute(
                path: 'chart-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ChartWidgetsView(),
                ),
              ),
            ],
          ),

          //--------------Application Section--------------//
          // GoRoute(
          //   path: '/calendar',
          //   pageBuilder: (context, state) => const NoTransitionPage<void>(
          //     child: CalendarView(),
          //   ),
          // ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ChatView(),
            ),
          ),

          // Email Shell Routes
          GoRoute(
            path: '/email',
            redirect: (context, state) async {
              if (state.fullPath == '/email') {
                return '/email/inbox';
              }
              return null;
            },
            routes: [
              ShellRoute(
                navigatorKey: _emailShellNavigatorKey,
                pageBuilder: (context, state, child) {
                  return NoTransitionPage(
                    child: EmailView(child: child),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'inbox',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailInboxView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'starred',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailStarredView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'sent',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSentView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'drafts',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDraftsView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'spam',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSpamView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'trash',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailTrashView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':folder/details',
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDetailsView(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ProjectsView(),
            ),
          ),
          GoRoute(
            path: '/kanban',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: KanbanView(),
            ),
          ),

          // E-Commerce Routes
          GoRoute(
            path: '/ecommerce',
            redirect: (context, state) async {
              if (state.fullPath == '/ecommerce') {
                return '/ecommerce/product-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "product-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductListView(),
                ),
              ),
              GoRoute(
                path: "product-details",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductDetailsView(),
                ),
              ),
              GoRoute(
                path: "cart",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CartView(),
                ),
              ),
              GoRoute(
                path: "checkout",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CheckoutView(),
                ),
              ),
            ],
          ),

          // POS Inventory Routes
          GoRoute(
            path: '/pos-inventory',
            redirect: (context, state) async {
              if (state.fullPath == '/pos-inventory') {
                return '/pos-inventory/sale';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "sale",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleView(),
                ),
              ),
              GoRoute(
                path: "sale-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleListView(),
                ),
              ),
              GoRoute(
                path: "purchase",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseView(),
                ),
              ),
              GoRoute(
                path: "purchase-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseListView(),
                ),
              ),
              GoRoute(
                path: "product",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSProductView(),
                ),
              ),
            ],
          ),

          // Open AI Routes
          GoRoute(
            path: '/open-ai',
            redirect: (context, state) async {
              if (state.fullPath == '/open-ai') {
                return '/open-ai/ai-writter';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'ai-writter',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiWriterView(),
                ),
              ),
              GoRoute(
                path: 'ai-image',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiImageView(),
                ),
              ),
              StatefulShellRoute.indexedStack(
                pageBuilder: (context, state, page) {
                  AIChatPageListener.initialize(page);
                  return NoTransitionPage(
                    child: AiChatView(page: page),
                  );
                },
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'ai-chat',
                        pageBuilder: (context, state) => const NoTransitionPage(
                          child: AIChatDetailsView(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'ai-code',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiCodeView(),
                ),
              ),
              GoRoute(
                path: 'ai-voiceover',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiVoiceoverView(),
                ),
              ),
            ],
          ),

          //--------------Application Section--------------//

          //--------------Tables & Forms--------------//
          GoRoute(
            path: '/tables',
            redirect: (context, state) async {
              if (state.fullPath == '/tables') {
                return '/tables/basic-table';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'basic-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BasicTableView(),
                ),
              ),
              GoRoute(
                path: 'data-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DataTableView(),
                ),
              ),
            ],
          ),

          GoRoute(
            path: '/forms',
            redirect: (context, state) async {
              if (state.fullPath == '/forms') {
                return '/forms/basic-forms';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'basic-forms',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BasicFormsView(),
                ),
              ),
              GoRoute(
                path: 'form-select',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FormSelectView(),
                ),
              ),
              GoRoute(
                path: 'form-validation',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FormValidationView(),
                ),
              ),
            ],
          ),
          //--------------Tables & Forms--------------//

          //--------------Components--------------//
          GoRoute(
            path: '/components',
            redirect: (context, state) async {
              if (state.fullPath == '/components') {
                return '/components/buttons';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'buttons',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ButtonsView(),
                ),
              ),
              GoRoute(
                path: 'colors',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ColorsView(),
                ),
              ),
              GoRoute(
                path: 'alerts',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AlertsView(),
                ),
              ),
              GoRoute(
                path: 'typography',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TypographyView(),
                ),
              ),
              // GoRoute(
              //   path: 'cards',
              //   pageBuilder: (context, state) => const NoTransitionPage<void>(
              //     child: CardsView(),
              //   ),
              // ),
              GoRoute(
                path: 'avatars',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AvatarsView(),
                ),
              ),
              GoRoute(
                path: 'dragndrop',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DragAndDropView(),
                ),
              ),
            ],
          ),
          //--------------Components--------------//

          //--------------Pages--------------//
          GoRoute(
            path: '/pages',
            redirect: (context, state) async {
              if (state.fullPath == '/pages') {
                return '/pages/gallery';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'gallery',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GalleryView(),
                ),
              ),
              GoRoute(
                path: 'maps',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: MapsView(),
                ),
              ),
              GoRoute(
                path: 'pricing',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PricingView(),
                ),
              ),
              GoRoute(
                path: 'tabs-and-pills',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TabsNPillsView(),
                ),
              ),
              GoRoute(
                path: '404',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: NotFoundView(),
                ),
              ),
              GoRoute(
                path: 'faqs',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FaqView(),
                ),
              ),
              GoRoute(
                path: 'privacy-policy',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PrivacyPolicyView(),
                ),
              ),
              GoRoute(
                path: 'terms-conditions',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TermsConditionView(),
                ),
              ),
            ],
          ),
          //--------------Pages--------------//
        ],
      ),

      // Full Screen Pages
      // GoRoute(
      //   path: '/authentication/signup',
      //   pageBuilder: (context, state) => const NoTransitionPage(
      //     child: SignupView(),
      //   ),
      // ),
      
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundView(),
    ),
  );
}
