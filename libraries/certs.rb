def install_cert(name, cert, chain=false)
  chain_str = chain ? '.chain' : ''
  cert_file = "#{name}#{chain_str}.crt"
  certs_dir = node['ssl']['certs_dir'].to_s
  template "#{File.join node['ssl']['certs_dir'], cert_file}" do
    source "cert.erb"
    owner 'root'
    group 'root'
    mode '0644'
    variables :cert => cert
  end
end
