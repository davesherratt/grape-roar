require 'spec_helper'

describe Grape::Roar do
  subject do
    Class.new(Grape::API)
  end

  before do
    subject.format :json
    subject.formatter :json, Grape::Formatter::Roar
  end

  def app
    subject
  end

  context "order" do
  
    before do

      subject.get("/order/:id") {

        order = Order.new({
          :id => params[:id],
          :client_id => 42
        })

        order.articles << Article.new({ :title => "One", :id => 1 })
        order.articles << Article.new({ :title => "Two", :id => 2 })

        order.to_json
      }

    end

    it 'returns a hypermedia representation' do
      get "/order/666"
      last_response.body.should == '{"id":"666","client_id":42,"articles":[{"title":"One","id":1,"links":[{"rel":"self","href":"/article/1"}]},{"title":"Two","id":2,"links":[{"rel":"self","href":"/article/2"}]}],"links":[{"rel":"self","href":"/order/666"},{"rel":"items","href":"/order/666/items"}]}'
    end

  end
end
