import http from 'k6/http';
import { check } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 },
    { duration: '1m30s', target: 10 },
    { duration: '20s', target: 1 },
  ],
};

export default function () {
  let data = {
    sequence: "I like the sun",
    labels: ["summer", "winter"],
    multi_class: false
  };
  let res = http.post("http://localhost:8001/", JSON.stringify(data), {
    headers: { 'Content-Type': 'application/json' },
  });
  check(res, { 'status was 200': (r) => r.status == 200 });
}