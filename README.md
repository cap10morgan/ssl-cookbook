DESCRIPTION
===========

A recipe for setting up system-wide SSL certs on Ubuntu / Debian systems.

REQUIREMENTS
============

Ubuntu or Debian Linux system and an encrypted data bag named "ssl".

ATTRIBUTES
==========

```ruby
node['ssl']['certs_dir'] = '/etc/ssl/certs'
node['ssl']['keys_dir']  = '/etc/ssl/keys'
node['ssl']['group']     = 'ssl-cert'
node['ssl']['domain']     = '*'
```

USAGE
=====

The certs and keys are retrieved from an encrypted data bag named "ssl". Inside
the data bag, the cert should be in a key named "cert", the domain name should
be in the "id" key, with periods replaced by underscores
(i.e. foo.com -> foo_com), the cert's key should be in "key", and if you have a
chain of certs to validate your domain's cert, put them in an array under
"chain" and the recipe will set them up for you. If you have a local CA, you can
store that in a key named "ca", and the recipe will install and symlink it in the
`certs_dir`.

**NOTE**: The certs and keys should all be on one line, with their newlines replaced
by "\n". They will be stored correctly once placed on the server.

Sample way to generate the data bag:

`bundle exec knife solo data bag create ssl -d --data-bag-path data_bags -j '{"id":"caregeneral_com", "key":"private_key_of_caregeneral","cert":"certificate","chain":["cert", "cert"]}'`

A sample data bag options `data_bags\keys\domain_com.json`:

```json
{
  "name":"data_bag_item_ssl_domain_com",
  "json_class":"Chef::DataBagItem",
  "chef_type":"data_bag_item",
  "data_bag":"ssl",
  "raw_data":
  {
    "id":"domain_com_staging",
    "key":"-----BEGIN RSA PRIVATE KEY-----\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n-----END RSA PRIVATE KEY-----",
    "cert":"-----BEGIN CERTIFICATE-----\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n-----END CERTIFICATE-----",
    "chain":[
      "-----BEGIN CERTIFICATE-----\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n-----END CERTIFICATE-----",
      "-----BEGIN CERTIFICATE-----\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\n-----END CERTIFICATE-----"
    ]
  }
}

```


After running the default recipe, your certs will be in
`/etc/ssl/certs/{domain.name}.crt`, and the
keys will be in `/etc/ssl/private/{domain.name}.key`. Any chain certs will be
combined into `/etc/ssl/certs/{domain.name}.chain.crt` and the whole cert chain
will be put into `/etc/ssl/certs/{domain.name}.combined.crt`. The separate chain
cert is for Apache, and the combined one is for Nginx. A CA cert will be stored
as `/etc/ssl/certs/{domain.name}-ca.crt`, however you can put the CA in a data bag
of it's own if you'd prefer a different prefix than `domain.name`.
