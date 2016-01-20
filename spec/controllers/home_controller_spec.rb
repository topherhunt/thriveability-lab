require 'rails_helper'

describe HomeController do
  render_views

  describe '#home' do
    it 'renders the homepage' do
      get :home
      expect(response.body).to include 'Welcome to IntegralClimateAction!'
    end
  end

  describe '#throwup' do
    it 'raises an exception for testing' do
      expect{ get :throwup }.to raise_error(RuntimeError)
    end
  end
end
