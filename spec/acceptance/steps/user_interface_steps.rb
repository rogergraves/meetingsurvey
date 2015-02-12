require 'spec_helper'

module UserInterfaceSteps
  step "I am on the main page" do
    visit '/'
  end

  step "I see 'Coming Soon!' text" do
    expect(page).to have_content 'Coming Soon!'
  end

  step "I visit survey wrong with wrong link_code" do
    visit '/survey/wrong_link_code'
  end

  step "I see 'Meeting not found' text" do
    expect(page).to have_content 'Meeting not found'
  end
end

RSpec.configure { |c| c.include UserInterfaceSteps }