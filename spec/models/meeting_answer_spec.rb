require 'spec_helper'

describe MeetingAnswer do
  let(:meeting_answer) { FactoryGirl.create(:meeting_answer, :question => 'Did you have a good time?', :answer => 'Yes') }

  it 'Factory works' do
    expect(meeting_answer.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting) }
  end

  context 'Validations' do
    it "user is required" do
      expect(meeting_answer.valid?).to eq(true)
      meeting_answer.user_id = nil
      expect(meeting_answer.valid?).to eq(false)
    end

    it "meeting is required" do
      expect(meeting_answer.valid?).to eq(true)
      meeting_answer.meeting_id = nil
      expect(meeting_answer.valid?).to eq(false)
    end

    it "question must be unique per meeting+user" do
      another_answer = FactoryGirl.create(:meeting_answer, :user => meeting_answer.user, :meeting => meeting_answer.meeting, :question => 'Was everyone there?')
      expect(another_answer.valid?).to eq(true)
      another_answer.question = meeting_answer.question
      expect(another_answer.valid?).to eq(false)
    end

  end
end
