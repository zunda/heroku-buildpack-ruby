FROM fabiokung/heroku-buildpack-base

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q ruby2.0
# more stuff specific to this buildpack...

