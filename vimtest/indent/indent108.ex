scope "/", API do
  pipe_through :api # Use the default browser stack

  get "/url", Controller, :index
  post "/url", Controller, :create
end
