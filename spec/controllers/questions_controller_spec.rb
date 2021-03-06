require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user

  let(:question) { create(:question, user_id: @user.id) }
  let(:other_user)    { create(:user) }

  it_behaves_like "voted" do  
    let!(:user_model)   { create(:question, user: other_user) }
    let!(:author_model) { create(:question, user: @user) }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: @user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { get :new }

    it "question should be eq new Question" do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it "render new view" do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { process :create,
                 method: :post,
                 params: { question: attributes_for(:question) }
               }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        process :create, method: :post, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "does not save the question" do
        expect { process :create,
                 method: :post,
                 params: { question: attributes_for(:invalid_question) }
                }.to_not change(Question, :count)
      end

      it "re-renders new view" do
        process :create, method: :post, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assings the requested question to @question' do
        process :update,
                method: :post,
                format: :js,
                params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        process :update,
                method: :post,
                format: :js,
                params: { id: question, question: { title: 'new title', body: 'new body'}}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        process :update,
                method: :post,
                format: :js,
                params: { id: question, question: attributes_for(:question) }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { process :update,
                       method: :post,
                       format: :js,
                       params: { id: question, question: { title: 'new title', body: nil} } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author can delete message' do
      before { question }
      
      it 'should delete question' do
        expect { process :destroy,
                 method: :delete,
                 params: { id: question } }.to change(@user.questions, :count).by(-1)
      end

      it 'redirect to index views' do
        process :destroy, method: :delete, params: { id: question }
        
        expect(response).to redirect_to questions_path
      end
    end

    context 'non author cant delete question' do
      let!(:question)   { create(:question, user: other_user) }

      it "should not delete question" do
         expect { process :destroy,
                 method: :delete,
                 params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
