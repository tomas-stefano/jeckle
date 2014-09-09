
%w(no_such_api_error no_username_or_password_error).each do |file_name|
  require "jeckle/exceptions/#{file_name}"
end
