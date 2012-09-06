def install_cert(name, cert, chain=false)
  chain_str = chain ? '.chain' : ''
  cert_file = "#{name}#{chain_str}.crt"
  certs_dir = node['ssl']['certs_dir'].to_s
  file "#{File.join node['ssl']['certs_dir'], cert_file}" do
    owner 'root'
    group 'root'
    mode '0644'
    content cert
  end
end
