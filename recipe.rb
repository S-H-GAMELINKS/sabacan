execute "apt update" do
    command "apt update -y"
end

execute "apt upgrade" do
    command "apt upgrade -y"
end

package "fail2ban"
package "vim"

execute "edit fail2ban conf" do
    command "vim /etc/fail2ban/jail.local"
end

execute "restart fail2ban" do
    command "systemctl restart fail2ban"
end

package "iptables-persistent"

execute "edit iptables conf" do
    command "vim /etc/iptables/rules.v4"
end

execute "load iptables conf" do
    command "iptables-restore < /etc/iptables/rules.v4"
end

package "curl"

execute "download Node.js" do
    command "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
end

execute "download yarn" do
    command "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -"
end

execute "add yarn to apt list" do
    command "echo \"deb https://dl.yarnpkg.com/debian/ stable main\" | tee /etc/apt/sources.list.d/yarn.list"
end

execute "apt update" do
    command "apt update -y"
end

package "imagemagick"
package "ffmpeg"
package "libpq-dev" 
package "libxml2-dev" 
package "libxslt1-dev" 
package "file"
package "git-core"
package "g++"
package "libprotobuf-dev"
package "protobuf-compiler" 
package "pkg-config"
package "nodejs"
package "gcc"
package "autoconf"
package "bison"
package "build-essential" 
package "libssl-dev"
package "libyaml-dev" 
package "libreadline6-dev"
package "zlib1g-dev"
package "libncurses5-dev" 
package "libffi-dev"
package "libgdbm5"
package "libgdbm-dev"
package "nginx"
package "redis-server" 
package "redis-tools"
package "postgresql"
package "postgresql-contrib"
package "certbot"
package "python-certbot-nginx"
package "yarn"
package "libidn11-dev" 
package "libicu-dev"
package "libjemalloc-dev"

execute "create mastodon user" do
    command "adduser --disabled-login mastodon"
end

execute "install rbenv" do
    user "mastodon"
    command "git clone https://github.com/rbenv/rbenv.git ~/.rbenv && 
            cd ~/.rbenv && src/configure && make -C src && 
            echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bashrc && 
            echo 'eval \"$(rbenv init -)\"' >> ~/.bashrc && 
            git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build"
end

execute "install ruby" do
    user "mastodon"
    command "RUBY_CONFIGURE_OPTS=--with-jemalloc rbenv install 2.6.1 && rbenv global 2.6.1"
end

execute "update rubygems" do
    user "mastodon"
    command "gem update --system"
end

execute "install bundler" do
    user "mastodon"
    command "gem install bundler --no-document"
end

execute "create database in postgresql" do
    user "postgres"
    command "psql"
end

execute "set up Mastodon" do
    user "mastodon"
    command "git clone https://github.com/tootsuite/mastodon.git live && cd live &&
            git checkout $(git tag -l | grep -v 'rc[0-9]*$' | sort -V | tail -n 1) &&
            bundle install -j$(getconf _NPROCESSORS_ONLN) --deployment --without development test &&
            yarn install --pure-lockfile && 
            RAILS_ENV=production bundle exec rake mastodon:setup"
end

execute "copy Mastodon conf" do
    command "cp /home/mastodon/live/dist/nginx.conf /etc/nginx/sites-available/mastodon &&
            ln -s /etc/nginx/sites-available/mastodon /etc/nginx/sites-enabled/mastodon"
end

execute "edit Mastodon domain" do
    command "vim /etc/nginx/sites-enabled/mastodon"
end

execute "reload nginx" do
    command "systemctl reload nginx"
end

execute "run cerbot for domain" do
    command "certbot --nginx -d example.com"
end

execute "copy to Mastodon service conf" do
    command "cp /home/mastodon/live/dist/mastodon-*.service /etc/systemd/system/"
end

execute "enable Mastodon service's" do
    command "systemctl start mastodon-web mastodon-sidekiq mastodon-streaming"
end

execute "start Mastodon service's" do
    command "systemctl enable mastodon-*"
end