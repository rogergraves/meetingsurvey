require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it 'Factory works' do
    expect(user.valid?).to eq(true)
  end

  context 'Relationships' do
    it { should have_many(:survey_invites) }
    it { should have_many(:survey_answers) }
    it { should have_many(:meeting_users) }

    it 'does not orphan survey_invites when users are deleted' do
      survey_invite = FactoryGirl.create(:survey_invite, :user => user)
      expect(SurveyInvite.exists?(survey_invite.id)).to be_truthy
      user.destroy
      expect(SurveyInvite.exists?(survey_invite.id)).to be_falsey
    end

    it 'does not orphan survey_answers when users are deleted' do
      survey_answer = FactoryGirl.create(:survey_answer, :user => user)
      expect(SurveyAnswer.exists?(survey_answer.id)).to be_truthy
      user.destroy
      expect(SurveyAnswer.exists?(survey_answer.id)).to be_falsey
    end

    it 'does not orphan meeting_users when users are deleted' do
      meeting_user = FactoryGirl.create(:meeting_user, :user => user)
      expect(MeetingUser.exists?(meeting_user.id)).to be_truthy
      user.destroy
      expect(MeetingUser.exists?(meeting_user.id)).to be_falsey
    end
  end
end
