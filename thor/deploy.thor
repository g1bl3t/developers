class Default
  desc 'deploy', 'Pull down changes and build the docs'
  def deploy
    log 'Getting docs changes...'
    system 'cd source && git pull git@github.com:Linode/docs.git master'

    log 'Building docs...'
    system 'bundle exec middleman build'
  end
end
