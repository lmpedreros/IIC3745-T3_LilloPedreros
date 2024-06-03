require 'rails_helper'

RSpec.describe 'Products', type: :request do
  before do
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com',
                         role: 'admin')
    sign_in @user
    @product = Product.create!(nombre: 'John1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
  end
  describe 'GET /new' do
    it 'returns http success' do
      get '/products/index'
      expect(response).to have_http_status(:success)
    end
    it 'return http success without login' do
      sign_out @user
      get '/products/index'
      expect(response).to have_http_status(:success)
    end
  end
end
