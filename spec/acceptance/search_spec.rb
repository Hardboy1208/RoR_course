require 'sphinx_acceptance_helper'

feature 'Search' do
  given!(:user) { create(:user) }
  given!(:question_search) { create(:question, title: 'title for search', body: 'question for searched') }
  given!(:answer_search)   { create(:answer, body: 'answer for searched') }
  given!(:comment_search)  { Comment.create(commentable_id: question_search.id, commentable_type: "Question", body: 'comment for searched', user: user) }

  given!(:question_not_search) { create(:question, body: 'simply question') }
  given!(:answer_not_search)   { create(:answer, body: 'simply answer') }
  given!(:comment_not_search)  { Comment.create(commentable_id: question_not_search.id, commentable_type: "Question", body: 'simply comment', user: user) }

  background do
    index
    visit(root_path)
    fill_in 'q', with: "searched"
  end

  scenario 'search without filters', :js do
    click_on "Search"
    expect(page).to have_content question_search.title
    expect(page).to have_content answer_search.body
    expect(page).to have_content comment_search.body

    expect(page).to_not have_content question_not_search.title
    expect(page).to_not have_content answer_not_search.body
    expect(page).to_not have_content comment_not_search.body
  end

  scenario 'search with question filter' do
    select 'question', from: 'search_class'
    click_on "Search"
    expect(page).to have_content question_search.title
    expect(page).to_not have_content answer_search.body
    expect(page).to_not have_content comment_search.body
  end


  scenario 'search with answer filter' do
    select 'answer', from: 'search_class'
    click_on "Search"

    expect(page).to_not have_content question_search.title
    expect(page).to have_content answer_search.body
    expect(page).to_not have_content comment_search.body
  end

  scenario 'search with comment filter' do
    select 'comment', from: 'search_class'
    click_button "Search"

    expect(page).to_not have_content question_search.title
    expect(page).to_not have_content answer_search.body
    expect(page).to have_content comment_search.body
  end
end