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
        run "curl -u '#{repository.user}' https://api.github.com/user/repos -d '{\"name\":\"#{repository.name}\"}'"
      else
        run "curl --request POST --user #{repository.user} https://api.bitbucket.org/1.0/repositories/ --data name=#{repository.name} --data scm=git --data is_private=true"
      end
      run "git remote add origin #{repository.origin}"
      say "Push initial commit to remote #{repository.vendor} repository", :green
      run "git push -u origin master"
    end
  end
end
