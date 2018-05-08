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
    pathArray = window.location.pathname.split('/');
    @perform 'follow', question_id: pathArray[2]

  received: (data) ->
    pathArray = window.location.pathname.split('/');
    if parseInt(pathArray[2]) == data.answer.question_id
      if gon.user.id != data.answer.user_id
        $('.answers').append (
          JST["templates/answer"]({
            answer: data.answer
            rating_links: (answer) ->
              @safe "<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/answers/#{answer.id}/rating_up'>+1</a> \
                     <a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/answers/#{answer.id}/rating_down'>-1</a>"
          })
        );
        rating_send()

  disconnected: ->
    @perform 'unfollow'
})