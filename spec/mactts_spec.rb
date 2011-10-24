require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'mactts'

describe Mac::TTS, "When using the class method" do
  before(:each) do
    @sample_text = "We ain't got no are spec!"
  end
  
  it "should say default text" do
    Mac::TTS.say(@sample_text).should == true
  end
  
  it "should say default text as alex" do
    Mac::TTS.say(@sample_text, :alex).should == true
  end
  
  it "should return the default export path if export flag = true" do
    default_export_path = Mac::TTS.new.export_path
    Mac::TTS.say(@sample_text, :alex, true).should == default_export_path
    File.exists?(default_export_path).should == true
    `rm #{default_export_path}`
  end
  
  it "should have an array of valid voices" do
    Mac::TTS.valid_voices.length.should > 0
  end
  
  it "should raise an error when an invalid voice is specified" do
    lambda { Mac::TTS.say(@sample_text, :beef)}.should raise_error(Mac::TTS::InvalidVoiceException)
  end
end

describe Mac::TTS, "When using an instantiated object" do
  before(:each) do
    @mactts = Mac::TTS.new
    @sample_text = "We ain't got no are spec!"  
  end
  
  it "should say default text" do
    @mactts.say(@sample_text).should == true
  end
  
  it "should say default text as alex" do
    @mactts.voice = :alex
    @mactts.say(@sample_text).should == true
  end
  
  it "should raise an error when an invalid voice is specified" do
    @mactts.voice = :beef
    lambda{ @mactts.say(@sample_text) }.should raise_error(Mac::TTS::InvalidVoiceException)
  end
  
  it "should raise an error when an invalid command is specified" do
    @mactts.voice = :fred
    @mactts.say_command = '/should/not/exist'
    lambda{ @mactts.say(@sample_text) }.should raise_error(Mac::TTS::SayCommandNotFoundException)
  end
  
  it "should return false if a valid command that is not say is specified" do
    @mactts.say_command = '/usr/bin/env'
    @mactts.say(@sample_text).should == false
  end
  
  it "should export a file in the export_path specified when it is set" do
    new_export_path = '/tmp/test.aiff'
    @mactts.export_path = new_export_path
    @mactts.say(@sample_text, true).should == new_export_path
    File.exists?(new_export_path).should == true
    `rm #{new_export_path}`
  end
end