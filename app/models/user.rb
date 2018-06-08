class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:vkontakte, :twitter]

  def author_of?(object)
    object.user_id == self.id
  end

  def already_voted?(object)
    object.ratings.exists?(user_id: self)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email.nil? ? "#{auth.uid}@fakemail.qna" : email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user, Question.for_last_day).deliver_later
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscription?(question)
    self.subscriptions.where(question: question).exists?
  end

  def question_subscription(question)
    self.subscriptions.find_by(question: question)
  end
end
