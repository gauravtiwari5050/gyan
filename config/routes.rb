GyanV1::Application.routes.draw do

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

  #student routes
  match 'student' => 'student#home'
  match 'student/profile' => 'student#profile_edit'
  match 'student/profile_update' => 'student#profile_update' ,:via => :put


  #admin routes
  match 'admin' => 'admin#home'
  match 'admin/departments' => 'admin#department_index'
  match 'admin/teachers/new' => 'admin#teachers_new'
  match 'admin/teachers/add' => 'admin#teachers_add' ,:via => :post
  match 'admin/students/new' => 'admin#teachers_new'
  match 'admin/students/add' => 'admin#students_add' ,:via => :post

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
  match 'groups/:group_id' => 'group#home'
  match 'groups/:group_id/people' => 'group#people'
  match 'groups/:group_id/collaborate' => 'group#pads'
  match 'groups/:group_id/collaborate/new' => 'group#pads_new'

  #calendar routes
  match 'calendar' => 'calendar#home'
  match 'calendar/events' => 'calendar#events_index'
  match 'calendar/events/new' => 'calendar#events_new'
  match 'calendar/events/create' => 'calendar#events_create'
  match 'calendar/events/:event_id' => 'calendar#events_show'


end
