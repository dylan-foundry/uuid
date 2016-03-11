=========================================================
Universally unique identifier (uuid) library for `Dylan`_
=========================================================
--------
Examples
--------

.. code:: dylan

  // Construct UUID from string
  let uuid = as(<uuid>, "F4BA786E-E6CD-11E5-9F37-E2AD61FECC63");

  // RFC 4122 variant UUIDs
  // v4: random UUID
  let random-uuid = make-uuid4();
  // v3: namespace & MD5 hash
  let md5-based-uuid = make-uuid3($namespace-url, "http://github.com/dylan-foundry/uuid");
  // v5: namespace & SHA-1 hash
  let sha1-based-uuid = make-uuid5($namespace-dns, "opendylan.org");


.. _Dylan: http://opendylan.org/
