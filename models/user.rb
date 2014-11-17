require 'attr_encrypted'

class User < ActiveRecord::Base
	validates_presence_of :uid, :on => :create
	validates_presence_of :fb_token, :on => :create
	self.primary_key = "uid"
	
	attr_encrypted :fb_token, :key => ENV['ENCRYPT_KEY']
	attr_encrypted :email, :key => ENV['ENCRYPT_KEY']
end