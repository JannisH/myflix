describe "the signin process" do

  let(:user) { Fabricate(:user) }
  
  it "signs me in" do
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content 'You have successfully logged in!'
  end

  it "responds to clicks" do
    create_video_list(3)
    category = Category.create(name: "action")
    category.videos << Video.all
    sign_in_user
    save_and_open_page
    page.find("a[href='/videos/1']").click.click
    expect(page).to have_content Video.first.title
  end
end

