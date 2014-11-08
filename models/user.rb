require 'bcrypt'

class User < ActiveRecord::Base
	include BCrypt

	self.primary_key = "uid"

	# each user must have a Facebook uid and Facebook token on creation
	validates_presence_of :uid, :on => :create
	validates_presence_of :fb_token, :on => :create


end