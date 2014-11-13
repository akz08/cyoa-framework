require 'attr_encrypted'



class User < ActiveRecord::Base

	has_many :api_keys, dependent: :destroy

	attr_encrypted :fb_token, :key => ENV['ENCRYPT_KEY']
	attr_encrypted :email, :key => ENV['ENCRYPT_KEY']
	self.primary_key = "uid"

	# each user must have a Facebook uid and Facebook token on creation
	validates_presence_of :uid, :on => :create
	# validates_presence_of :fbtoken, :on => :create


end