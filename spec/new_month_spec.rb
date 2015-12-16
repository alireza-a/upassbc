require 'spec_helper'
require 'date'
require 'tempfile'

describe "#new_month?" do
  let(:logfile) { Tempfile.new(['tempfile','.log']) }

  def write_to_file(month, last_line_info)
      logfile.write("[#{month}]  WARN -- : login failed! please check your username and password")
      logfile.write("[#{month}]  INFO -- : #{last_line_info}")
      logfile.flush
  end

  def is_new_month?(logfile, expected)
    is_new_month = new_month? logfile
    expect(is_new_month).to eq(expected)
  end

  context "when it is a new month to enrol for upass" do  
    before(:each) do
      previous_month = (Time.now.to_datetime << 1).to_time
      write_to_file previous_month, "success"
    end

    it "returns true" do
      is_new_month? logfile.path, true
    end
  end

  context "when already enrolled for upass in the current month" do
    before(:each) do
      current_month = Time.now
      write_to_file current_month, "success"
    end

    it "returns false" do
      is_new_month? logfile.path, false
    end
  end

  context "when have not enrolled for upass in the current month" do
    before(:each) do
      current_month = Time.now
      write_to_file current_month, "not available yet"
    end

    it "returns true" do
      is_new_month? logfile.path, true
    end
  end

  after(:each) do
    logfile.close!
  end
end
  
