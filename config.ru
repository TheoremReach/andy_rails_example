# This file is used by Rack-based servers to start the application.
## Unicorn self-process killer


require_relative 'config/environment'

require 'unicorn/worker_killer'
#Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096

#Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (300*(1024**2))

run Rails.application
