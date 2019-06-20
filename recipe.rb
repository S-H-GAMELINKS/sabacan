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
