# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

rating_send = ->
  $('a.rating-link').bind 'ajax:success', (e) ->
    console.log(e.detail[0])
    rating = e.detail[0]
    $(".answer-#{rating.retractable_id} .rating .rating_message").html(rating.message)
    if rating.voted
      $(".answer-#{rating.retractable_id} .rating .rating_links").html("<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/answers/#{rating.retractable_id}/rating_reset'>Переголосовать</a>")
    else
      $(".answer-#{rating.retractable_id} .rating .rating_links").html("<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/answers/#{rating.retractable_id}/rating_up'>+1</a>
                  <a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/answers/#{rating.retractable_id}/rating_down'>-1</a>")
    $(".answer-#{rating.retractable_id} .rating .diff_like").html("(#{rating.diff_like})")
    rating_send()

$ ->
  rating_send()

  $('.edit-answer-link').click (e) ->
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

$(document).on 'turbolinks:load', ->
  rating_send()