require "spec_helper"

describe Lita::Handlers::Memegen, lita_handler: true do
  it { routes_command("Y U NO BLAH").to(:meme_y_u_no) }
  it { routes_command("i don't always fart but when i do, i do it loud").to(:meme_i_dont_always) }
  it { routes_command("blah you're gonna have a bad time").to(:meme_bad_time) }
  it { routes_command("what if i told you blah").to(:meme_what_if_i) }

  it "sets the username and password to nil by default" do
    expect(Lita.config.handlers.memegen.username).to be_nil
    expect(Lita.config.handlers.memegen.password).to be_nil
  end
end
