class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @question
      flash[:success] = "Congratulations! Answer created!"
    else
      render :new
      flash[:error] = "Answer is not created! Try later!"
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body,:question_id)
    end
end
