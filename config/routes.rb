GyanV1::Application.routes.draw do

  get "task/search"

  get "course_group/home"

  get "user/search"

  get "calendar/home"

  get "group/home"


  get "student/home"

  get "teacher/home"

  get "registration/teacher_new"

  get "course/show"

  get "admin/home"

  get "login/new"

  get "signup/new"
  match "/" => 'static#welcome'
  match "demo" => 'static#demo'

  #regsitration for a new institute
  match 'signup' => 'signup#new'
  match 'register-institute' => 'signup#register_institute' ,:via => :post

  #login routes
  match 'login' => 'login#new'
  match 'logout' => 'login#destroy'

  match 'loguser' => 'login#loguser' ,:via => :post


  #student routes
  match 'home/academic_profile' => 'home#profile_edit'
  match 'home/profile_update' => 'home#profile_update' ,:via => :put


  #home routes
  match 'home' => 'home#home'
  match 'home/users' => 'home#users_index'
  match 'home/departments' => 'home#department_index'
  match 'home/departments/new' => 'home#department_new'
  match 'home/departments/create' => 'home#department_create' ,:via => :post
  match 'home/courses' => 'home#course_index'
  match 'home/teachers/new' => 'home#teachers_new'
  match 'home/teachers/bulk/new' => 'home#teachers_new_bulk'
  match 'home/teachers/add' => 'home#teachers_add' ,:via => :post
  match 'home/teachers/bulk/add' => 'home#teachers_bulk_add' ,:via => :post
  match 'home/students/new' => 'home#students_new'
  match 'home/students/bulk/new' => 'home#students_new_bulk'
  match 'home/students/add' => 'home#students_add' ,:via => :post
  match 'home/students/bulk/add' => 'home#students_bulk_add' ,:via => :post
  match 'home/programs/new' => 'home#programs_new'
  match 'home/manage/students' => 'home#manage_students'
  match 'home/manage/teachers' => 'home#manage_teachers'
  match 'home/manage/departments' => 'home#department_index'
  match 'home/manage/programs' => 'home#manage_programs'
  match 'home/manage/courses' => 'home#manage_courses'
  match 'home/traffic' => 'home#report_traffic'
  match 'home/tasks/:task_id' => 'home#task_show'
  match 'home/ivrs/edit' => 'home#ivrs_edit'
  match 'home/ivrs/update' => 'home#ivrs_update' ,:via => :put
  match 'home/ivrs/upload_result' => 'home#ivrs_result_upload' ,:via => :post
  match 'home/connect/students/new' => 'home#connect_students_new'
  match 'home/connect/students/create' => 'home#connect_students_create' ,:via => :post
  match 'home/connect/teachers/new' => 'home#connect_teachers_new'
  match 'home/connect/teachers/create' => 'home#connect_teachers_create' ,:via => :post
  match 'home/connect/departments' => 'home#connect_departments_select'
  match 'home/departments/:department_id/connect/new' => 'home#connect_department_new'
  match 'home/departments/:department_id/connect/create' => 'home#connect_department_create' ,:via => :post 

  #department routes
  match 'departments/:id/update' => 'department#update' ,:via => :put
  match 'departments/:id' => 'department#show'
  match 'departments/:id/destroy' => 'department#destroy'
  match 'departments/:id/edit' => 'department#edit'
  match 'departments/:id/programs/new' => 'department#program_new' 
  match 'departments/:id/programs/create' => 'department#program_create' ,:via => :post
  match 'departments/:id/programs/:program_id' => 'department#program_show'
  match 'departments/:id/programs' => 'department#program_index'
  match 'departments/:id/announcements' => 'department#announcement_index' 
  match 'departments/:id/announcements/new' => 'department#announcement_new' 
  match 'departments/:id/announcements/create' => 'department#announcement_create' ,:via => :post 

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
  match 'courses/:id/files/:file_id' => 'course#file_show' #json object display
  match 'courses/:id/groups' => 'course#group_index'
  match 'courses/:id/groups/assign' => 'course#group_assign'
  match 'courses/:id/groups/assign/manual' => 'course#group_assign_manual_new'
  match 'courses/:id/groups/assign/create' => 'course#group_assign_manual_create' ,:via => :put
  match 'courses/:id/announcements/new' => 'course#announcement_new'
  match 'courses/:id/announcements/create' => 'course#announcement_create' ,:via => :post
  match 'courses/:id/announcements' => 'course#announcement_index'
  match 'courses/:id/assignments/new' => 'course#assignment_new'
  match 'courses/:id/assignments/create' => 'course#assignment_create' ,:via => :post
  match 'courses/:id/assignments' => 'course#assignment_index' 
  match 'courses/:id/assignments/:ass_id' => 'course#assignment_show' 
  match 'courses/:id/assignments/:ass_id/solve' => 'course#assignment_solution_new' 
  match 'courses/:id/assignments/:ass_id/create' => 'course#assignment_solution_create' ,:via => :put 
  match 'courses/:id/assignments/:ass_id/evaluate' => 'course#evaluate_home' 
  #match 'courses/:id/assignments/:ass_id/submitsolution' => 'courses#submitsolution' ,:via => :post 
  match 'courses/:id/assignments/:ass_id/solutions/:sol_id' => 'course#assignment_solution_show' 
  match 'courses/:id/assignments/:ass_id/solutions/:sol_id/edit' => 'course#assignment_solution_edit'
  match 'courses/:id/assignments/:ass_id/solutions/:sol_id/grade' => 'course#assignment_solution_edit'
  match 'courses/:id/assignments/:ass_id/solutions/:sol_id/create' => 'course#assignment_solution_update' ,:via => :put 
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
  match 'groups/:id/delete' => 'course_group#delete'
  match 'groups/:id/people' => 'course_group#people'
  match 'groups/:id/collaborate' => 'course_group#pads'
  match 'groups/:id/collaborate/new' => 'course_group#pads_new'

  #calendar routes
  match 'calendar' => 'calendar#home'
  match 'calendar/events' => 'calendar#events_index'
  match 'calendar/events/new' => 'calendar#events_new'
  match 'calendar/events/create' => 'calendar#events_create'
  match 'calendar/events/:event_id/edit' => 'calendar#events_edit'
  match 'calendar/events/:event_id/create' => 'calendar#events_create'

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
  match 'inbox' => 'user#inbox_index'
  match 'inbox/sent' => 'user#inbox_sent_index'
  match 'inbox/compose' => 'user#inbox_compose'

  #tasks route
  match 'tasks/:task_type' => 'task#search'

  #ivrs routes
  match 'ivrs' => 'ivrs#home'

  #assignment routes
  match 'assignments/:id' => 'assignment#home'


end
