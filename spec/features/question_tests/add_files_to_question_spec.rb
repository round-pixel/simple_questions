require "features_helper"

feature "Add files to question", %q{
  In order to show my question
  As author
  I wanna be able to add some files
} do
  given(:user) { create(:user) }

  before do
    log_in user
    visit new_question_path
  end

  scenario "User adds files to question" do
    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    attach_file 'File', "#{Rails.root}/README.md"
    click_on "Create"

    expect(page).to have_link "README.md", href: "/uploads/attachment/file/1/README.md"
  end
end