require 'features_helper'

feature "Delete answer", %q{
Only user(this_user),who create this answer,
Can edit and delete this answer
} do
  given(:user)       { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question)  { create(:question, user: user) }
  given!(:answer)    { create(:answer, user: user, question: question) } 

  scenario "it delete answer", js: true do
    log_in(user)
    visit question_path(question)
    click_on "Delete"

    expect(page).to have_no_content "AnswerText"
  end

  scenario "Other authentication user cant view delete button", js: true do
    log_in(other_user)
    visit question_path(question)

    expect(page).to have_no_link "delete"
  end

  scenario "Non-authentication user can't view delete buttons", js: true do
    visit question_path(question)

    expect(page).to have_no_link "delete"
  end
end