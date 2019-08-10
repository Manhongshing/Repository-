require 'mixpanel-ruby'

$tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
