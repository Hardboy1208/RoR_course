# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App.cable.subscriptions.create('CommentsChannel', {
  connected: ->
    @perform 'follow'

  received: (data) ->
    console.log(data)

    pathArray = window.location.pathname.split('/');
    if parseInt(pathArray[2]) == data.question_id

      console.log(".#{data.comment.commentable_type.toLowerCase()}-#{data.comment.commentable_id} .#{data.comment.commentable_type.toLowerCase()}-comments")
      $(".#{data.comment.commentable_type.toLowerCase()}-#{data.comment.commentable_id} .#{data.comment.commentable_type.toLowerCase()}-comments").append (
        JST["templates/comment"]({
          comment: data.comment
          author: data.author
        })
      );
})