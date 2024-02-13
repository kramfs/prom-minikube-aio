// Full output:
// docker run --rm --network host -i grafana/k6 run - < load_test/stress.js
//
// Trend metrics summary -or- define it in the export options{}
// docker run --rm --network host -i grafana/k6 run --summary-trend-stats="avg,p(95)" - < load_test/stress.js

import http from "k6/http";
import { check, sleep } from 'k6';

// Stages[]: Start test with 400 VUs for 10s, then ramp up to 800 VUs for 20s, then ramping up again
// 1500 VUs for over the next 60s before finally ramping down doing the reverse steps.
export const options = {
  // iterations: 1000,
  // vus: 10,
  // duration: '60s'
  stages: [
    { duration: '30s', target: 100 },
    { duration: '60s', target: 300 },
    { duration: '2m30s', target: 600 },
    { duration: '60s', target: 300 },
    { duration: '30s', target: 100 },
  ],
  //summaryTrendStats: ['avg', 'p(95)'],
};

export default function () {
  const foo = http.get("http://echo.dev.internal/foo");
  // check(response, { 'status was 200': (r) => r.status == 200 });
  check(foo, {
    'is status 200': (f) => f.status === 200,
    'verify output "foo" is correct': (f) =>
      f.body.includes('foo'),
  });

  const bar = http.get("http://echo.dev.internal/bar");
  // check(response, { 'status was 200': (r) => r.status == 200 });
  check(bar, {
    'is status 200': (b) => b.status === 200,
    'verify output "bar" is correct': (b) =>
      b.body.includes('bar'),
  });

  sleep(1);
}