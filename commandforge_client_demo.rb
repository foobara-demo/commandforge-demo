#!/usr/bin/env ruby

require "bundler/setup"

require "foobara/load_dotenv"
Foobara::LoadDotenv.run!(dir: __dir__)

require "foobara/remote_imports"

Foobara::RemoteImports::ImportCommand.run!(
  manifest_url: "http://localhost:3000/manifest",
  to_import: "A::B::ComputeExponent",
  auth_header: [
    "x-api-key",
    -> { ENV.fetch("COMMANDFORGE_API_KEY", nil) }
  ],
  cache: true
)

puts A::B::ComputeExponent.run!(base: 2, exponent: 3)
