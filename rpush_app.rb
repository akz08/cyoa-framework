# # require 'rpush'

# app = Rpush::Gcm::App.new
# app.name = "android_app"
# app.auth_key = ""
# app.connections = 1
# app.save!

# n = Rpush::Gcm::Notification.new
# n.app = Rpush::Gcm::App.find_by_name("android_app")
# n.registration_ids = ["token", ""]
# n.data = { message: "hi mom!" }
# n.save!


require 'pushmeup'

GCM.host = 'https://android.googleapis.com/gcm/send'
    # https://android.googleapis.com/gcm/send is default

    GCM.format = :json
    # :json is default and only available at the moment

    GCM.key = ""
    # this is the apiKey obtained from here https://code.google.com/apis/console/

    destination = [""]
    # can be an string or an array of strings containing the regIds of the devices you want to send

    data = {:character => "Sam", :description => "A cool girl."}
    # must be an hash with all values you want inside you notification

    # GCM.send_notification( destination )
    # Empty notification

    GCM.send_notification( destination, data )
    # Notification with custom information

    # GCM.send_notification( destination, data, :collapse_key => "placar_score_global", :time_to_live => 3600, :delay_while_idle => false )
    # Notification with custom information and parameters