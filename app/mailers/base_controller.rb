class BaseMailer < ActionMailer::Base
  default from: "no-reply@apibootstraper.com"
  layout 'mail' # use mail.(html|text).erb as the layout
end
