require 'spec_helper'
require 'capybara/rspec'
require_relative '../url_shortener'

Capybara.app = UrlShortener

feature 'URL shortening' do
  scenario 'Allows user to shorten a URL' do
    visit '/'

    fill_in 'url_to_shorten', with: 'http://livingsocial.com'
    click_on 'Shorten'

    expect(page).to have_content 'Original URL'
    expect(page).to have_content 'http://livingsocial.com'
    expect(page).to have_content '"Shortened" URL'
    expect(page).to have_content 'http://www.example.com:80/1'

    visit '/1'

    expect(current_url).to eq 'http://livingsocial.com/'
  end

  scenario 'Reports an error when user tries to shorten a non-url' do
    visit '/'

    fill_in 'url_to_shorten', with: 'not a url'
    click_on 'Shorten'

    expect(page).to have_content 'The text you entered is not a valid URL'

    visit '/'

    fill_in 'url_to_shorten', with: 'asdfasdfasdfasdf'
    click_on 'Shorten'

    expect(page).to have_content 'The text you entered is not a valid URL'
  end

  scenario 'Reports an error when user tries to shorten a blank url' do
    visit '/'

    click_on 'Shorten'

    expect(page).to have_content 'URL can not be blank'
  end
end