# knife_inspec.rb - An example of a possible knife plugin to run inspec against a search query.
#
# Author: Jerry Qassar (jqassar @GitHub)
# Repository: https://github.com/jqassar/knife_inspec
#
# Installation:
# The easiest way to install this is to place the knife_inspec.rb file in your
# ~/.chef/knife/plugins directory.  Make any necessary changes (there will be some) and give
# it a try.  The plugin as it stands makes lots of assumptions about how connections are made
# and these assumptions will more than likely not hold for your environment.

require 'chef/knife'

module ModuleName

  class Inspec < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'mixlib/shellout'
    end

    banner "knife inspec <QUERY> <COMMAND>"

    option :query,
      :short => "-q QUERY",
      :long => "--query QUERY",
      :description => "The query to use when searching for nodes to InSpec(t).  Defaults to '*'.",
      :default => "*"

    option :command,
      :short => "-c COMMAND",
      :long => "--command COMMAND",
      :description => "The Inspec command to run.  Defaults to 'detect'.",
      :default => "detect"

    option :user,
      :short => "-u USER",
      :long => "--user USER",
      :description => "The user that will SSH to the target machines.  Defaults to 'chef'.",
      :default => "chef"

    option :keyfile,
      :short => "-k KEYFILE",
      :long => "--keyfile KEYFILE",
      :description => "The location of the keyfile used for InSpec.  Defaults to ~/.ssh/id_dsa.",
      :default => "~/.ssh/id_dsa"

    def run
      query_nodes = Chef::Search::Query.new

      query_nodes.search('node', config[:query]) do |node_item|
        puts "==> Running #{config[:command]} on #{node_item.name}..."
        inspec_cmd = Mixlib::ShellOut.new("inspec #{config[:command]} --key-files=#{config[:keyfile]} -t ssh://#{config[:user]}@#{node_item.name}")
        inspec_cmd.run_command
        # This doesn't handle errors.
        puts inspec_cmd.stdout
        # This does.
        inspec_cmd.error!
      end
    end

  end
end
