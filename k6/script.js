import {check} from "k6";
import http from "k6/http";

import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.1/index.js";

export const options = {
  stages: [
    {duration: "10", target: 20},
    {duration: "30s", target: 10},
    {duration: "5s", target: 1},
  ],
};

export default function () {
  let data = {
    sequence: "I like the sun",
    labels: ["summer", "winter"],
    multi_class: false,
  };
  let res = http.post(`http://${__ENV.URL}`, JSON.stringify(data), {
    headers: {"Content-Type": "application/json"},
  });
  check(res, {"status was 200": (r) => r.status == 200});
}

export function handleSummary(data) {
  var filename = `outputs/${__ENV.URL}_summary.html`
  return {
    [filename]: htmlReport(data),
    stdout: textSummary(data, { indent: " ", enableColors: true }),
  };
}