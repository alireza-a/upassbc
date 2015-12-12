require 'spec_helper'
require 'open-uri'

describe "#can_be_reached?" do  
    it "should not throw an error when connection fails" do
      expect { can_be_reached? 1, 'http://invalidUrl123.com', 1 }.to_not raise_error
    end
end
