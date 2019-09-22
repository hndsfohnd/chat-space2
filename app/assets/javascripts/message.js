$(function(){
  function buildHTML(message){
    message.image ? image = `<img src="${message.image}">` : image = ""
    var html = `
    <div class="message" data-id="${message.id}">
    <div class="contents__bottom1">
    ${message.name}
    <div class="contents__bottom1--data">${message.created_at}</div>
    </div>
    <div class="contents__bottom1--comments">
    
    ${message.content}

    ${image}
   </div>`
    return html;
  }
  $('#new_message').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
  })
  .done(function(message){
    var html = buildHTML(message);
    $('.contents__bottom').append(html)
    $("form").get(0).reset();
    $('.contents__input--sent').attr('disabled', false);
    $('.contents__bottom').animate({ scrollTop: $('.contents__bottom')[0].scrollHeight});
    return false
  })
  .fail(function(){
    alert('エラー');
  })

});
});