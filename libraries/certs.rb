require 'openssl'

def install_cert(name, cert, options={})
  ca = options[:ca]
  chain = options[:chain]

  suffix = ''
  suffix = '-ca' if ca
  suffix = '.chain' if chain
  cert_file = "#{name}#{suffix}.crt"

  cert_filename = File.join(node['ssl']['certs_dir'].to_s, cert_file)

  link cert_filename do
    owner 'root'
    group 'root'
    mode 00644
    target_file File.join(node['ssl']['certs_dir'].to_s, OpenSSL::X509::Certificate.new(cert).subject.hash.to_s(16) + '.0')
    to cert_filename
    action :nothing
    only_if { ca }
  end

  file cert_filename do
    owner 'root'
    group 'root'
    mode '0644'
    content cert
    notifies :create, "link[#{cert_filename}]"
  end
end
