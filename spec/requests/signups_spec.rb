require 'spec_helper'

describe "Signups" do
  
  describe "GET /signups" do
    it "gets the signup page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #visit signup create a new institute
      visit "/signup"
      page.should have_css("head title", :content => "Bootstrap, from Twitter")
      fill_in "signup[institute_name]",:with => "Test institute"
      fill_in "signup[institute_url]",:with => "test123url11"
      fill_in "signup[admin_email]",:with => "admin1@admin1.com"
      fill_in "signup[admin_pass]",:with => "1234"
      fill_in "signup[admin_pass_confirm]",:with => "1234"
      click_button "submit"
      page.should have_content("Login")
      #login as admin
      fill_in "login[email]",:with => "admin1@admin1.com"
      fill_in "login[password]" ,:with => "1234"
      click_button "submit"
      page.should have_content("Admin home")
      #add a teacher
      visit "http://test123url11.lvh.me:3000/admin/teachers/new"
      page.should  have_content("Enter the details for the teacher")
      fill_in "user_email",:with => "teacher1@admin1.com"
      fill_in "user_name",:with => "teacher1"
      click_button "Save changes"
      page.should have_content("User created successfuly,an email has been sent to the user to complete registration")

      click_link "Log out"
      page.should have_content("Login")
      testing_fun

      teacher_user = User.find_by_email("teacher1@admin1.com")
      visit_url =  "http://test123url11.lvh.me/register/verify/" + teacher_user.one_time_login
      p "visiting " + visit_url
      visit visit_url
      content_on_page = "teacher1@admin1.com"
      p "checing for content " + content_on_page
      page.should have_content(content_on_page)

      fill_in "helper_user_verify[username]" ,:with => "teacher1"
      fill_in "helper_user_verify[pass]" ,:with => "1234"
      fill_in "helper_user_verify[pass_repeat]" ,:with => "1234"
      click_button "submit"

      page.should have_content("Regsitration successful")


    end

  end
end
def testing_fun
  p "Howdy"
end
