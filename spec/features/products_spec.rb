require 'rails_helper'
require 'capybara/rspec'

RSpec.feature "Product", :type => :feature do
  # scenario "Admin creates a valid product" do
  #   login 'Admin'
  #   visit new_manage_product_url

  #   fill_in 'Title', :with => "My Widget"
  #   select "All", from: 'product[visibility]'
  #   click_button "Create"

  #   expect(page).to have_text("Product was successfully created")
  # end

  scenario "Product Manager can't create a Product" do
    login 'Product Manager'
    visit new_manage_product_url

    expect(page).to have_text("You are not authorized to access this page")
  end

  scenario "Normal User can't create a Product" do
    login
    visit new_manage_product_url

    expect(page).to have_text("You are not authorized to access this page")
  end

  # scenario "Admin creates a duplicate product" do
  #   product = FactoryBot.create(:product, title: "My Widget")

  #   login 'Admin'
  #   visit new_manage_product_url

  #   fill_in "Title", :with => "My Widget"
  #   select "All", from: 'product[visibility]'
  #   click_button "Create"

  #   expect(page).to have_content("Title has already been taken")
  # end

  # scenario "Admin creates a invalid product" do
  #   login 'Admin'
  #   visit new_manage_product_url

  #   fill_in "Title", :with => ""
  #   click_button "Create"

  #   expect(page).to have_content("Title can't be blank")
  # end

  # scenario "Admin updates a Product with its contents" do
  #   pending "************************ PENDED TEST UNTIL CONTENT MANAGER REORG COMPLETE"
  #   # product = FactoryBot.create(:product)


  #   # modulee = FactoryBot.create(:modulee)
  #   # modulee.product_id = product.id
  #   # modulee.save!

  #   # login 'Admin'
  #   # visit edit_manage_product_path(product)

  #   # fill_in "product[contents_attributes][0][name]", with: 'My Module'

  #   # click_button "Update"
  #   # expect(page).to have_text("Product was successfully updated")
  # end

  # scenario "Admin destroys contents of a Product" do
  #   pending "************************* PENDED TEST UNTIL CONTENT MANAGER REORD COMPLETE"
  #   # product = FactoryBot.create(:product)

  #   # modulee = FactoryBot.create(:modulee)
  #   # modulee.product_id = product.id
  #   # modulee.save!

  #   # login 'Admin'
  #   # visit edit_manage_product_path(product)

  #   # all('.remove_fields').first.click

  #   # click_button "Update"

  #   # expect(page).to have_text("Product was successfully updated")
  # end

  # scenario "Admin destroys a Product" do
  #   # product = FactoryBot.create(:product)

  #   # login 'Admin'
  #   # visit manage_products_path

  #   # all('.btn-group > button').first.click
  # end

  private

  def login (role_name = 'Customer')
    role = FactoryBot.create(:role, name: role_name)
    user = FactoryBot.create(:user, roles: [role])

    visit new_user_session_url
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Sign In'
  end

end
