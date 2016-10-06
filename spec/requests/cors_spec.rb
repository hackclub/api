require "rails_helper"

describe "CORS", type: :request do
  it "returns the response CORS headers" do
    get "/v1/ping", headers: { "HTTP_ORIGIN" => "*" }

    expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
  end

  it "responds correctly to the CORS preflights OPTIONS request" do
    options "/", headers: {
              "HTTP_ORIGIN" => "*",
              "HTTP_ACCESS_CONTROL_REQUEST_METHOD" => "GET",
              "HTTP_ACCESS_CONTROL_REQUEST_HEADERS" => "test"
            }

    expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
    expect(response.headers["Access-Control-Allow-Methods"]).to eq("GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD")
    expect(response.headers["Access-Control-Allow-Headers"]).to eq("test")
    expect(response.headers).to have_key("Access-Control-Max-Age")
  end
end
