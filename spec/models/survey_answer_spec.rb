require 'spec_helper'

describe SurveyAnswer do
  let(:survey_answer) { FactoryGirl.create(:survey_answer) }

  it 'Factory works' do
    expect(survey_answer).to be_valid
  end

  context 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting_occurrence) }
  end

  context 'Validations' do
    it "user is required" do
      expect(survey_answer).to be_valid
      survey_answer.user_id = nil
      expect(survey_answer).to_not be_valid
    end

    it "meeting_occurrence is required" do
      expect(survey_answer).to be_valid
      survey_answer.meeting_occurrence_id = nil
      expect(survey_answer).to_not be_valid
    end

    it "question must be unique per meeting+user" do
      another_answer = FactoryGirl.create(:survey_answer, :user => survey_answer.user, :meeting_occurrence => survey_answer.meeting_occurrence, :question => 'Was everyone there?')
      expect(another_answer).to be_valid
      another_answer.question = survey_answer.question
      expect(another_answer).to_not be_valid
    end
  end
end
