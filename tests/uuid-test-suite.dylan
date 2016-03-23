module: uuid-test-suite
synopsis: Test suite for the uuid library.

define test nil-uuid-test ()
  assert-equal(as(<uuid>, "00000000-0000-0000-0000-000000000000"), $nil-uuid);
  assert-equal(as(<string>, $nil-uuid), "00000000-0000-0000-0000-000000000000");
  assert-false(rfc4122-variant?($nil-uuid));
end test;

define test string-conversion-test ()
  let last-uuid = $nil-uuid;
  for (uuid-string in #["0c2f2f7a-e6bb-11e5-b9d5-53d6e97db0c8",
                        "62803720-e6bb-11e5-af9c-53d6e97db0c8",
                        "6a932fbc-e6bb-11e5-80d9-53d6e97db0c8",
                        "70445ee0-e6bb-11e5-9a8f-53d6e97db0c8",
                        "80ee97a6-e6bb-11e5-b617-53d6e97db0c8",
                        "8742dbee-e6bb-11e5-8ace-53d6e97db0c8",
                        "9038d744-e6bb-11e5-b7e7-53d6e97db0c8",
                        "55d0fb76-e6bc-11e5-8541-d181dc1050e5"])
    let uuid = as(<uuid>, uuid-string);
    assert-not-equal(uuid, last-uuid);
    assert-equal(uuid-string, as(<string>, uuid));
    assert-equal(uuid, as(<uuid>, as(<string>, uuid)));
    assert-equal(as(<string>, uuid), as(<string>, as(<uuid>, as(<string>, uuid))));
    last-uuid := uuid;

  end;
end test;

define test uuid-hash-md5-test ()
  assert-equal("34ec88ab-c908-3140-acb0-99b0ffdcf005", as(<string>, make-uuid3($namespace-dns, "opendylan.org")));
  assert-equal("30a7dcc1-0de3-307f-b5b3-c7cbf222c2c0", as(<string>, make-uuid3($namespace-url, "http://opendylan.org/download/")));
  assert-equal("71e93411-721c-3bb1-8cc8-02eb81eb0042", as(<string>, make-uuid3($namespace-url, "https://github.com/dylan-foundry/uuid")));
end test;

define test uuid-hash-sha1-test ()
  assert-equal("1765865c-c208-5ba1-aebf-988a23206d0a", as(<string>, make-uuid5($namespace-dns, "opendylan.org")));
  assert-equal("76c84493-6ee9-549b-ba5f-23b7f7a0adf9", as(<string>, make-uuid5($namespace-url, "http://opendylan.org/download/")));
  assert-equal("e4a0a1d0-1200-57d7-92f3-9715e989ba33", as(<string>, make-uuid5($namespace-url, "https://github.com/dylan-foundry/uuid")));
end test;

define test random-uuid-test ()
  for (i from 0 to 100)
    let uuid = make-uuid4();
    assert-true(rfc4122-variant?(uuid));
    assert-equal(rfc4122-version(uuid), 4);
    assert-equal('4', as(<string>, uuid)[14]);
  end;
end test;

define suite uuid-test-suite ()
  test nil-uuid-test;
  test string-conversion-test;
  test random-uuid-test;
  test uuid-hash-md5-test;
  test uuid-hash-sha1-test;
end suite;
