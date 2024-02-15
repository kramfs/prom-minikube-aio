// Full output:
// docker run --rm --network host -i grafana/k6 run - < load_test/stress.js
//
// Trend metrics summary -or- define it in the export options{}
// docker run --rm --network host -i grafana/k6 run --summary-trend-stats="avg,p(95)" - < load_test/stress.js

import http from "k6/http";
import { check, sleep } from 'k6';

// Stages[]: Start test in stages
export const options = {
  // iterations: 1000,
  // vus: 10,
  // duration: '60s'
  stages: [
    { duration: '30s', target: 60 },
    { duration: '60s', target: 200 },
    { duration: '1m', target: 300 },
    { duration: '60s', target: 600 },
    { duration: '30s', target: 400 },
    { duration: '30s', target: 50 },
    { duration: '30s', target: 120 },
    { duration: '30s', target: 300 },
    { duration: '30s', target: 700 },
    { duration: '30s', target: 100 },
    { duration: '1m30s', target: 300 },
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

  // sleep(1);
  sleep(Math.random() * 3);
}