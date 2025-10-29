#!/usr/bin/env ruby

require "bundler/setup"

require "foobara/load_dotenv"
Foobara::LoadDotenv.run!(dir: __dir__)

require "foobara/remote_imports"

class RequiresAuthCommand < Foobara::RemoteCommand
  def build_request_headers
    super.merge!("X-Api-Key" => ENV.fetch("COMMANDFORGE_API_KEY", nil))
  end
end

Foobara::RemoteImports::ImportCommand.run!(
  manifest_url: "http://localhost:3000/manifest",
  to_import: "Foobara::Commandforge::GetCurrentUser",
  base_command_class: RequiresAuthCommand,
  cache: true
)

outcome = Foobara::Commandforge::GetCurrentUser.run

if outcome.success?
  puts "Username is: #{outcome.result.username}"
else
  puts "Error: #{outcome.errors_sentence}"
end
