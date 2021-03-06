require 'rails_helper'

feature 'member votes on a review', %{
  As a reviewer
  I want to be able to leave an up or down vote on each review
  So that I can share my opinion with other users
} do
  # Acceptance Criteria
  # * If I'm signed in, I should be able to up/down vote a review
  # * If I up or down/vote a review
  # * I should see the score update on the page

  # * If I up or down/vote a review
  # * I should be able to modify my vote

  # * If I up or down/vote a review
  # * I should not be able to submit the same vote a second time

  before(:each) do
    member = FactoryGirl.create(:user)
    sign_in(member)
    vendor = FactoryGirl.create(:vendor)
    FactoryGirl.create(:review, vendor: vendor, user: member)
    visit vendor_path(vendor)
  end

  scenario 'member posts up-vote to a review' do
    click_button 'Up'
    expect(page).to have_content 'Review Score: 1'
  end

  scenario 'member posts down-vote to a review' do
    click_button 'Down'
    expect(page).to have_content 'Review Score: -1'
  end

  scenario 'member up-votes then changes to down-vote' do
    click_button 'Up'
    click_button 'Down'
    expect(page).to have_content 'Review Score: -1'
  end

  scenario 'member votes up or down twice' do
    click_button 'Up'
    click_button 'Up'
    expect(page).to have_content 'You already did that!'
    expect(page).to have_content 'Review Score: 1'
  end
end
