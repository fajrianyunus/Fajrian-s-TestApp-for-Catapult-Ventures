# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_TestApp_session',
  :secret      => 'e228531051e9d53b9bb806bbb6f42e8431c501d18b3e60819060605f0eb67b4d0ed7d4959f871034894eb1462933522b5e780ba0a707164a6036163f4b3b876e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
