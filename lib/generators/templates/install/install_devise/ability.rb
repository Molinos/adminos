class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user.is?(:admin)
     can :manage, :all
   end

    # if user.is?(:admin)
    #   can :manage, :all
    # elsif user.is?(:hr)
    #   hr_abilities
    # elsif user.is? :member
    #   user_abilities
    # elsif user.is? :manager
    #   manager_abilities
    # end
  end

  # def hr_abilities
  #   can :manage, [Page, Response, Vacancy, Department,
  #                 Settings, Status, Comment, Post, Event,
  #                 City, Office, EventRegistration]
  #   can :manage, User do |user|
  #     %i[member manager].include?(user.role_symbols.last)
  #   end
  # end
  #
  # def user_abilities
  #   can :manage, Comment
  #   can %i[read edit update], Response do |response|
  #     @user.department_ids.include?(response.vacancy.department_id)
  #   end
  # end
  #
  # def manager_abilities
  #   user_abilities
  #
  #   can :new, Vacancy
  #
  #   can %i[read edit update create], Vacancy do |vacancy|
  #     @user.department_ids.include?(vacancy.department_id)
  #   end
  # end
end
