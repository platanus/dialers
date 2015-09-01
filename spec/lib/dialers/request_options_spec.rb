require "dialers/request_options"

describe Dialers::RequestOptions do
  subject { described_class.new }

  it { should respond_to(:url) }
  it { should respond_to(:http_method) }
  it { should respond_to(:query_params) }
  it { should respond_to(:payload) }
  it { should respond_to(:headers) }
  it { should satisfy { |o| o.query_params == {} } }
  it { should satisfy { |o| o.payload == {} } }
  it { should satisfy { |o| o.headers == {} } }
end
