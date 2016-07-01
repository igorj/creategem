require 'thor'

module Creategem
  module Git
    include Thor::Actions

    def create_local_git_repository
      say "Create local git repository", :green
      run "git init"
      run "git add ."
      run "git commit -aqm 'Initial commit'"
    end

    def create_remote_git_repository(repository)
      say "Create remote #{repository.vendor} repository", :green
      if repository.github?
        run "curl -u '#{repository.user}' https://api.github.com/user/repos -d '{\"name\":\"#{repository.name}\", \"private\":\"#{repository.private}\"}'"
      else # bitbucket
        run "curl --request POST --user #{repository.user} https://api.bitbucket.org/1.0/repositories/ --data name=#{repository.name} --data scm=git --data is_private=#{repository.private}"
      end
      run "git remote add origin #{repository.origin}"
      say "Push initial commit to remote #{repository.vendor} repository", :green
      run "git push -u origin master"
    end

    def git_repository_user_name(vendor)
      git_config_key = "creategem.#{vendor}user"
      user = ::Git.global_config(git_config_key)
      if user.nil? || user.empty?
        user = ask("What is your #{vendor} user name?")
        ::Git.global_config(git_config_key, user)
      end
      user
    end

    def gem_server_url(private)
      if private
        git_config_key = "creategem.gemserver"
        url = ::Git.global_config(git_config_key)
        if url.nil? || url.empty?
          url = ask("What is the url of your geminabox server?")
          ::Git.global_config(git_config_key, url)
        end
        url
      else
        "https://rubygems.org"
      end
    end
  end
end
