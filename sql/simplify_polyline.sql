CREATE OR REPLACE FUNCTION simplify_polyline (polyline JSON, epsilon NUMERIC)
RETURNS JSON AS $$

function perpendicularDistance (ptX, ptY, l1x, l1y, l2x, l2y) {
  var result = 0;
  if (l2x === l1x) {
    //vertical lines - treat this case specially to avoid divide by zero
    result = Math.abs(ptX - l2x);
  } else {
    var slope = ((l2y - l1y) / (l2x - l1x));
    var passThroughY = (0 - l1x) * slope + l1y;
    result = (Math.abs((slope * ptX) - ptY + passThroughY)) / (Math.sqrt(slope * slope + 1));
  }

  return result;
}

function RamerDouglasPeucker (pointList, epsilon) {
  // Find the point with the maximum distance
  var dmax = 0;
  var index = 0;
  var totalPoints = pointList.length;

  for (var i = 1; i < (totalPoints - 1); i++) {
    var d = perpendicularDistance(pointList[i][0], pointList[i][1],
                                  pointList[0][0], pointList[0][1],
                                  pointList[totalPoints - 1][0],
                                  pointList[totalPoints - 1][1]);

    if (d > dmax) {
      index = i;
      dmax = d;
    }
  }

  var resultList = [ ];

  // If max distance is greater than epsilon, recursively simplify
  if (dmax >= epsilon) {
    // Recursive call
    var recResults1 = RamerDouglasPeucker(pointList.slice(0, index + 1), epsilon);
    var recResults2 = RamerDouglasPeucker(pointList.slice(index, totalPoints - index + 1), epsilon);

    // Build the result list
    resultList = recResults1.concat(recResults2.slice(1));
  } else {
    resultList = [ pointList[0], pointList[totalPoints - 1] ];
  }

  // Return the result
  return resultList;
}

if (epsilon === 0) {
  return polyline;
}

return RamerDouglasPeucker(polyline, epsilon);

$$ LANGUAGE plv8 IMMUTABLE STRICT;
