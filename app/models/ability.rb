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
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :destroy, Attachment, attachmentable: { user: user }
    can [:rating_up, :rating_down], [Question, Answer] do |obj|
      !user.author_of?(obj)
    end
    can :rating_reset, [Question, Answer] do |obj|
      !user.author_of?(obj)
    end
    can :choose_the_best, [Question, Answer]
  end
end
