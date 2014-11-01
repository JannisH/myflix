require 'spec_helper'

feature  "User interaction with his following list" do

  given(:user) { Fabricate(:user) }
  given(:second_user) { Fabricate(:user) }

  scenario "a user adds another one to his followeds" do
    sign_in_user
    visit user_path(second_user)
    click_link "follow"
    expect(page).to have_content("#{second_user.full_name}")
    find("a[href='/users/2/unfollow']").click
    expect(page).to_not have_content("#{second_user.full_name}")
  end
end