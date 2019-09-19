require 'rails_helper'

describe Message do
  describe '#create' do

    it "メッセージがあれば保存できる" do
      message = build(:message, image: nil)#buildでmessageのインスタンスを作成（ファクトリーで定義済み）して、image（Fakerで作ったimageの上書き）がないインスタンスを生成して（メッセージだけ）登録できるか確認
      expect(message).to be_valid
    end
    it "画像があれば保存できる" do #imageバージョン、上と同様
      message = build(:message, content: nil)
      expect(message).to be_valid
    end
    it "メッセージと画像があれば保存できる" do #ファクトリーでデフォルトの値が定義されているので、build(:message)と記述するだけで、メッセージと画像を持ったインスタンスを生成することができる。
      message = build(:message)
      expect(message).to be_valid
    end

 #保存できない場合のパターン

    it 'メッセージも画像も無いと保存できない' do
      message = build(:message, content: nil, image: nil)
      message.valid? #valid?メソッドを利用したインスタンスに対して、errorsメソッドを使用することによって、バリデーションにより保存ができない状態である場合なぜできないのかを確認することができる
      expect(message.errors[:content]).to include('を入力してください')
    end
    it "group_idが無いと保存できない" do
      message = build(:message, group_id:"")
      message.valid?
      expect(message.errors[:group]).to include("を入力してください")
    end
    it "user_idが無いと保存できない" do
      message = build(:message, user_id:"")
      message.valid?
      expect(message.errors[:user]).to include("を入力してください")
    end




  end
end