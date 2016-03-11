module: uuid-test-suite
synopsis: Test suite for the uuid library.

define test nil-uuid-test ()
  assert-equal(as(<uuid>, "00000000-0000-0000-0000-000000000000"), $nil-uuid);
  assert-equal(as(<string>, $nil-uuid), "00000000-0000-0000-0000-000000000000");
  assert-false(rfc4122-variant?($nil-uuid));
end test;

define test string-conversion-test ()
  let last-uuid = $nil-uuid;
  for (uuid-string in #["0C2F2F7A-E6BB-11E5-B9D5-53D6E97DB0C8",
                        "62803720-E6BB-11E5-AF9C-53D6E97DB0C8",
                        "6A932FBC-E6BB-11E5-80D9-53D6E97DB0C8",
                        "70445EE0-E6BB-11E5-9A8F-53D6E97DB0C8",
                        "80EE97A6-E6BB-11E5-B617-53D6E97DB0C8",
                        "8742DBEE-E6BB-11E5-8ACE-53D6E97DB0C8",
                        "9038D744-E6BB-11E5-B7E7-53D6E97DB0C8",
                        "55D0FB76-E6BC-11E5-8541-D181DC1050E5"])
    let uuid = as(<uuid>, uuid-string);
    assert-not-equal(uuid, last-uuid);
    assert-equal(uuid-string, as(<string>, uuid));
    assert-equal(uuid, as(<uuid>, as(<string>, uuid)));
    assert-equal(as(<string>, uuid), as(<string>, as(<uuid>, as(<string>, uuid))));
    last-uuid := uuid;

  end;
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
end suite;
