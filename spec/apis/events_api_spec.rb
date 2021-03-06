require 'spec_helper'
require 'app/apis/api'

describe EventsAPI do
  def app
    Goodbrews::API
  end

  let(:context) do
    double.tap do |d|
      allow(d).to receive(:authorized?).and_return(false)
      allow(d).to receive(:params).and_return({})
    end
  end

  context '/events' do
    it 'returns an empty array' do
      get '/events'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('{"count":0,"events":[]}')
    end

    it 'returns a list of events as JSON' do
      event = Factory(:event)
      body = EventsPresenter.new(Event.all, context: context, root: nil).present

      get '/events'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(body.to_json)
    end
  end

  context '/events/:id' do
    context 'without an existing event' do
      it 'returns a 404' do
        get '/events/nothing-here'

        expect(last_response.status).to eq(404)
      end
    end

    context 'with an existing event' do
      let(:event) { Factory(:event) }

      it 'returns an existing event as json' do
        body = EventPresenter.present(event, context: context)

        get "/events/#{event.to_param}"

        expect(last_response.body).to eq(body.to_json)
      end

      context '/breweries' do
        it 'returns an empty array' do
          get "/events/#{event.to_param}/breweries"

          expect(last_response.body).to eq('{"count":0,"breweries":[]}')
        end

        it 'returns breweries as JSON' do
          event.breweries << Factory(:brewery)
          body = BreweriesPresenter.new(event.breweries.reload, context: context, root: nil).present

          get "/events/#{event.to_param}/breweries"
          expect(last_response.body).to eq(body.to_json)
        end
      end

      context '/beers' do
        it 'returns an empty array' do
          get "/events/#{event.to_param}/beers"

          expect(last_response.body).to eq('{"count":0,"beers":[]}')
        end

        it 'returns beers as JSON' do
          event.beers << Factory(:beer)
          body = BeersPresenter.new(event.beers.reload, context: context, root: nil).present

          get "/events/#{event.to_param}/beers"
          expect(last_response.body).to eq(body.to_json)
        end
      end
    end
  end
end
