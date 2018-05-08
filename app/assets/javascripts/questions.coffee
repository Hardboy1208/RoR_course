# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

rating_send = ->
  $('a.rating-link').bind 'ajax:success', (e) ->
    rating = e.detail[0]
    $(".#{rating.retractable_type}-#{rating.retractable_id} .rating .rating_message").html(rating.message)
    if rating.voted
      $(".#{rating.retractable_type}-#{rating.retractable_id} .rating .rating_links").html("<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/#{rating.retractable_type}s/#{rating.retractable_id}/rating_reset'>Переголосовать</a>")
    else
      $(".#{rating.retractable_type}-#{rating.retractable_id} .rating .rating_links").html("<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/#{rating.retractable_type}s/#{rating.retractable_id}/rating_up'>+1</a>
                  <a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/#{rating.retractable_type}s/#{rating.retractable_id}/rating_down'>-1</a>")
    $(".#{rating.retractable_type}-#{rating.retractable_id} .rating .diff_like").html("(#{rating.diff_like})")
    rating_send()

App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'

  received: (data) ->
    $('.question_lists').prepend (
      JST["templates/question"]({
        question: data.question
        author: data.author
        author_link: (author, question)->
          if gon.user == author
            @safe "<a rel='nofollow' data-method='delete' href='/questions/#{question.id}'>Delete</a> \
                   <a class='edit-question-link' data-remote='true' href='/questions/#{question.id}/edit'>Edit</a>"
        rating_links: (author, question) ->
          if (gon.user != null && gon.user != author)
            @safe "<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/questions/#{question.id}/rating_up'>+1</a>\
                   <a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/questions/#{question.id}/rating_down'>-1</a>"
      })
    );
    rating_send()

})

