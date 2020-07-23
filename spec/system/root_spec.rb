require "rails_helper"

RSpec.describe "Widget management", :type => :system do

  it "enables me to create widgets" do
    visit "/"

    expect(page).to have_text("sumikio+10@gmail.com")
  end
end
