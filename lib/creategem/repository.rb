# Creategem::Repository contains informations about the git repository and the git user
module Creategem
  class Repository
    REPOSITORIES = { github: "github.com", bitbucket: "bitbucket.org" }

    attr_reader :vendor, :name, :user, :user_name, :user_email, :gem_server_url

    def initialize(options)
      @vendor = options[:vendor]
      @name = options[:name]
      @user = options[:user]
      @user_name = ::Git.global_config "user.name"
      @user_email = ::Git.global_config "user.email"
      @gem_server_url = options[:gem_server_url]
    end

    def github?
      vendor == :github
    end

    def bitbucket?
      vendor == :bitbucket
    end

    # this could change later. For now all private repositories are on bitbucket and all private ones on github
    def private?
      bitbucket?
    end

    def public?
      !private?
    end

    def url
      "https://#{REPOSITORIES[vendor]}/#{user}/#{name}"
    end

    def origin
      "git@#{REPOSITORIES[vendor]}:#{user}/#{name}.git"
    end
  end
end
