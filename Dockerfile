FROM fabiokung/heroku-buildpack-base

ONBUILD ADD . /app
ONBUILD RUN /var/lib/buildpack/bin/compile /app /var/cache/buildpack
ONBUILD ENV HOME /app
ONBUILD ENV PORT 5000
ONBUILD EXPOSE 5000
ONBUILD ENTRYPOINT ["/usr/bin/hkinit"]
ONBUILD CMD ["web"]
