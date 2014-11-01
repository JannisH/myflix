require 'spec_helper'

feature  "User interaction with his queue" do

  given(:user) { Fabricate(:user) }
  
  scenario "a user signs in" do
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content 'You have successfully logged in!'
  end

  scenario "user adds and reorders videos in his queue" do
    create_video_list(3)
    category = Category.create(name: "action")
    category.videos << Video.all
    VideoQueue.create(user_id: 1)
    sign_in_user
    add_video_to_queue(Video.first)
    expect_video_to_be_in_queue(Video.first)

    visit video_path(Video.first)
    expect_link_not_to_be_seen("+ My Queue")
    
    add_video_to_queue(Video.find(2))
    add_video_to_queue(Video.find(3))
    
    set_video_priority(Video.first, 3)
    set_video_priority(Video.find(2), 1)
    set_video_priority(Video.find(3), 2)

    update_queue
    expect(find("#video_1").value.to_i).to eq(3)
    expect(find("#video_2").value.to_i).to eq(1)
    expect(find("#video_3").value.to_i).to eq(2)

    visit user_path(user)
    expect_video_to_be_in_queue(Video.find(2))
    
  end
end
def set_video_priority(video, priority)
  fill_in "video_#{video.id}",with: priority
end

def expect_video_to_be_in_queue(video)
  expect(page).to have_content video.title
end

def expect_link_not_to_be_seen(link_text)
  expect(page).to_not have_content("+ My Queue")
end

def update_queue
  click_button "Update Instant Queue"
end

def add_video_to_queue(video)
  visit videos_path
  find("a[href='/videos/#{video.id}']").click
  click_link "+ My Queue"
end
