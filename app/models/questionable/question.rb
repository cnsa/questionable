module Questionable
  class Question < ActiveRecord::Base
    has_many :options, :order => 'questionable_options.position ASC'
    has_many :assignments
    has_many :subjects, :through => :assignments
    has_many :answers, :through => :assignments    
    has_many :question_groups, :through => :assignments

    attr_accessible :title, :input_type, :note, :category

    validates_presence_of :title

    def accepts_multiple_answers?
      ['checkboxes', 'multiselect'].include?(self.input_type)
    end

    def self.create_comment(attributes = nil, options = {}, &block)
      merge = {:input_type => 'text', :category => 'comment'}
      if attributes.is_a?(Array)
        attributes.collect { |attr| self.create(attr.merge(merge), options, &block) }
      else
        self.create(attributes.merge(merge), options, &block)
      end
    end

    def answers_for_user(user)
      answers = self.answers.where(user_id: user.id)
      answers.any? ? answers : [self.answers.build(user_id: user.id)]
    end

    def self.with_subject(subject)
      if subject.kind_of?(Symbol) or subject.kind_of?(String)
        Questionable::Question.joins('INNER JOIN questionable_assignments ON questionable_assignments.question_id = questionable_questions.id').where(:questionable_assignments => { :subject_type => subject }).order('questionable_assignments.position')
      else
        Questionable::Question.joins('INNER JOIN questionable_assignments ON questionable_assignments.question_id = questionable_questions.id').where(:questionable_assignments => { :subject_type => subject.class.to_s, :subject_id => subject.id }).order('questionable_assignments.position')
      end
    end
  end
end
