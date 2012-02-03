GyanV1::Application.routes.draw do

  get "task/search"

  get "course_group/home"

  get "user/search"

  get "calendar/home"

  get "group/home"

  resources :samples

  get "student/home"

  get "teacher/home"

  get "registration/teacher_new"

  get "course/show"

  get "department/new"

  get "admin/home"

  get "login/new"

  get "signup/new"

  #regsitration for a new institute
  match 'signup' => 'signup#new'
  match 'register-institute' => 'signup#register_institute' ,:via => :post

  #login routes
  match 'login' => 'login#new'
  match 'logout' => 'login#destroy'

  match 'loguser' => 'login#loguser' ,:via => :post

  #teacher routes
  match 'teacher' => 'teacher#home'
  match 'teacher/users' => 'teacher#users_index'
  match 'teacher/departments' => 'teacher#department_index'
  match 'teacher/courses' => 'teacher#course_index'

  #student routes
  match 'student' => 'student#home'
  match 'student/profile' => 'student#profile_edit'
  match 'student/profile_update' => 'student#profile_update' ,:via => :put
  match 'student/users' => 'student#users_index'
  match 'student/departments' => 'student#department_index'
  match 'student/courses' => 'student#course_index'


  #admin routes
  match 'admin' => 'admin#home'
  match 'admin/users' => 'admin#users_index'
  match 'admin/departments' => 'admin#department_index'
  match 'admin/courses' => 'admin#course_index'
  match 'admin/teachers/new' => 'admin#teachers_new'
  match 'admin/teachers/bulk/new' => 'admin#teachers_new_bulk'
  match 'admin/teachers/add' => 'admin#teachers_add' ,:via => :post
  match 'admin/teachers/bulk/add' => 'admin#teachers_bulk_add' ,:via => :post
  match 'admin/students/new' => 'admin#students_new'
  match 'admin/students/bulk/new' => 'admin#students_new_bulk'
  match 'admin/students/add' => 'admin#students_add' ,:via => :post
  match 'admin/students/bulk/add' => 'admin#students_bulk_add' ,:via => :post
  match 'admin/programs/new' => 'admin#programs_new'
  match 'admin/manage/students' => 'admin#manage_students'
  match 'admin/manage/teachers' => 'admin#manage_teachers'
  match 'admin/manage/departments' => 'admin#department_index'
  match 'admin/manage/programs' => 'admin#manage_programs'
  match 'admin/traffic' => 'admin#report_traffic'
  match 'admin/tasks/:task_id' => 'admin#task_show'
  match 'admin/connect/students' => 'admin#connect_students_new'

  #department routes
  match 'departments' => 'department#index'
  match 'departments/new' => 'department#new'
  match 'departments/create' => 'department#create' ,:via => :post
  match 'departments/:id/update' => 'department#update' ,:via => :put
  match 'departments/:id' => 'department#show'
  match 'departments/:id/destroy' => 'department#destroy'
  match 'departments/:id/edit' => 'department#edit'
  match 'departments/:id/programs/new' => 'department#program_new' 
  match 'departments/:id/programs/create' => 'department#program_create' ,:via => :post
  match 'departments/:id/programs/:program_id' => 'department#program_show'
  match 'departments/:id/programs' => 'department#program_index'

  #program routes
  match 'programs/:id' => 'program#show'
  match 'programs/:id/courses/new' => 'program#course_new'
  match 'programs/:id/courses/create' => 'program#course_create' ,:via => :post
  match 'programs/:id/courses' => 'program#course_index'

  ##courses routes
  match 'courses/:id/home'  => 'course#show'
  match 'courses/:id/channel'  => 'course#channel_show'
  match 'courses/:id/channel/new'  => 'course#channel_new'
  match 'courses/:id/files/new' => 'course#file_new'
  match 'courses/:id/files/create' => 'course#file_create' ,:via => :post
  match 'courses/:id/files' => 'course#file_index'
  match 'courses/:id/groups' => 'course#group_index'
  match 'courses/:id/groups/assign' => 'course#group_assign'
  match 'courses/:id/announcements/new' => 'course#announcement_new'
  match 'courses/:id/announcements/create' => 'course#announcement_create' ,:via => :post
  match 'courses/:id/announcements' => 'course#announcement_index'
  match 'courses/:id/assignments/new' => 'course#assignment_new'
  match 'courses/:id/assignments/create' => 'course#assignment_create' ,:via => :post
  match 'courses/:id/assignments' => 'course#assignment_index' 
  match 'courses/:id/assignments/:ass_id' => 'course#assignment_show' 
  match 'courses/:id/assignments/:ass_id/solve' => 'course#assignment_solution_new' 
  match 'courses/:id/assignments/:ass_id/solve/create' => 'course#assignment_solution_create' ,:via => :post 
  match 'courses/:id/assignments/:ass_id/evaluate' => 'course#evaluate_home' 
  match 'courses/:id/assignments/:ass_id/submitsolution' => 'courses#submitsolution' ,:via => :post 
  match 'courses/:id/assignments/:ass_id/solutions/:sol_id' => 'course#assignment_solution_show' 
  match 'courses/:id/assignments/:ass_id/solutions/:sol_id/evaluate' => 'course#assignment_solution_evaluate' 
  match 'courses/:id/assign/teacher' => 'course#teacher_assign'
  match 'courses/:id/assign/create' => 'course#teacher_assign_create' ,:via => :put
  match 'courses/:id/forum' => 'course#forum'
  match 'courses/:id/forum/new' => 'course#forum_new'
  match 'courses/:id/forum/topics/new' => 'course#forum_topics_new'
  match 'courses/:id/forum/topics/create' => 'course#forum_topics_create' ,:via => :post 
  match 'courses/:id/forum/topics/:topic_id' => 'course#forum_topics_show'  
  match 'courses/:id/forum/topics/:topic_id/create_post' => 'course#forum_topics_create_post' ,:via => :post  

  #regsitration routes
  match 'register/teacher/new' => 'registration#teacher_new'
  match 'register/teacher/create' => 'registration#teacher_create' ,:via => :post
  match 'register/student/new' => 'registration#student_new'
  match 'register/student/create' => 'registration#student_create' ,:via => :post
  match 'register/success' => 'registration#success'
  match 'register/verify/:one_time_id/update' => 'registration#verify_update' ,:via => :post
  match 'register/verify/:one_time_id' => 'registration#verify'
  match 'register/forgot/new' => 'registration#forgotpass_new'
  match 'register/forgot/create' => 'registration#forgotpass_create' ,:via => :post

  #group routes
  match 'groups/:id' => 'course_group#home'
  match 'groups/:id/people' => 'course_group#people'
  match 'groups/:id/collaborate' => 'course_group#pads'
  match 'groups/:id/collaborate/new' => 'course_group#pads_new'

  #calendar routes
  match 'calendar' => 'calendar#home'
  match 'calendar/events' => 'calendar#events_index'
  match 'calendar/events/new' => 'calendar#events_new'
  match 'calendar/events/create' => 'calendar#events_create'
  match 'calendar/events/:event_id' => 'calendar#events_show'

  #helper routes
  match 'search/users' => 'user#search_json'
  match 'users/:user_id/profile' => 'user#profile' 
  match 'users/:user_id/message/new' => 'user#message_new' 
  match 'users/:user_id/message/create' => 'user#message_create' ,:via => :post 
  match 'users/:user_id/message/done' => 'user#message_done' 
  match 'users/:user_id/profile/resetpass' => 'user#resetpass'  
  match 'users/:user_id/profile/resetpass_update' => 'user#resetpass_update' ,:via => :post 
  match 'users/:user_id/contact/edit' => 'user#edit_contact'  
  match 'users/:user_id/contact/update' => 'user#update_contact' ,:via => :put 

  #tasks route
  match 'tasks/:task_type' => 'task#search'


end
