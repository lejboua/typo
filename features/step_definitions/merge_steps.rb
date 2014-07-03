Given /^the following articles exist$/ do |articles|
  # articles is a Cucumber::Ast::Table
  #     | id | title    | body          | user     |
  #     | 2  | Foobar   | Lorem Ipsum   | Legolas  |
  #     | 3  | Foobar 2 | Lorem Ipsum 2 | Frodo    |
  articles.hashes.each do |article|
    author = User.find_by_name(article[:user])
    article['user'] = author
    # 14/03/07 06:38:32, AA: It doesn't set the IDs
    a = Article.create(article)
  end
end

Given /^the following naive articles exist$/ do |articles|
  # articles is a Cucumber::Ast::Table
  #     | id | title    | body          |
  #     | 2  | Foobar   | Lorem Ipsum   |
  #     | 3  | Foobar 2 | Lorem Ipsum 2 |
  # 14/03/07 05:53:01, AA: way used on the homework introduction
  # 14/03/07 06:38:32, AA: It doesn't set the IDs
  Article.create articles.hashes
end

Then /^the article "(.*?)" should have body "(.*?)"$/ do |title, body|
  Article.find_by_title(title).body.should eq body
end

Given /^the following users exist$/ do |table|
  #     | id | name     |
  #     | 4  | Legolas  |
  #     | 5  | Frodo    |
  # table is a Cucumber::Ast::Table
  table.hashes.each do |row|
    User.create!({:login => row[:name].downcase,
                  :password => row[:name].downcase + 'pwd',
                  :email => row[:name] + '@mail.com',
                  :profile_id => 2,
                  :name => row[:name].downcase,
                  :state => 'active'})
  end
end

And /^I am logged in as "(.+)" into the admin panel$/ do |username|
  u = User.find_by_name(username)
  visit '/accounts/login'
  fill_in 'user_login', :with => username.downcase
  fill_in 'user_password', :with => username.downcase + 'pwd'
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end


When /^(?:|I )fill in "([^"]*)" with the id of the article with title "([^"]*)"$/ do |field, title|
  a = Article.find_by_title(title)
  fill_in(field, :with => a.id)
end

Then /^the article "(.*?)" should have author "(.*?)"$/ do |title, author_name|
  Article.find_by_title(title).user.name.should eq author_name
end

Then /^the "([^"]*)" field(?: within (.*))? should not exist$/ do |field, parent|
# with_scope(parent) do
    # find_field raises an error if not found
#   non_existent_field = find_field(field)
#   non_existent_field.should be_nil
# end
end

# 14/03/07 10:23:46, AA:
# From http://makandracards.com/makandra/5793-test-whether-a-form-field-exists-with-cucumber-and-capybara
Then /^I should( not)? see a field "([^"]*)"$/ do |negate, name|
  expectation = negate ? :should_not : :should
  begin
    field = find_field(name)
  rescue Capybara::ElementNotFound
    # In Capybara 0.4+ #find_field raises an error instead of returning nil
  end
  field.send(expectation, be_present)
end
