module: uuid-test-suite
synopsis: Test suite for the uuid library.

define test simple-test ()
  assert-true(#t);
end test;

define suite uuid-test-suite ()
  test simple-test;
end suite;
