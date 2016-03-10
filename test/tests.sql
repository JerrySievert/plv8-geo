CREATE OR REPLACE FUNCTION plv8_geo_tests ( ) RETURNS
json AS $$

// test statuses stored here
var test_statuses = [ ];
var current_test;

// assertion failure
function fail (actual, expected, message, operator) {
  test_statuses.push({
    actual:   actual,
    expected: expected,
    message:  message,
    operator: operator,
    status:  "fail",
    current: current_test
  });
}

// assertion ok
function ok (actual, expected, message) {
  test_statuses.push({
    actual:   actual,
    expected: expected,
    status:   "pass",
    message:  message,
    current: current_test
  });
}

// assert methods
var assert = {
  equal: function (actual, expected, message) {
    if (actual != expected) {
      fail(actual, expected, message, "==");
    } else {
      ok(actual, expected, message);
    }
  }
};


// test_setup is run before any tests run
// create the test collection
function test_setup ( ) {
  // code to execute at test_setup
}

// test_teardown is run after all tests have completed
// remove the collection
function test_teardown ( ) {
  // code to execute at test_teardown
}

// [todo] - more tests
// tests to run, setup is run first, then any tests
// teardown is run after the tests are run
var tests = [
  {
    setup: function ( ) {
      // setup function for this test
    },
    teardown: function ( ) {
      // teardown function for this test
    },
    'simplify polyline works on epsilon 50': function ( ) {
      var result = plv8.execute("SELECT simplify_polyline('[[150, 10], [200, 100], [360, 170], [500, 280]]'::json, 50)");
      assert.equal(result.length, 1, "the correct number of rows is returned");
      assert.equal(result[0].simplify_polyline.length, 2, "the correct number of segments is returned for epsilon 50");
    }
  },
  {
    setup: function ( ) {
      // setup function for this test
    },
    teardown: function ( ) {
      // teardown function for this test
    },
    'simplify polyline works on epsilon 20': function ( ) {
      var result = plv8.execute("SELECT simplify_polyline('[[150, 10], [200, 100], [360, 170], [500, 280]]'::json, 20)");
      assert.equal(result.length, 1, "the correct number of rows is returned");
      assert.equal(result[0].simplify_polyline.length, 4, "the correct number of segments is returned for epsilon 20");
    }
  },

];

test_setup();

// iterate through the tests, running each
for (var i = 0; i < tests.length; i++) {
  var test = tests[i];
  var keys = Object.keys(test).filter(function (item) {
    if (item === "setup" || item === "teardown") {
      return false;
    }

    return true;
  });

  // run the setup
  if (test.setup) {
    test.setup();
  }

  // run the tests
  for (var j = 0; j < keys.length; j++) {
    current_test = keys[j];
    test[keys[j]]();
  }

  // run the teardown
  if (test.teardown) {
    test.teardown();
  }
}

test_teardown();

return test_statuses;
$$ LANGUAGE plv8 IMMUTABLE STRICT;
