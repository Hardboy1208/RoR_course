# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/




rating_send = ->
  $('a.rating-link').bind 'ajax:success', (e) ->
    console.log(e.detail[0])
    rating = e.detail[0]
    $(".question-#{rating.retractable_id} .rating .rating_message").html(rating.message)
    if rating.voted
      $(".question-#{rating.retractable_id} .rating .rating_links").html("<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/questions/#{rating.retractable_id}/rating_reset'>Переголосовать</a>")
    else
      $(".question-#{rating.retractable_id} .rating .rating_links").html("<a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/questions/#{rating.retractable_id}/rating_up'>+1</a>
                  <a class='rating-link' data-remote='true' rel='nofollow' data-method='patch' href='/questions/#{rating.retractable_id}/rating_down'>-1</a>")
    $(".question-#{rating.retractable_id} .rating .diff_like").html("(#{rating.diff_like})")
    rating_send()
$ ->
  rating_send()

$(document).on 'turbolinks:load', ->
  rating_send()