require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it 'Factory works' do
    expect(user.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should have_many(:meeting_participations) }
    it { should have_many(:meeting_answers) }

    it 'does not orphan meeting_participations when users are deleted' do
      meeting_participation = FactoryGirl.create(:meeting_participation, :user => user)
      expect(SurveyInvite.exists?(id: meeting_participation.id)).to be_truthy
      user.destroy
      expect(SurveyInvite.exists?(id: meeting_participation.id)).to be_falsey
    end

    it 'does not orphan meeting_answers when users are deleted' do
      meeting_answer = FactoryGirl.create(:meeting_answer, :user => user)
      expect(MeetingAnswer.exists?(id: meeting_answer.id)).to be_truthy
      user.destroy
      expect(MeetingAnswer.exists?(id: meeting_answer.id)).to be_falsey
    end
  end
end
