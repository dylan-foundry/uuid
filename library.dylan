module: dylan-user

define library uuid
  use dylan;
  use common-dylan;
  use strings;
  use hash-algorithms;
  export uuid;
end library;

define module uuid
  use dylan;
  use strings;
  use common-dylan;
  use hash-algorithms;
  use byte-vector;
  use simple-random; // from common-dylan
  export <uuid>, make-uuid3, make-uuid4, make-uuid5,
    uuid-data, rfc4122-variant?,  rfc4122-version, $nil-uuid,
    $namespace-dns, $namespace-url, $namespace-iso-oid, $namespace-x500;
end module;

