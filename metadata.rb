maintainer       "Wes Morgan"
maintainer_email "cap10morgan@gmail.com"
license          "Apache 2.0"
description      "Sets up SSL certs and keys from an encrypted data bag"
version          "1.0.7"

recipe "ssl", "Sets up SSL certs for web servers & whatever else needs them"

%w{ ubuntu debian }.each do |os|
  supports os
end
