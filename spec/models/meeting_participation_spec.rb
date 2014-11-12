require 'spec_helper'

describe MeetingParticipation do
  context 'Validations' do
    it { should belong_to(:user) }
    it { should belong_to(:meeting) }
  end
end
