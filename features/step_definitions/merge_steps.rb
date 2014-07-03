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
                  :password => row[:name].downcase,
                  :email => row[:name] + '@mail.com',
                  :profile_id => row[:id],
                  :name => row[:name],
                  :state => 'active'})
  end
end

When /^(?:|I )fill in "([^"]*)" with the id of the article with title "([^"]*)"$/ do |field, title|
  a = Article.find_by_title(title)
  fill_in(field, :with => a.id)
end

Then /^the article "(.*?)" should have author "(.*?)"$/ do |title, author_name|
  pending # express the regexp above with the code you wish you had
  Article.find_by_title(title).author.name.should eq author_name
end
