class TestService < ApplicationService
  def initialize(msg)
    @msg = msg
  end

  def call
    TestService.error_message = @msg
  end
end

class SecondService < TestService
end

RSpec.describe ApplicationService do
  describe "error_message" do
    let(:expected_message) { "hello" }

    it "should have a nil error message initially" do
      expect(TestService.error_message).to be_nil
    end

    it "should save one error message after a call" do
      TestService.call(expected_message)

      expect(TestService.error_message).to eq(expected_message)
    end

    it "reset_error_message should reset the error message to nil" do
      TestService.call(expected_message)
      TestService.reset_error_message

      expect(TestService.error_message).to be_nil
    end

    it "after two calls, only second message is reported" do
      TestService.call("first message")
      TestService.call(expected_message)

      expect(TestService.error_message).to eq(expected_message)
    end

    it "should store messages separately for different service classes" do
      TestService.call("first message")

      expect(SecondService.error_message).to be_nil
    end

    it "should store messages separately for different threads" do
      Thread.new { TestService.call("other thread") }.join
      TestService.call(expected_message)

      expect(TestService.error_message).to eq(expected_message)
    end
  end
end
