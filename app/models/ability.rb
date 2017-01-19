class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user 
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create,  [Question, Answer, Comment]
    can [ :update, :destroy ],  [Question, Answer, Comment], { user_id: user.id }
    can :destroy,     Attachment, attachable: { user_id: user.id }
    can :answer_best, Answer,     question: { user_id: user.id }
    can :vote, [Question, Answer]
    can :re_vote, Vote, votable: { user_id: user.id }
    can [:read, :me], User
  end
end
