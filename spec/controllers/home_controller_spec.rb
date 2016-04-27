require 'rails_helper'

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

describe HomeController do
  render_views

  describe '#home' do
    it 'renders the homepage' do
      get :home
      response.body.should include "Integral Climate"
    end
  end

  describe '#throwup' do
    it 'raises an exception for testing' do
      expect{ get :throwup }.to raise_error(RuntimeError)
    end
  end
end
