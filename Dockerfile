FROM elixir:1.11.3-alpine AS build

RUN apk update && apk add python3-dev \
                        gcc \
                        libc-dev

# install build dependencies
RUN apk add --no-cache build-base npm git

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force 
RUN mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/foucault_pendulum/mix.exs apps/foucault_pendulum/mix.exs
COPY apps/foucault_pendulum_web/mix.exs apps/foucault_pendulum_web/mix.exs

COPY config config
RUN mix do deps.get, deps.compile
#RUN mix deps.get
#RUN mix deps.compile

# build assets
COPY apps/foucault_pendulum_web/assets/package.json apps/foucault_pendulum_web/assets/package-lock.json ./apps/foucault_pendulum_web/assets/
WORKDIR ./deps/phoenix
RUN npm link 
 
WORKDIR /app
RUN cd apps/foucault_pendulum_web/assets && npm link phoenix

RUN npm --prefix ./apps/foucault_pendulum_web/assets ci --progress=false --no-audit --loglevel=error

# COPY umbrella projects 
COPY apps/foucault_pendulum_web/priv apps/foucault_pendulum_web/priv
COPY apps/foucault_pendulum_web/assets apps/foucault_pendulum_web/assets
RUN npm run --prefix apps/foucault_pendulum_web/assets deploy
RUN cd apps/foucault_pendulum_web mix phx.digest

# compile and build release
COPY apps/foucault_pendulum/lib apps/foucault_pendulum/lib
COPY apps/foucault_pendulum_web/lib apps/foucault_pendulum_web/lib

# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/prod ./

ENV HOME=/app

CMD ["bin/foucault_pendulum", "start"]
