require 'spec_helper'
require Grape.root.join('app/models/beer')
require Grape.root.join('spec/models/shared_examples/join_records')

describe Beer do
  it_behaves_like 'something that has join records'
end
