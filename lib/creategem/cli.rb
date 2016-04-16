require 'thor'
require 'git'
require 'creategem'

# Creategem::CLI is a Thor class that is invoked when a user runs a creategem executable
module Creategem
  class CLI < Thor
    include Thor::Actions
    include Creategem::Git

    # there has to be a method gem_name to use gem_name in the file names in the template directory: %gem_name%
    attr_accessor :gem_name

    # this is where the thor generator templates are found
    def self.source_root
      File.expand_path('../../../templates', __FILE__)
    end

    desc "gem NAME", "Creates a new gem with a given NAME with Github git repository; Options: --private (Bitbucket/Geminabox), --no-executable"
    option :private, type: :boolean, default: false, desc: "When true, Bitbucket and Geminabox are used, otherwise Github and Rubygems are used (default)"
    option :executable, type: :boolean, default: true, desc: "When true, gem with executable is created"
    def gem(gem_name)
      say "Create a gem scaffold for gem named: #{gem_name}", :green
      @gem_name = gem_name
      @class_name = Thor::Util.camel_case(gem_name)
      @executable = options[:executable]
      vendor = options[:private] ? :bitbucket : :github
      @repository = Creategem::Repository.new(vendor: vendor,
                                              user: git_repository_user_name(vendor),
                                              name: gem_name,
                                              gem_server_url: gem_server_url(vendor))
      directory "gem_scaffold", gem_name
      if @executable
        directory "executable_scaffold", gem_name
      end
      if @repository.public?
        template "LICENCE.txt", "#{gem_name}/LICENCE.txt"
      end
      Dir.chdir gem_name do
        create_local_git_repository
        run "bundle install"
        create_remote_git_repository(@repository) if yes?("Do you want me to create #{vendor} repository named #{gem_name}? (y/n)")
      end
      say "The gem #{gem_name} was successfully created.", :green
      say "Please complete the information in #{gem_name}.gemspec and README.md (look for TODOs).", :blue
    end

    private

    def git_repository_user_name(vendor)
      git_config_key = "creategem.#{vendor}user"
      user = ::Git.global_config(git_config_key)
      if user.nil? || user.empty?
        user = ask("What is your #{vendor} user name?")
        ::Git.global_config(git_config_key, user)
      end
      user
    end

    def gem_server_url(vendor)
      if vendor == :github
        "https://rubygems.org"
      else
        git_config_key = "creategem.gemserver"
        url = ::Git.global_config(git_config_key)
        if url.nil? || url.empty?
          url = ask("What is the url of your geminabox server?")
          ::Git.global_config(git_config_key, url)
        end
        url
      end
    end
  end
end
