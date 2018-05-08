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

$ ->
  $('.edit-answer-link').click (e) ->
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();


App.cable.subscriptions.create('AnswersChannel', {
  connected: ->
    @perform 'follow'

  received: (data) ->
    pathArray = window.location.pathname.split('/');
    if parseInt(pathArray[2]) == data.answer.question_id
      if gon.user.id != data.author.id
        $('.answers').append (
          JST["templates/answer"]({
            answer: data.answer
            author: data.author
            author_link: (author, answer)->
              if gon.user == author
                @safe "<a data-remote='true' rel='nofollow' data-method='delete' href='/answers/#{answer.id}'>Delete</a> \
                       <a class='edit-answer-link' data-answer-id='#{answer.id}' data-remote='true' href=''>Edit</a> \
                       <form id='edit-answer-#{answer.id}' class='edit_answer' action='/answers/#{answer.id}' accept-charset='UTF-8' data-remote='true' method='post'><input name='utf8' type='hidden' value='✓'><input type='hidden' name='_method' value='patch'><label for='answer_body'>Answer</label> \
                         <textarea name='answer[body]' id='answer_body'>112323</textarea> \
                         <input type='submit' name='commit' value='Save' data-disable-with='Save'> \
                       </form>"
            rating_links: (author, answer) ->
              if (gon.user != null && gon.user != author)
                @safe "<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/answers/#{answer.id}/rating_up'>+1</a> \
                       <a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/answers/#{answer.id}/rating_down'>-1</a>"
          })
        );
        rating_send()
})