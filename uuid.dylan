Module: uuid

define class <uuid> (<object>)
  constant slot uuid-data :: limited(<byte-vector>, size: 16), required-init-keyword: data:;
end class;

define constant $nil-uuid          = make(<uuid>, data: make(<byte-vector>, size: 16, fill: 0));
define constant $namespace-dns     = as(<uuid>, "6ba7b810-9dad-11d1-80b4-00c04fd430c8");
define constant $namespace-url     = as(<uuid>, "6ba7b811-9dad-11d1-80b4-00c04fd430c8");
define constant $namespace-iso-oid = as(<uuid>, "6ba7b812-9dad-11d1-80b4-00c04fd430c8");
define constant $namespace-x500    = as(<uuid>, "6ba7b812-9dad-11d1-80b4-00c04fd430c8");

define method make-uuid3(namespace :: <uuid>, name :: <string>) => (uuid :: <uuid>)
  let uuid-data = make-uuid-data-with-hash(namespace, name, md5);
  set-rfc4122-bits(uuid-data, 3);
  make(<uuid>, data: uuid-data);
end;

define method make-uuid4() => (uuid :: <uuid>)
  let uuid-data = make(<byte-vector>, size: 16);
  for ( i :: <integer> from 0 below 16 )
    element-setter(random(255), uuid-data, i);
  end;
  set-rfc4122-bits(uuid-data, 4);
  make(<uuid>, data: uuid-data);
end;

define method make-uuid5(namespace :: <uuid>, name :: <string>) => (uuid :: <uuid>)
  let uuid-data = make-uuid-data-with-hash(namespace, name, sha1);
  set-rfc4122-bits(uuid-data, 5);
  make(<uuid>, data: uuid-data);
end;

define method \=(uuid1 :: <uuid>, uuid2 :: <uuid>) => (res :: <boolean>)
  uuid1.uuid-data = uuid2.uuid-data
end;

define method rfc4122-variant?(uuid :: <uuid>) => (res :: <boolean>)
  logand(#x80, uuid.uuid-data[9]) = #x80;
end;

define method rfc4122-version(uuid :: <uuid>) => (res :: <integer>)
  uuid.uuid-data[7];
end;

define method as(class == <string>, uuid :: <uuid>) => (res :: <string>)
  concatenate-as(<string>, map(method (num)
                                 integer-to-string(num, base: 16)
                               end, uuid.uuid-data));
end;

define method as(class == <uuid>, string :: <string>) => (res :: <uuid>)
  let sanitized-string = replace-substrings(string, "-", "");
  assert(sanitized-string.hexadecimal-digit?, "UUID string contains invalid characters");
  assert(sanitized-string.size == 32, "UUID string should be 32 characters long (excluding dashes)");

  let uuid-data = make(<byte-vector>, size: 16);
  for ( i :: <integer> from 0 below 16 )
    let byte = copy-sequence(sanitized-string, start: i, end: i + 2);
    uuid-data[i] := as(<byte>, string-to-integer(byte, base: 16));
  end;

  make(<uuid>, data: uuid-data)
end;

/// Helper methods beyond this line, not exported

define method make-uuid-data-with-hash(namespace :: <uuid>, name :: <string>, hash :: <function>)
  => (data :: limited(<byte-vector>, size: 16))
  let payload = concatenate(as(<string>, namespace), name);
  let digest = hash(payload);
  copy-sequence(digest, start: 0, end: 16);
end;

define method set-rfc4122-bits(data :: <byte-vector>, version :: <integer>)
  data[7] := as(<byte>, version);
  data[9] := logior(#x80, logand(#x3F, data[9]));
end;
