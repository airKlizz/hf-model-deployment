import {check} from "k6";
import http from "k6/http";

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
