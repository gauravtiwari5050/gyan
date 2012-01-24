# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120124115316) do

  create_table "assignment_solutions", :force => true do |t|
    t.integer  "assignment_id"
    t.integer  "user_id"
    t.text     "content"
    t.string   "file"
    t.integer  "marks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scribd_id"
    t.string   "scribd_key"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "detail"
    t.integer  "total_marks"
    t.string   "assignment_file"
    t.string   "scribd_id"
    t.string   "scribd_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "deadline"
  end

  create_table "bbbs", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.string   "meeting_id"
    t.string   "attendee_pw"
    t.string   "moderator_pw"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_allocations", :force => true do |t|
    t.integer  "course_id"
    t.integer  "program_id"
    t.integer  "term"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_announcements", :force => true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_files", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scribd_id"
    t.string   "scribd_key"
  end

  create_table "course_groups", :force => true do |t|
    t.integer  "course_id"
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.integer  "institute_id"
    t.string   "name"
    t.text     "about"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["code"], :name => "index_courses_on_code", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "departments", :force => true do |t|
    t.integer  "institute_id"
    t.string   "name"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "etherpads", :force => true do |t|
    t.integer  "course_group_id"
    t.string   "name"
    t.string   "server"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "group_students", :force => true do |t|
    t.integer  "course_group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helper_program_courses", :force => true do |t|
    t.string   "course_name"
    t.string   "course_code"
    t.text     "course_about"
    t.integer  "course_term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helper_registrations", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helper_user_verifies", :force => true do |t|
    t.string   "username"
    t.string   "pass"
    t.string   "pass_repeat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institute_urls", :force => true do |t|
    t.integer  "institute_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institute_urls", ["url"], :name => "index_institute_urls_on_url", :unique => true

  create_table "institutes", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutes", ["code"], :name => "index_institutes_on_code", :unique => true

  create_table "logins", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", :force => true do |t|
    t.integer  "department_id"
    t.string   "term_type"
    t.integer  "total_terms"
    t.string   "branch"
    t.string   "degree"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signups", :force => true do |t|
    t.string   "institute_name"
    t.string   "institute_url"
    t.string   "admin_email"
    t.string   "admin_pass"
    t.string   "admin_pass_confirm"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_program_details", :force => true do |t|
    t.integer  "student_id"
    t.integer  "program_id"
    t.integer  "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "institute_id"
    t.string   "username"
    t.string   "email"
    t.string   "password_crypt"
    t.string   "user_type"
    t.string   "one_time_login"
    t.boolean  "is_validated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
