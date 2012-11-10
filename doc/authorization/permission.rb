class User
  attr_accessor :email, :uid, :login, :full_name

  def initialize(uid = -1, email = "anonymous@i.pl", login = "anonymous")
    @email = email
    @login = login

    @uid = uid
  end

  def admin?
    uid == 1
  end
end

class Permission < Struct.new(:user)
  def allow?
    user && user.class == User && user.admin?
  end
end

a = User.new 1
aperm = Permission.new a
puts aperm.allow?

u = User.new
uperm = Permission.new u
puts uperm.allow?
