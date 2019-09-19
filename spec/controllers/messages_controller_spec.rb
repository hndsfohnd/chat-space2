require 'rails_helper'
describe MessagesController do
  let(:group) { create(:group) }
  let(:user) { create(:user) }
    context 'log in' do
      before do
        login user
        get :index, params: { group_id: group.id }
      end

      it 'assigns @message' do #→assignsメソッド コントローラーのテスト時、アクションで定義しているインスタンス変数をテストするためのメソッド。引数に、直前でリクエストしたアクション内で定義されているインスタンス変数をシンボル型で取る。
        expect(assigns(:message)).to be_a_new(Message) #→be_a_newマッチャを利用することで、 対象が引数で指定したクラスのインスタンスかつ未保存のレコードであるかどうか確かめることができます。今回の場合は、assigns(:message)がMessageクラスのインスタンスかつ未保存かどうかをチェックしています。
      end

      it 'assigns @group' do
        expect(assigns(:group)).to eq group #→上記letで作ったgroupと同じかを確認する。
      end

      it 'redners index' do
        expect(response).to render_template :index #→expectの引数にresponseを渡す。responseは、example内でリクエストが行われた後の遷移先のビューの情報を持つインスタンス。 render_templateマッチャは引数にアクション名を取り、引数で指定されたアクションがリクエストされた時に自動的に遷移するビューを返す。この二つを合わせることによって、example内でリクエストが行われた時の遷移先のビューが、indexアクションのビューと同じかどうか確かめることができます。
      end
      describe '#create' do

      end
    end

    context 'not log in' do
      before do
        get :index, params: { group_id: group.id }
      end

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  
    describe '#create' do
      let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }
  
      context 'log in' do
        before do
          login user
        end
  
        context 'can save' do
          subject {
            post :create,
            params: params
          }
  
          it 'count up message' do
            expect{ subject }.to change(Message, :count).by(1)
          end
  
          it 'redirects to group_messages_path' do
            subject
            expect(response).to redirect_to(group_messages_path(group.id))
          end
        end
  
        context 'can not save' do
          let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }
  
          subject {
            post :create,
            params: invalid_params
          }
  
          it 'does not count up' do
            expect{ subject }.not_to change(Message, :count)
          end
  
          it 'renders index' do
            subject
            expect(response).to render_template :index
          end
        end
      end
  
      context 'not log in' do
  
        it 'redirects to new_user_session_path' do
          post :create, params: params
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end