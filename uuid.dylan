Module: uuid

define class <uuid> (<object>)
  constant slot uuid-data :: limited(<byte-vector>, size: 16), required-init-keyword: data:;
end class;

define method as(class == <string>, uuid :: <uuid>) => (res :: <string>)
  local method h (byte :: <byte>) => (str :: <byte-string>)
          as-lowercase(integer-to-string(byte, base: 16, size: 2))
        end;
  let uu = uuid.uuid-data;
  concatenate(
              h(uu[0]), h(uu[1]), h(uu[2]), h(uu[3]), "-",
              h(uu[4]), h(uu[5]), "-",
              h(uu[6]), h(uu[7]), "-",
              h(uu[8]), h(uu[9]), "-",
              h(uu[10]), h(uu[11]), h(uu[12]), h(uu[13]), h(uu[14]),
              h(uu[15]))
end;

define method as(class == <uuid>, string :: <string>) => (res :: <uuid>)
  let sanitized-string = replace-substrings(string, "-", "");
  assert(sanitized-string.hexadecimal-digit?, "UUID string contains invalid characters");
  assert(sanitized-string.size == 32, "UUID string should be 32 characters long (excluding dashes)");

  let uuid-data = make(<byte-vector>, size: 16);
  for ( i :: <integer> from 0 below 16 )
    let byte = copy-sequence(sanitized-string, start: i * 2, end: i * 2 + 2);
    uuid-data[i] := as(<byte>, string-to-integer(byte, base: 16));
  end;

  make(<uuid>, data: uuid-data)
end;

define constant $nil-uuid          = make(<uuid>, data: make(<byte-vector>, size: 16, fill: 0));
define constant $namespace-dns     = as(<uuid>, "6ba7b810-9dad-11d1-80b4-00c04fd430c8");
define constant $namespace-url     = as(<uuid>, "6ba7b811-9dad-11d1-80b4-00c04fd430c8");
define constant $namespace-iso-oid = as(<uuid>, "6ba7b812-9dad-11d1-80b4-00c04fd430c8");
define constant $namespace-x500    = as(<uuid>, "6ba7b814-9dad-11d1-80b4-00c04fd430c8");

define method make-uuid3(namespace :: <uuid>, name :: <string>) => (uuid :: <uuid>)
  let uuid-data = make-uuid-data-with-hash(namespace, name, md5);
  set-rfc4122-bits(uuid-data, #x30);
  make(<uuid>, data: uuid-data);
end;

define method make-uuid4() => (uuid :: <uuid>)
  let uuid-data = make(<byte-vector>, size: 16);
  for ( i :: <integer> from 0 below 16 )
    element-setter(random(255), uuid-data, i);
  end;
  set-rfc4122-bits(uuid-data, #x40);
  make(<uuid>, data: uuid-data);
end;

define method make-uuid5(namespace :: <uuid>, name :: <string>) => (uuid :: <uuid>)
  let uuid-data = make-uuid-data-with-hash(namespace, name, sha1);
  set-rfc4122-bits(uuid-data, #x50);
  make(<uuid>, data: uuid-data);
end;

define method \=(uuid1 :: <uuid>, uuid2 :: <uuid>) => (res :: <boolean>)
  uuid1.uuid-data = uuid2.uuid-data
end;

define method rfc4122-variant?(uuid :: <uuid>) => (res :: <boolean>)
  logand(#x80, uuid.uuid-data[8]) = #x80;
end;

define method rfc4122-version(uuid :: <uuid>) => (res :: <integer>)
  ash(logand(uuid.uuid-data[6], #xF0), -4);
end;

/// Helper methods beyond this line, not exported

define method make-uuid-data-with-hash(namespace :: <uuid>, name :: <string>, hash :: <function>)
  => (data :: limited(<byte-vector>, size: 16))
  let payload = concatenate(namespace.uuid-data, as(<byte-vector>, name));
  let digest = hash(payload);
  copy-sequence(digest, start: 0, end: 16);
end;

define method set-rfc4122-bits(data :: <byte-vector>, version :: <integer>)
  data[6] := logior(version, logand(#x0F, data[6]));
  data[8] := logior(#x80, logand(#x3F, data[8]));
end;
