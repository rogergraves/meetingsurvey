require 'spec_helper'

describe SurveyInvite do
  let(:survey_invite) { FactoryGirl.create(:survey_invite) }

  it 'Factory works' do
    expect(survey_invite).to be_valid
  end

  context 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting_occurrence) }
  end

  context 'Validations' do
    it "user is required" do
      expect(survey_invite).to be_valid
      survey_invite.user_id = nil
      expect(survey_invite).to_not be_valid
    end

    it "meeting_occurrence is required" do
      expect(survey_invite).to be_valid
      survey_invite.meeting_occurrence_id = nil
      expect(survey_invite).to_not be_valid
    end

    it "generated link_code must be unique" do
      another_survey_invite = FactoryGirl.create(:survey_invite)
      expect(another_survey_invite).to be_valid
      another_survey_invite.link_code = survey_invite.link_code
      expect(another_survey_invite).to_not be_valid
    end

    it "user_id + meeting_occurrence_id combination must be unique" do
      another_meeting = FactoryGirl.create(:survey_invite)
      expect(another_meeting).to be_valid
      another_meeting.user_id = survey_invite.user_id
      expect(another_meeting).to be_valid
      another_meeting.meeting_occurrence_id = survey_invite.meeting_occurrence_id
      expect(another_meeting).to_not be_valid
    end
  end
end
