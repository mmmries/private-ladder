class Session
  include Mongoid::Document
  attr_accessor :username
  attr_accessor :password
end
