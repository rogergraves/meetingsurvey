require 'spec_helper'

describe SurveyAnswer do
  let(:meeting_answer) { FactoryGirl.create(:meeting_answer, :question => 'Did you have a good time?', :answer => 'Yes') }

  it 'Factory works' do
    expect(meeting_answer).to be_valid
  end

  context 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting) }
  end

  context 'Validations' do
    it "user is required" do
      expect(meeting_answer).to be_valid
      meeting_answer.user_id = nil
      expect(meeting_answer).to_not be_valid
    end

    it "meeting is required" do
      expect(meeting_answer).to be_valid
      meeting_answer.meeting_id = nil
      expect(meeting_answer).to_not be_valid
    end

    it "question must be unique per meeting+user" do
      another_answer = FactoryGirl.create(:meeting_answer, :user => meeting_answer.user, :meeting => meeting_answer.meeting, :question => 'Was everyone there?')
      expect(another_answer).to be_valid
      another_answer.question = meeting_answer.question
      expect(another_answer).to_not be_valid
    end

  end
end
