execute "create mastodon user" do
    user "root"
    command "adduser mastodon"
end

execute "apt update & upgrade" do
    user "root"
    command "apt update && apt upgrade"
end

package "curl" do
    action :install
end

execute "download node pkg & add" do
    user "root"
    command "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
end
