require "rspec"
require "./api_client"

describe APIClient do
  
  subject { APIClient.new("http://random.com", "test", "test")}

  let(:faraday_double) { double('faraday') }

  before(:each) { allow(Faraday).to receive(:new).with(url:"http://random.com").and_return(faraday_double) }

  describe "#create_agent" do
    context "when response status is 201, user is created" do
      before(:each) do
        expect(faraday_double).to receive(:post).and_return(double(status:201, body:'{"user":{"id":1}}'))
      end
      it { expect(subject.create_agent("name", "email")["id"]).to be_eql(1)}
    end
    context "when response status is not 201, user is not created" do
      before { expect(faraday_double).to receive(:post).and_return(double(status:400, body:'')) }
      it { expect(subject.create_agent("name", "email")).to be_eql(nil) }
    end
  end

  describe "#create_ticket" do
    context "when response status is 201, ticket is created" do
      before(:each) do
        expect(faraday_double).to receive(:post).and_return(double(status:201, body:'{"ticket":{"id":1}}'))
      end
      it { expect(subject.create_ticket("name", "email", "submitter_id","subject","body")["id"]).to be_eql(1)}
    end
    context "when ticket is not given a subject, ticket is not created" do
      before { expect(faraday_double).to receive(:post).and_return(double(status:400, body:'{"ticket":{"subject":null, "comment":{"body":null}}}')) }
      it { expect(subject.create_ticket("name", "email", "submitter_id","subject","body")["id"]).to be_eql(nil) }
    end
  end

  describe "#solve_ticket" do
    context "when response status is 200, ticket will be marked solved" do
      before(:each) do
        expect(faraday_double).to receive(:put).and_return(double(status:200, body:'{"ticket":{"status":"solved", "assignee_id":1}}'))
      end
      it { expect(subject.solve_ticket(1, 1)["status"]).to be_eql("solved")}
    end
  end
end
