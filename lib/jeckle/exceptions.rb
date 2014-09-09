
%w(no_such_api_error no_username_or_password_error).each do |file|
  require "jeckle/exceptions/#{file}"
end
