execute "apt update & upgrade" do
    user "root"
    command "apt update -y && apt upgrade -y"
end

package "curl" do
    action :install
end

execute "Add node.js Repository" do
    user "root"
    command "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
end