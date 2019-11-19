
  $(function(){
    function buildHTML(message){
      message.image ? image = `<img src="${message.image}">` : image = ""
      var html = `
      <div class="contents__bottom5" data-message-id ="${message.id}">
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
    .fail(function (){
      alert('error');
    });
  });
      var reloadMessages = function () {
      if (window.location.href.match(/\/groups\/\d+\/messages/)){
          var last_message_id = $('.contents__bottom5').last().data("message-id") ; //dataメソッドで.messageにある:last最後のカスタムデータ属性を取得しlast_message_idに代入。
          // var group_id = $(".group").data("group-id");
          $.ajax({ //ajax通信で以下のことを行う
            url: "api/messages", //サーバを指定。今回はapi/message_controllerに処理を飛ばす
            type: 'get', //メソッドを指定
            dataType: 'json', //データはjson形式
            data: {id: last_message_id} //飛ばすデータは先ほど取得したlast_message_id。またparamsとして渡すためlast_idとする。
          })
          .done(function (messages) { //通信成功したら、controllerから受け取ったデータ（messages)を引数にとる
            var insertHTML = '';//追加するHTMLの入れ物を作る
            messages.forEach(function (message) {//配列messagesの中身一つ一つを取り出し、HTMLに変換したものを入れ物に足し合わせる
            
              insertHTML = buildHTML(message); 
              //メッセージが入ったHTMLを取
              $('.contents__bottom').append(insertHTML);//メッセージを追加
              })
            $('.contents__bottom').animate({ scrollTop: $('.contents__bottom')[0].scrollHeight},'fast');//最新のメッセージが一番下に表示されようにスクロールする。
                })
  
          .fail(function () {
            alert('自動更新に失敗しました');//ダメだったらアラートを出す
          });  
      }; };
      setInterval(reloadMessages,5000);
    })
