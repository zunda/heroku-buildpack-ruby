FROM fabiokung/cedar

RUN mkdir -p /tmp/.pack
RUN mkdir -p /tmp/.cache/heroku-buildpack-ruby
ADD . /tmp/.pack/heroku-buildpack-ruby
ONBUILD ADD . /app
ONBUILD RUN env CURL_TIMEOUT=600 /tmp/.pack/heroku-buildpack-ruby/bin/compile /app /tmp/.cache/heroku-buildpack-ruby
ONBUILD RUN ln -s /app/.profile.d/* /etc/profile.d/
ONBUILD ENV HOME /app
ONBUILD ENV PWD /app
ONBUILD ENV PORT 5000
ONBUILD EXPOSE 5000
