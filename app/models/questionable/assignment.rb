module Questionable
  class Assignment < ActiveRecord::Base
    attr_accessible :question_id, :subject, :subject_id, :subject_type, :position

    belongs_to :question, :dependent => :destroy
    belongs_to :subject, :polymorphic => true

    has_many :answers, :dependent => :destroy
    has_many :answered_options, :through => :answers, :source => :option
    has_many :comment_assignments, :through => :answers, :source => :assignment

    scope :category, ->(category) { includes(:question).where("questionable_questions.category #{category.nil? ? 'IS ' : ' = '} ?", category) }

    def self.with_subject(subject)
      if subject.kind_of?(Symbol) or subject.kind_of?(String)
        assignments = Questionable::Assignment.where(:subject_type => subject)
      else
        assignments = Questionable::Assignment.where(:subject_type => subject.class.to_s, :subject_id => subject.id)
      end

      assignments.order(:position)
    end

    def answered_comments
      comment_assignments.select('questionable_answers.*, questionable_assignments.*').joins(:answers)
    end

    def total_chart
      results = []
      Questionable::Question.transaction do
        options = question.options
        results = options.map { |o| {title: o.title, value: o.value, data: 0, data_type: 'number'} }
        answered_options.each do |answered_option|
          index = options.index answered_option
          results[index][:data] += 1 if index
        end
      end
      results
    end

    def answers_for_user(user, rating_id)
      if rating_id.nil?
        self.answers.where(user_id: user.id)
      else
        self.answers.where(user_id: user.id, rating_id: rating_id)
      end
    end

    # for ActiveAdmin
    def display_name
      "#{self.subject_type}#{self.subject_id}: #{self.question.title}"
    end

  end # End Assignment
end
