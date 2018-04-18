rating_send = ->
  $('a.rating-link').bind 'ajax:success', (e) ->
    console.log(e.detail[0])
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
  rating_send()

$(document).on 'turbolinks:load', ->
  rating_send()
