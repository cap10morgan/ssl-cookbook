DESCRIPTION
===========

A recipe for setting up system-wide SSL certs on Ubuntu / Debian systems.

REQUIREMENTS
============

Ubuntu or Debian Linux system and an encrypted data bag named "ssl" (or customized in node['ssl']['data_bag']).

ATTRIBUTES
==========

    node['ssl']['certs_dir'] = '/etc/ssl/certs'
    node['ssl']['keys_dir']  = '/etc/ssl/keys'
    node['ssl']['group']     = 'ssl-cert'
    node['ssl']['data_bag']  = 'ssl'
    node['ssl']['data_bag_query']  = '*:*'

USAGE
=====

The certs and keys are retrieved from an encrypted data bag named "ssl". Inside
the data bag, the cert should be in a key named "cert", the domain name should
be in the "id" key, with periods replaced by underscores
(i.e. foo.com -> foo_com), the cert's key should be in "key", and if you have a
chain of certs to validate your domain's cert, put them in an array under
"chain" and the recipe will set them up for you.

**NOTE**: The certs and keys should all be on one line, with their newlines replaced
by "\n". They will be stored correctly once placed on the server.

After running the default recipe, your certs will be in
/etc/ssl/certs/{domain.name}.crt, and the
keys will be in /etc/ssl/private/{domain.name}.key. Any chain certs will be
combined into /etc/ssl/certs/{domain.name}.chain.crt and the whole cert chain
will be put into /etc/ssl/certs/{domain.name}.combined.crt. The separate chain
cert is for Apache, and the combined one is for Nginx.
