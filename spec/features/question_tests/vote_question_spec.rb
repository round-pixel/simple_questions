require "features_helper"

feature "votable question" do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }
  let(:question)    { create(:question, user: user) }

  it_behaves_like "votable author", "question"
  it_behaves_like "votable others", "question"
  it_behaves_like "votable unregisted", "question"
end