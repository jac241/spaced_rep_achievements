web: RUBY_YJIT_ENABLE=1 bundle exec rails server
acgrpc: RUBY_YJIT_ENABLE=1 bundle exec anycable
acws: anycable-go --host 0.0.0.0 --rpc_host sra.acgrpc:5000 --enable_ws_compression
worker: RUBY_YJIT_ENABLE=1 bundle exec sidekiq
release: bin/rails db:migrate:with_data
